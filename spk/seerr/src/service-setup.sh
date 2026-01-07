# Seerr service setup for DSM 7+

SEERR_HOME="${SYNOPKG_PKGDEST}/share/seerr"
SEERR_VAR="${SYNOPKG_PKGVAR}"
STANDALONE_DIR="${SEERR_HOME}/.next/standalone"

# Service configuration
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_CWD="${STANDALONE_DIR}"

# Set NODE_OPTIONS with only supported flags
export NODE_OPTIONS="--dns-result-order=ipv4first --max-old-space-size=2048"

# Use standard Node.js path from DSM PATH and set service command
NODE_BIN="/usr/local/bin/node"
SERVICE_COMMAND="${NODE_BIN} --env-file=${SEERR_HOME}/.env ${STANDALONE_DIR}/server.js"

service_postinst() {
    # Create directories for database and backup
    mkdir -p "${SEERR_VAR}/config/db"
    mkdir -p "${SEERR_VAR}/backup"

    # Create database file if it doesn't exist
    [ -f "${SEERR_VAR}/config/db/seerr.db" ] || touch "${SEERR_VAR}/config/db/seerr.db"
   
    # Fix permissions for sc-seerr user
    chown -R sc-seerr:synocommunity "${SEERR_VAR}"
    chown sc-seerr:synocommunity "${SEERR_HOME}/.env"
}

service_preuninst() {
    # Stop service before uninstall
    return 0  
}
