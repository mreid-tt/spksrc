#!/bin/bash
# Icinga Web 2 service setup

# Set the install path
WEB_ROOT="/var/services/web_packages/icingaweb2"
ICINGAWEB2_CONF_DIR="${SYNOPKG_PKGVAR}/etc/icingaweb2"
ICINGA2_API_USER_FILE="/var/packages/icinga2/var/api-credentials.txt"

service_postinst ()
{
    # Create configuration directory
    mkdir -p "${ICINGAWEB2_CONF_DIR}"
    mkdir -p "${ICINGAWEB2_CONF_DIR}/modules"
    mkdir -p "${ICINGAWEB2_CONF_DIR}/enabledModules"

    # Create log directory
    mkdir -p "${SYNOPKG_PKGVAR}/log"

    # Set permissions
    chmod -R 2770 "${ICINGAWEB2_CONF_DIR}"
    chown -R sc-icingaweb2:http "${ICINGAWEB2_CONF_DIR}"

    # Get database credentials from wizard (with defaults)
    DB_NAME="${wizard_db_name:-icingaweb2}"
    DB_USER="${wizard_db_user:-icingaweb2}"
    DB_PASS="${wizard_db_pass:-}"

    # Create initial resources.ini for database connection
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/resources.ini" ]; then
        cat > "${ICINGAWEB2_CONF_DIR}/resources.ini" <<EOF
[icingaweb_db]
type = "db"
db = "mysql"
host = "localhost"
port = "3306"
dbname = "${DB_NAME}"
username = "${DB_USER}"
password = "${DB_PASS}"
charset = "utf8mb4"
use_ssl = "0"

[icinga_ido]
type = "db"
db = "mysql"
host = "localhost"
port = "3306"
dbname = "icinga2"
username = "icinga2"
password = ""
charset = "utf8mb4"
use_ssl = "0"
EOF
    fi

    # Create initial config.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/config.ini" ]; then
        cat > "${ICINGAWEB2_CONF_DIR}/config.ini" <<EOF
[global]
show_stacktraces = "0"
show_application_state_messages = "1"
module_path = "/var/packages/icingaweb2/target/share/icingaweb2/modules"
config_backend = "db"
config_resource = "icingaweb_db"

[logging]
log = "syslog"
level = "ERROR"
application = "icingaweb2"
facility = "user"
EOF
    fi

    # Create authentication.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/authentication.ini" ]; then
        cat > "${ICINGAWEB2_CONF_DIR}/authentication.ini" <<EOF
[icingaweb2]
backend = "db"
resource = "icingaweb_db"
EOF
    fi

    # Create groups.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/groups.ini" ]; then
        cat > "${ICINGAWEB2_CONF_DIR}/groups.ini" <<EOF
[icingaweb2]
backend = "db"
resource = "icingaweb_db"
EOF
    fi

    # Create roles.ini with default admin role
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/roles.ini" ]; then
        cat > "${ICINGAWEB2_CONF_DIR}/roles.ini" <<EOF
[Administrators]
users = "admin"
permissions = "*"
groups = "Administrators"
EOF
    fi

    # Enable monitoring module by default
    if [ ! -L "${ICINGAWEB2_CONF_DIR}/enabledModules/monitoring" ]; then
        ln -sf "/var/packages/icingaweb2/target/share/icingaweb2/modules/monitoring" \
            "${ICINGAWEB2_CONF_DIR}/enabledModules/monitoring"
    fi

    # Create monitoring module configuration
    mkdir -p "${ICINGAWEB2_CONF_DIR}/modules/monitoring"
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/modules/monitoring/config.ini" ]; then
        cat > "${ICINGAWEB2_CONF_DIR}/modules/monitoring/config.ini" <<EOF
[security]
protected_customvars = "*pw*,*pass*,community"
EOF
    fi

    if [ ! -f "${ICINGAWEB2_CONF_DIR}/modules/monitoring/backends.ini" ]; then
        cat > "${ICINGAWEB2_CONF_DIR}/modules/monitoring/backends.ini" <<EOF
[icinga]
type = "ido"
resource = "icinga_ido"
EOF
    fi

    if [ ! -f "${ICINGAWEB2_CONF_DIR}/modules/monitoring/commandtransports.ini" ]; then
        # Try to read Icinga 2 API credentials if available
        API_USER="root"
        API_PASS=""
        if [ -f "${ICINGA2_API_USER_FILE}" ]; then
            API_USER=$(grep "^user=" "${ICINGA2_API_USER_FILE}" | cut -d= -f2)
            API_PASS=$(grep "^password=" "${ICINGA2_API_USER_FILE}" | cut -d= -f2)
        fi
        cat > "${ICINGAWEB2_CONF_DIR}/modules/monitoring/commandtransports.ini" <<EOF
[icinga2]
transport = "api"
host = "127.0.0.1"
port = "5665"
username = "${API_USER}"
password = "${API_PASS}"
EOF
    fi
}

service_prestart ()
{
    # Create symlink for config directory if not exists
    ICINGAWEB2_SHARE="/var/packages/icingaweb2/target/share/icingaweb2"
    if [ -d "${ICINGAWEB2_SHARE}" ] && [ ! -L "${ICINGAWEB2_SHARE}/config" ]; then
        rm -rf "${ICINGAWEB2_SHARE}/config" 2>/dev/null
        ln -sf "${ICINGAWEB2_CONF_DIR}" "${ICINGAWEB2_SHARE}/config"
    fi
}
