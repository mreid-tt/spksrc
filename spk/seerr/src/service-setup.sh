#!/bin/sh
# Seerr service setup

PACKAGE="seerr"

pkgdir="/var/packages/${PACKAGE}"
target="${pkgdir}/target"
vardir="${pkgdir}/var"
sharedir="${target}/share/seerr"
standalone_dir="${sharedir}/.next/standalone"
standalone_entry="${standalone_dir}/server.js"
env_template="${sharedir}/.env.template"

# Synology Node.js 22 package provides the runtime at install time.
NODE_PACKAGE="Node.js_v22"
node_shared="/var/packages/${NODE_PACKAGE}/target/usr/local/bin/node"

require_node_runtime() {
    if [ ! -x "${node_shared}" ]; then
        echo "Synology Node.js v22 package (${NODE_PACKAGE}) is required. Please install it first."
        exit 1
    fi
    export PATH="${PATH}:/var/packages/${NODE_PACKAGE}/target/usr/local/bin"
}
LOGFILE="${vardir}/logs/seerr.log"
PID_FILE="${vardir}/seerr.pid"
ENV_FILE="${vardir}/.env"

ensure_defaults() {
    install -d -m 755 "${vardir}/config"
    install -d -m 755 "${vardir}/logs"
    install -d -m 755 "${vardir}/backup"

    install -d -m 755 "${vardir}/config/db"
    [ -f "${vardir}/config/db/seerr.db" ] || touch "${vardir}/config/db/seerr.db"

    if [ ! -f "${ENV_FILE}" ]; then
        if [ -f "${env_template}" ]; then
            sed -e 's/^/#/' "${env_template}" > "${ENV_FILE}"
            cat <<'EOT' >>"${ENV_FILE}"

# Synology defaults
PORT=5055
TZ=Etc/UTC
LOG_LEVEL=info
DATABASE_TYPE=sqlite
DATABASE_URL=file:./config/db/seerr.db
BACKUP_PATH=/var/packages/seerr/var/backup
EOT
        else
            cat <<'EOT' >"${ENV_FILE}"
PORT=5055
TZ=Etc/UTC
LOG_LEVEL=info
DATABASE_TYPE=sqlite
DATABASE_URL=file:./config/db/seerr.db
BACKUP_PATH=/var/packages/seerr/var/backup
EOT
        fi
    fi
}

load_env() {
    ensure_defaults
    require_node_runtime
    export NODE_ENV=production
    if [ -r "${ENV_FILE}" ]; then
        while IFS='=' read -r key value; do
            case "${key}" in
                ''|"#"*)
                    continue
                    ;;
            esac
            export "${key}"="${value}"
        done <"${ENV_FILE}"
    fi
    export LOG_FILE="${LOGFILE}"
    export PATH="${target}/bin:${standalone_dir}/node_modules/.bin:/var/packages/${NODE_PACKAGE}/target/usr/local/bin:${PATH}"
}

start_daemon() {
    load_env
    if [ ! -f "${standalone_entry}" ]; then
        echo "Unable to find Seerr entrypoint at ${standalone_entry}" >&2
        exit 1
    fi
    su -s /bin/sh -m "sc-${PACKAGE}" -c "cd '${standalone_dir}' && ${node_shared} '${standalone_entry##*/}' >>'${LOGFILE}' 2>&1 & echo \$!" > "${PID_FILE}"
}

stop_daemon() {
    if [ -f "${PID_FILE}" ]; then
        pid=$(cat "${PID_FILE}")
        kill "${pid}" 2>/dev/null
        wait "${pid}" 2>/dev/null
        rm -f "${PID_FILE}"
    fi
}

status_daemon() {
    if [ -f "${PID_FILE}" ] && kill -0 $(cat "${PID_FILE}") 2>/dev/null; then
        return 0
    fi
    return 1
}

start_postprocess() { :; }
stop_postprocess() { :; }
