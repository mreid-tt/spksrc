# Simple Seerr service setup for DSM 7+

SEERR_HOME="${SYNOPKG_PKGDEST}/share/seerr"
SEERR_VAR="${SYNOPKG_PKGVAR}"
STANDALONE_DIR="${SEERR_HOME}/.next/standalone"
# Use standard Node.js path from DSM PATH
NODE_BIN="/usr/local/bin/node"

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

# DSM 7+ service functions
start_daemon() {
   # Set NODE_OPTIONS with only supported flags
   export NODE_OPTIONS="--dns-result-order=ipv4first --max-old-space-size=2048"
    
    # Try to increase file descriptor limits for the process
    # This helps prevent EMFILE errors
    if command -v prlimit >/dev/null 2>&1; then
        # Try to use prlimit to increase file descriptor limits
        prlimit --nofile=65536:65536 --pid=$$ 2>/dev/null || true
    fi

   cd "${STANDALONE_DIR}"
   # Use --env-file to load environment variables from the installed .env file
   exec "${NODE_BIN}" --env-file="${SEERR_HOME}/.env" server.js >> "${SEERR_VAR}/logs/seerr.log" 2>&1
}

stop_daemon() {
    # DSM handles process management
    return 0
}

daemon_status() {
    # DSM handles status checks
    return 0
}

# Compatibility functions if needed
validate_preinst() { return 0; }
validate_preuninst() { return 0; }
