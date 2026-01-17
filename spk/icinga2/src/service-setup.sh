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
    fi
}
