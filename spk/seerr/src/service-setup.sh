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
    # Create directories
    mkdir -p "${SEERR_VAR}/config/db"
    mkdir -p "${SEERR_VAR}/logs"
    mkdir -p "${SEERR_VAR}/backup"

    # Create database file if it doesn't exist
    [ -f "${SEERR_VAR}/config/db/seerr.db" ] || touch "${SEERR_VAR}/config/db/seerr.db"
   
    # Fix permissions for sc-seerr user
    chown -R sc-seerr:synocommunity "${SEERR_VAR}"
    chown sc-seerr:synocommunity "${SEERR_HOME}/.env"
    chmod 755 "${SEERR_VAR}/logs"
    
    # Ensure log file is writable
    touch "${SEERR_VAR}/logs/seerr.log"
    chmod 666 "${SEERR_VAR}/logs/seerr.log"
    
    # Add a simple hosts file workaround for EMFILE issues
    # Seerr sometimes calls itself at 0.0.0.0 which can cause too many connections
    # This helps ensure it resolves to localhost properly
    if ! grep -q "127.0.0.1.*localhost" /etc/hosts 2>/dev/null; then
        echo "# Added by seerr package" >> /etc/hosts
        echo "127.0.0.1 localhost" >> /etc/hosts
    fi
}

service_preuninst() {
    # Stop service before uninstall
    return 0  
}
