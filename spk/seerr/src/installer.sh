#!/bin/sh
PACKAGE="seerr"
var_dir="/var/packages/${PACKAGE}/var"
conf_dir="${var_dir}/config"
log_dir="${var_dir}/logs"
backup_dir="${var_dir}/backup"

preinst() { exit 0; }

postinst() {
    install -d -m 755 "${conf_dir}"
    install -d -m 755 "${log_dir}"
    install -d -m 755 "${backup_dir}"
    install -d -m 755 "${conf_dir}/db"
    [ -f "${conf_dir}/db/seerr.db" ] || touch "${conf_dir}/db/seerr.db"
    chown -R "sc-${PACKAGE}:sc-${PACKAGE}" "${var_dir}" || true
    exit 0
}

preuninst() { exit 0; }
postuninst() { exit 0; }
preupgrade() { exit 0; }
postupgrade() { exit 0; }
