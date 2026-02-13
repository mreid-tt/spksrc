# Service Scripts

This page covers how to configure services and daemons in spksrc packages.

## Overview

Packages that run background services need:

1. **service-setup.sh** - Defines service variables and configuration
2. **Resource file** (DSM 7) - Defines shared folder requirements, ports, etc.
3. **dsm-control.sh** (DSM 6) - Start/stop control script

## Service Setup Script

Create `spk/<package>/src/service-setup.sh`:

```bash
# Service command to run
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/mydaemon"

# Arguments passed to service command
SERVICE_COMMAND_ARGS="--config ${SYNOPKG_PKGVAR}/config.ini"

# Run in background (service doesn't daemonize itself)
SVC_BACKGROUND=y

# Write PID file
SVC_WRITE_PID=y
```

### Common Variables

| Variable | Description |
|----------|-------------|
| `SERVICE_COMMAND` | Path to the service executable |
| `SERVICE_COMMAND_ARGS` | Arguments passed to the command |
| `SVC_BACKGROUND` | Set to `y` if service should be backgrounded |
| `SVC_WRITE_PID` | Set to `y` to write PID file |
| `SVC_CWD` | Working directory for the service |
| `SVC_UMASK` | Umask for the service |

### Environment Variables Available

| Variable | Description |
|----------|-------------|
| `SYNOPKG_PKGNAME` | Package name |
| `SYNOPKG_PKGDEST` | Package installation directory |
| `SYNOPKG_PKGVAR` | Package variable data directory |
| `SYNOPKG_PKGHOME` | Package home directory |
| `SYNOPKG_PKGPORT` | Main port (if defined) |
| `SYNOPKG_DSM_VERSION_MAJOR` | DSM major version |

## Service Hooks

Add functions to run at specific lifecycle points:

```bash
# Called after installation
service_postinst() {
    # Create initial configuration
    if [ ! -f "${SYNOPKG_PKGVAR}/config.ini" ]; then
        cp "${SYNOPKG_PKGDEST}/share/config.sample.ini" "${SYNOPKG_PKGVAR}/config.ini"
    fi
}

# Called after upgrade
service_postupgrade() {
    # Migrate configuration if needed
    :;
}

# Called before service starts
service_prestart() {
    # Validate configuration
    if [ ! -f "${SYNOPKG_PKGVAR}/config.ini" ]; then
        echo "Configuration file missing" >&2
        return 1
    fi
}

# Called after service starts
service_poststart() {
    # Additional setup after service is running
    :;
}

# Called before service stops
service_prestop() {
    # Cleanup before stopping
    :;
}

# Called before uninstall
service_preuninst() {
    # Backup data if needed
    :;
}

# Called after uninstall
service_postuninst() {
    # Final cleanup
    :;
}
```

### Lifecycle Order

**Installation:**
1. Package extracted
2. `service_postinst()` called
3. Service started (if `STARTABLE=yes`)

**Upgrade:**
1. Service stopped
2. `service_preuninst()` called
3. Old package removed
4. New package extracted
5. `service_postinst()` called
6. `service_postupgrade()` called
7. Service started

**Uninstall:**
1. Service stopped
2. `service_preuninst()` called
3. Package removed
4. `service_postuninst()` called

## Resource Files (DSM 7)

DSM 7 uses resource files for enhanced integration. Create `spk/<package>/src/conf/resource`:

```json
{
    "data-share": {
        "shares": [
            {
                "name": "{{wizard_data_share}}",
                "permission": {
                    "rw": ["{{wizard_data_share_user}}"]
                }
            }
        ]
    },
    "port-config": {
        "protocol-file": "etc/protocol"
    },
    "usr-local-linker": {
        "bin": ["mycommand"]
    }
}
```

### Resource Features

| Feature | Description |
|---------|-------------|
| `data-share` | Shared folder permissions |
| `port-config` | Port configuration |
| `usr-local-linker` | Create symlinks in `/usr/local/bin` |
| `webservice` | Web application configuration |

## DSM 6 Control Script

For DSM 6 compatibility, create `spk/<package>/src/dsm-control.sh`:

```bash
#!/bin/bash

PIDFILE="${SYNOPKG_PKGVAR}/daemon.pid"
DAEMON="${SYNOPKG_PKGDEST}/bin/mydaemon"

case $1 in
    start)
        $DAEMON --config "${SYNOPKG_PKGVAR}/config.ini" &
        echo $! > "$PIDFILE"
        ;;
    stop)
        if [ -f "$PIDFILE" ]; then
            kill $(cat "$PIDFILE")
            rm -f "$PIDFILE"
        fi
        ;;
    status)
        if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
            exit 0
        else
            exit 1
        fi
        ;;
    log)
        echo "${SYNOPKG_PKGVAR}/logs/daemon.log"
        ;;
esac
```

## Makefile Configuration

```makefile
STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# Optional: Define port
SERVICE_PORT = 8080
SERVICE_PORT_TITLE = Web Interface

# Optional: Shared folder wizard variable
SERVICE_WIZARD_SHARENAME = wizard_data_share
```

### Service User Options

| Value | Description |
|-------|-------------|
| `auto` | Create `sc-<packagename>` user |
| `<username>` | Use specific existing user |
| (not set) | Run as root |

## Best Practices

1. **Use dedicated user** - Set `SERVICE_USER = auto`
2. **Handle configuration** - Check for and create default configs
3. **Log appropriately** - Write logs to `${SYNOPKG_PKGVAR}/logs/`
4. **Clean shutdown** - Handle SIGTERM gracefully
5. **Support both DSM versions** - Include both resource file and dsm-control.sh
6. **Validate in prestart** - Check requirements before starting
