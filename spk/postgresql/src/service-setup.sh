# PostgreSQL service setup
# Supports DSM 6 (runs as root) and DSM 7 (runs as package user)
# EFF_USER is provided by the framework (sc-postgresql with SERVICE_USER=auto)

DATABASE_DIR="${SYNOPKG_PKGVAR}/data"
CFG_FILE="${DATABASE_DIR}/postgresql.conf"
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

# Wizard variables (required - no defaults)
PG_USERNAME=${wizard_pg_username}
PG_PASSWORD=${wizard_pg_password}

# Backup variables from uninstall wizard
PG_BACKUP=${wizard_pg_dump_directory}
BACKUP_DATE=$(date +%Y-%m-%d)
PG_BACKUP_CONF_DIR="${PG_BACKUP}/config_${BACKUP_DATE}"
PG_BACKUP_DUMP_DIR="${PG_BACKUP}/databases_${BACKUP_DATE}"

validate_preuninst()
{
    # Validate backup directory if user requested database backup
    if [ "${wizard_pg_dump_database}" = "true" ]; then
        if [ -z "${PG_BACKUP}" ]; then
            echo "Error: Backup directory path is empty."
            exit 1
        fi
        # Try to create directory if it doesn't exist
        if [ ! -d "${PG_BACKUP}" ]; then
            mkdir -p "${PG_BACKUP}" 2>/dev/null || {
                echo "Error: Unable to create backup directory ${PG_BACKUP}. Check permissions."
                exit 1
            }
        fi
        # Check write permissions
        if [ ! -w "${PG_BACKUP}" ]; then
            echo "Error: Backup directory ${PG_BACKUP} is not writable. Check permissions."
            exit 1
        fi
    fi
}

# Helper function to run commands as the effective user
# On DSM 7: scripts run as package user, so run directly
# On DSM 6: scripts run as root, so use su to switch user
run_as_user()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
        eval "$@"
    else
        su - ${EFF_USER} -s /bin/sh -c "$@"
    fi
}

service_postinst()
{
    # On DSM 6 (running as root), create data directory and set ownership
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        mkdir -p "${DATABASE_DIR}"
        chown -R ${EFF_USER}:$(id -gn ${EFF_USER}) "${SYNOPKG_PKGVAR}"
    fi

    # Initialize database cluster with UTF8 encoding
    run_as_user "${SYNOPKG_PKGDEST}/bin/initdb -D ${DATABASE_DIR} --encoding=UTF8 --locale=en_US.UTF8"

    # Configure postgresql.conf
    # Set port from SERVICE_PORT (avoids conflict with Synology's PostgreSQL on 5432)
    run_as_user "sed -e 's/^#port = 5432/port = ${SERVICE_PORT}/g' -i ${CFG_FILE}"
    # Listen on all interfaces
    run_as_user "sed -e \"s/^#listen_addresses = 'localhost'/listen_addresses = '*'/g\" -i ${CFG_FILE}"

    # Start server temporarily to create roles
    run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} -l ${LOG_FILE} start"

    # Set password for the system user
    run_as_user "${SYNOPKG_PKGDEST}/bin/psql -p ${SERVICE_PORT} -d postgres -c \"ALTER ROLE \\\"${EFF_USER}\\\" WITH PASSWORD '${PG_PASSWORD}';\""

    # Create administrator role from wizard
    run_as_user "${SYNOPKG_PKGDEST}/bin/psql -p ${SERVICE_PORT} -d postgres -c \"CREATE ROLE ${PG_USERNAME} PASSWORD '${PG_PASSWORD}' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION BYPASSRLS;\""

    # Stop server (will be started by DSM)
    run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} stop"
}

service_preuninst()
{
    # Backup databases on user's request
    if [ "${wizard_pg_dump_database}" = "true" ]; then
        # Start server for backup
        run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} -l ${LOG_FILE} start"

        # Create backup directories with package user ownership
        # Use install command which can set owner/group in one operation
        install -d -o ${EFF_USER} -g $(id -gn ${EFF_USER}) -m 755 "${PG_BACKUP_CONF_DIR}"
        install -d -o ${EFF_USER} -g $(id -gn ${EFF_USER}) -m 755 "${PG_BACKUP_DUMP_DIR}"

        # Backup configuration files
        cp "${DATABASE_DIR}/pg_hba.conf" "${PG_BACKUP_CONF_DIR}/"
        cp "${DATABASE_DIR}/pg_ident.conf" "${PG_BACKUP_CONF_DIR}/"
        cp "${DATABASE_DIR}/postgresql.auto.conf" "${PG_BACKUP_CONF_DIR}/"
        cp "${DATABASE_DIR}/postgresql.conf" "${PG_BACKUP_CONF_DIR}/"

        # Dump all databases (excluding templates)
        for database in $(run_as_user "${SYNOPKG_PKGDEST}/bin/psql -A -t -p ${SERVICE_PORT} -d postgres -c 'SELECT datname FROM pg_database WHERE datistemplate = false'"); do
            run_as_user "${SYNOPKG_PKGDEST}/bin/pg_dump -p ${SERVICE_PORT} -Fc ${database} -f ${PG_BACKUP_DUMP_DIR}/${database}.dump"
        done

        # Stop server
        run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} stop"
    fi
}
