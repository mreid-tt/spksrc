# Icinga 2 service configuration

# Environment variables for icinga2 paths
export ICINGA2_CONFIG_FILE="${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf"
export ICINGA2_DATA_DIR="${SYNOPKG_PKGVAR}/lib/icinga2"
export ICINGA2_LOG_DIR="${SYNOPKG_PKGVAR}/log/icinga2"
export ICINGA2_CACHE_DIR="${SYNOPKG_PKGVAR}/cache/icinga2"
export ICINGA2_SPOOL_DIR="${SYNOPKG_PKGVAR}/spool/icinga2"
export ICINGA2_INIT_RUN_DIR="${SYNOPKG_PKGVAR}/run/icinga2"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/icinga2 daemon -c ${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

generate_api_password()
{
    # Generate a random password for API access
    head -c 32 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 24
}

service_postinst()
{
    # Create required directories
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2/crash"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2/compat"
    mkdir -p "${SYNOPKG_PKGVAR}/cache/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2/perfdata"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2/tmp"
    mkdir -p "${SYNOPKG_PKGVAR}/run/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/run/icinga2/cmd"

    # Copy default configuration if not present
    if [ ! -f "${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf" ]; then
        cp -r "${SYNOPKG_PKGDEST}/etc/icinga2/"* "${SYNOPKG_PKGVAR}/etc/icinga2/"
        # Use custom constants.conf with correct plugin paths
        cp "${SYNOPKG_PKGDEST}/share/constants.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/constants.conf"
        # Use custom hosts.conf with mail notifications disabled
        cp "${SYNOPKG_PKGDEST}/share/hosts.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/conf.d/hosts.conf"

        # Enable API feature by creating symlink
        ln -sf ../features-available/api.conf "${SYNOPKG_PKGVAR}/etc/icinga2/features-enabled/api.conf"

        # Create API user configuration
        API_PASSWORD=$(generate_api_password)
        cat > "${SYNOPKG_PKGVAR}/etc/icinga2/conf.d/api-users.conf" << EOF
/**
 * API Users for Icinga 2
 * Default user: admin
 * The password is auto-generated during installation.
 */

object ApiUser "admin" {
  password = "${API_PASSWORD}"
  permissions = [ "*" ]
}
EOF
        # Save credentials to a file for user reference
        cat > "${SYNOPKG_PKGVAR}/api-credentials.txt" << EOF
Icinga 2 API Credentials
========================
URL: https://<your-nas-ip>:5665
Username: admin
Password: ${API_PASSWORD}

API Documentation: https://icinga.com/docs/icinga-2/latest/doc/12-icinga2-api/
EOF
        chmod 600 "${SYNOPKG_PKGVAR}/api-credentials.txt"
    fi

    # Generate certificates for API if not present
    if [ ! -d "${SYNOPKG_PKGVAR}/lib/icinga2/certs" ]; then
        mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2/certs"
        HOSTNAME=$(hostname -f 2>/dev/null || hostname)
        # Generate CA and node certificates
        "${SYNOPKG_PKGDEST}/sbin/icinga2" pki new-ca 2>/dev/null || true
        "${SYNOPKG_PKGDEST}/sbin/icinga2" pki new-cert --cn "${HOSTNAME}" \
            --key "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${HOSTNAME}.key" \
            --cert "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${HOSTNAME}.crt" 2>/dev/null || true
        # Sign the certificate
        "${SYNOPKG_PKGDEST}/sbin/icinga2" pki sign-csr \
            --csr "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${HOSTNAME}.crt" \
            --cert "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${HOSTNAME}.crt" 2>/dev/null || true
        # Copy CA cert
        cp "${SYNOPKG_PKGVAR}/lib/icinga2/ca/ca.crt" "${SYNOPKG_PKGVAR}/lib/icinga2/certs/ca.crt" 2>/dev/null || true
    fi
}
