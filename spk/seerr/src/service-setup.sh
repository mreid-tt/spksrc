# Seerr service setup for DSM 7+

SEERR_HOME="${SYNOPKG_PKGDEST}/share/seerr"
SEERR_VAR="${SYNOPKG_PKGVAR}"
STANDALONE_DIR="${SEERR_HOME}/.next/standalone"
PROXY_SERVER="${SEERR_HOME}/proxy-server.js"

# Service configuration
SEERR_PID_FILE="${SYNOPKG_PKGVAR}/seerr.pid"
PROXY_PID_FILE="${SYNOPKG_PKGVAR}/proxy.pid"

# Set NODE_OPTIONS with only supported flags
export NODE_OPTIONS="--dns-result-order=ipv4first --max-old-space-size=2048"

# Use standard Node.js path from DSM PATH and set service command
NODE_BIN="/usr/local/bin/node"

# Override start/stop functions to manage both Seerr and proxy
start_daemon() {
    # Start Seerr on port 5056 (localhost only)
    cd ${STANDALONE_DIR}
    PORT=5056 HOST=127.0.0.1 ${NODE_BIN} --env-file=${SEERR_HOME}/.env ${STANDALONE_DIR}/server.js >> ${LOG_FILE} 2>&1 &
    echo $! > ${SEERR_PID_FILE}
    
    # Give Seerr time to start
    sleep 3
    
    # Start proxy on port 5055 (external access)
    PROXY_PORT=5055 SEERR_PORT=5056 ${NODE_BIN} ${PROXY_SERVER} >> ${LOG_FILE} 2>&1 &
    echo $! > ${PROXY_PID_FILE}
}

stop_daemon() {
    # Stop proxy first
    if [ -f ${PROXY_PID_FILE} ]; then
        kill $(cat ${PROXY_PID_FILE}) 2>/dev/null
        rm -f ${PROXY_PID_FILE}
    fi
    
    # Stop Seerr
    if [ -f ${SEERR_PID_FILE} ]; then
        kill $(cat ${SEERR_PID_FILE}) 2>/dev/null
        rm -f ${SEERR_PID_FILE}
    fi
}

daemon_status() {
    if [ -f ${SEERR_PID_FILE} ] && [ -f ${PROXY_PID_FILE} ] && 
       kill -0 $(cat ${SEERR_PID_FILE}) 2>/dev/null && 
       kill -0 $(cat ${PROXY_PID_FILE}) 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

SERVICE_COMMAND="true" # Framework needs this defined

service_postinst() {
    # Create directories for database and backup
    mkdir -p "${SEERR_VAR}/config/db"
    mkdir -p "${SEERR_VAR}/backup"

    # Create database file if it doesn't exist
    [ -f "${SEERR_VAR}/config/db/seerr.db" ] || touch "${SEERR_VAR}/config/db/seerr.db"
   
    # Fix permissions for sc-seerr user
    chown -R sc-seerr:synocommunity "${SEERR_VAR}"
    chown sc-seerr:synocommunity "${SEERR_HOME}/.env"
    
    # Install http-proxy module if not present
    if [ ! -d "${SEERR_HOME}/node_modules/http-proxy" ]; then
        cd ${SEERR_HOME}
        npm install --no-save http-proxy 2>&1 | tee -a ${LOG_FILE}
    fi
}

service_preuninst() {
    # Stop service before uninstall
    return 0  
}
