#!/bin/bash
# Icinga Web 2 service setup

# Set the install path
WEB_ROOT="/var/services/web_packages/icingaweb2"
ICINGAWEB2_CONF_DIR="${SYNOPKG_PKGVAR}/etc/icingaweb2"
ICINGA2_API_USER_FILE="/var/packages/icinga2/var/api-credentials.txt"
ICINGA2_IDO_CRED_FILE="/var/packages/icinga2/var/ido-credentials.txt"
CONF_TEMPLATES="${SYNOPKG_PKGDEST}/share/templates"

service_postinst ()
{
    # Create configuration directory structure
    mkdir -p "${ICINGAWEB2_CONF_DIR}"
    mkdir -p "${ICINGAWEB2_CONF_DIR}/modules/monitoring"
    mkdir -p "${ICINGAWEB2_CONF_DIR}/enabledModules"

    # Create log directory
    mkdir -p "${SYNOPKG_PKGVAR}/log"

    # Get database credentials from wizard (with defaults)
    DB_NAME="${wizard_db_name:-icingaweb2}"
    DB_USER="${wizard_db_user:-icingaweb2}"
    DB_PASS="${wizard_db_pass:-}"

    # Get IDO database credentials from icinga2 package
    IDO_DB_NAME="icinga_ido"
    IDO_DB_USER="icinga2"
    IDO_DB_PASS=""
    if [ -f "${ICINGA2_IDO_CRED_FILE}" ]; then
        IDO_DB_NAME=$(grep "^Database:" "${ICINGA2_IDO_CRED_FILE}" | cut -d: -f2 | tr -d ' ')
        IDO_DB_USER=$(grep "^Username:" "${ICINGA2_IDO_CRED_FILE}" | cut -d: -f2 | tr -d ' ')
        IDO_DB_PASS=$(grep "^Password:" "${ICINGA2_IDO_CRED_FILE}" | cut -d: -f2 | tr -d ' ')
    fi

    # Copy and configure resources.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/resources.ini" ]; then
        cp "${CONF_TEMPLATES}/resources.ini" "${ICINGAWEB2_CONF_DIR}/resources.ini"
        sed -i -e "s|@db_name@|${DB_NAME}|g" \
               -e "s|@db_user@|${DB_USER}|g" \
               -e "s|@db_pass@|${DB_PASS}|g" \
               -e "s|@ido_db_name@|${IDO_DB_NAME}|g" \
               -e "s|@ido_db_user@|${IDO_DB_USER}|g" \
               -e "s|@ido_db_pass@|${IDO_DB_PASS}|g" \
            "${ICINGAWEB2_CONF_DIR}/resources.ini"
    fi

    # Copy config.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/config.ini" ]; then
        cp "${CONF_TEMPLATES}/config.ini" "${ICINGAWEB2_CONF_DIR}/config.ini"
    fi

    # Copy authentication.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/authentication.ini" ]; then
        cp "${CONF_TEMPLATES}/authentication.ini" "${ICINGAWEB2_CONF_DIR}/authentication.ini"
    fi

    # Copy groups.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/groups.ini" ]; then
        cp "${CONF_TEMPLATES}/groups.ini" "${ICINGAWEB2_CONF_DIR}/groups.ini"
    fi

    # Copy roles.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/roles.ini" ]; then
        cp "${CONF_TEMPLATES}/roles.ini" "${ICINGAWEB2_CONF_DIR}/roles.ini"
    fi

    # Enable monitoring module by default
    if [ ! -L "${ICINGAWEB2_CONF_DIR}/enabledModules/monitoring" ]; then
        ln -sf "/var/packages/icingaweb2/target/share/icingaweb2/modules/monitoring" \
            "${ICINGAWEB2_CONF_DIR}/enabledModules/monitoring"
    fi

    # Copy monitoring module config.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/modules/monitoring/config.ini" ]; then
        cp "${CONF_TEMPLATES}/modules/monitoring/config.ini" "${ICINGAWEB2_CONF_DIR}/modules/monitoring/config.ini"
    fi

    # Copy monitoring module backends.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/modules/monitoring/backends.ini" ]; then
        cp "${CONF_TEMPLATES}/modules/monitoring/backends.ini" "${ICINGAWEB2_CONF_DIR}/modules/monitoring/backends.ini"
    fi

    # Copy and configure monitoring module commandtransports.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/modules/monitoring/commandtransports.ini" ]; then
        API_USER="admin"
        API_PASS=""
        if [ -f "${ICINGA2_API_USER_FILE}" ]; then
            API_USER=$(grep "^Username:" "${ICINGA2_API_USER_FILE}" | cut -d: -f2 | tr -d ' ')
            API_PASS=$(grep "^Password:" "${ICINGA2_API_USER_FILE}" | cut -d: -f2 | tr -d ' ')
        fi
        cp "${CONF_TEMPLATES}/modules/monitoring/commandtransports.ini" "${ICINGAWEB2_CONF_DIR}/modules/monitoring/commandtransports.ini"
        sed -i -e "s|@api_user@|${API_USER}|g" \
               -e "s|@api_pass@|${API_PASS}|g" \
            "${ICINGAWEB2_CONF_DIR}/modules/monitoring/commandtransports.ini"
    fi

    # Set permissions
    chmod -R 2770 "${ICINGAWEB2_CONF_DIR}"
    chown -R sc-icingaweb2:http "${ICINGAWEB2_CONF_DIR}"
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
