# Icinga 2 Agent service configuration

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/icinga2 daemon -c ${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

generate_password ()
{
    head -c 32 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 24
}

validate_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if [ -z "${wizard_master_host}" ]; then
            echo "Master server hostname is required"
            exit 1
        fi
    fi
}

service_postinst ()
{
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2/conf.d"
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2/features-enabled"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2/crash"
    mkdir -p "${SYNOPKG_PKGVAR}/cache/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2/perfdata"
    mkdir -p "${SYNOPKG_PKGVAR}/run/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/run/icinga2/cmd"

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if [ ! -f "${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf" ]; then
            master_host="${wizard_master_host}"
            master_port="${wizard_master_port:-5665}"
            agent_name="${wizard_agent_name:-$(hostname)}"
            agent_password=$(generate_password)
            plugin_dir="${SYNOPKG_PKGDEST}/target/usr/lib/nagios/plugins"

            # Copy templates and customize
            cp "${SYNOPKG_PKGDEST}/share/templates/icinga2.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf"

            sed -e "s|@@PLUGIN_DIR@@|${plugin_dir}|g" \
                -e "s|@@NODE_NAME@@|${agent_name}|g" \
                "${SYNOPKG_PKGDEST}/share/templates/constants.conf" > "${SYNOPKG_PKGVAR}/etc/icinga2/constants.conf"

            sed -e "s|@@MASTER_HOST@@|${master_host}|g" \
                -e "s|@@MASTER_PORT@@|${master_port}|g" \
                -e "s|@@AGENT_NAME@@|${agent_name}|g" \
                "${SYNOPKG_PKGDEST}/share/templates/zones.conf" > "${SYNOPKG_PKGVAR}/etc/icinga2/zones.conf"

            sed -e "s|@@API_PASSWORD@@|${agent_password}|g" \
                "${SYNOPKG_PKGDEST}/share/templates/api-users.conf" > "${SYNOPKG_PKGVAR}/etc/icinga2/conf.d/api-users.conf"

            # Enable API feature
            ln -sf "../features-available/api.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/features-enabled/api.conf"

            # Generate self-signed certificate for initial setup
            mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2/certs"
            if [ ! -f "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${agent_name}.crt" ]; then
                openssl req -new -x509 -keyout "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${agent_name}.key" \
                    -out "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${agent_name}.crt" \
                    -days 365 -nodes -subj "/CN=${agent_name}" 2>/dev/null
                cp "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${agent_name}.crt" \
                    "${SYNOPKG_PKGVAR}/lib/icinga2/certs/ca.crt" 2>/dev/null
            fi

            # Fetch master's certificate so agent trusts the master
            mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2/certs"
            "${SYNOPKG_PKGDEST}/sbin/icinga2" pki save-cert --host "${master_host}" --port "${master_port}" \
                --trustedcert "${SYNOPKG_PKGVAR}/lib/icinga2/certs/trusted-master.crt" 2>/dev/null || true

            # Secure config directory
            find "${SYNOPKG_PKGVAR}/etc/icinga2" -type f -exec chmod 640 {} \;
            find "${SYNOPKG_PKGVAR}/etc/icinga2" -type d -exec chmod 750 {} \;
        fi
    fi

    return 0
}
