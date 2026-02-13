# Resource Files (DSM 7)

Resource files are JSON configuration files that define package resources for DSM 7.

## Overview

DSM 7 introduced resource files as a declarative way to:

- Configure shared folder permissions
- Define network ports
- Create symlinks in system paths
- Set up web services

## File Locations

Resource files are placed in the package's conf directory:

```
spk/<package>/src/conf/resource
```

For DSM 7.2+ specific features:

```
spk/<package>/src/conf_72/resource
```

## Basic Structure

```json
{
    "data-share": { ... },
    "port-config": { ... },
    "usr-local-linker": { ... },
    "webservice": { ... }
}
```

## Data Shares

Define shared folder requirements and permissions:

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
    }
}
```

### Permission Types

| Type | Description |
|------|-------------|
| `rw` | Read/write access |
| `ro` | Read-only access |
| `na` | No access |

### Multiple Shares

```json
{
    "data-share": {
        "shares": [
            {
                "name": "{{wizard_data_share}}",
                "permission": {
                    "rw": ["{{wizard_data_share_user}}"]
                }
            },
            {
                "name": "{{wizard_backup_share}}",
                "permission": {
                    "rw": ["{{wizard_data_share_user}}"]
                }
            }
        ]
    }
}
```

## Port Configuration

Define ports used by the service:

```json
{
    "port-config": {
        "protocol-file": "etc/protocol"
    }
}
```

The protocol file (`spk/<package>/src/etc/protocol`) defines the actual ports:

```
[mypackage]
title = "Web Interface"
desc = "HTTP service"
port_forward = no
dst.ports = "8080/tcp"
```

### Protocol File Options

| Option | Description |
|--------|-------------|
| `title` | Display name |
| `desc` | Description |
| `port_forward` | Enable port forwarding |
| `dst.ports` | Port and protocol (e.g., "8080/tcp") |

## usr-local-linker

Create symlinks in `/usr/local/bin/` for command-line access:

```json
{
    "usr-local-linker": {
        "bin": ["mycommand", "myother"]
    }
}
```

This creates:
- `/usr/local/bin/mycommand` → `/var/packages/<pkg>/target/bin/mycommand`
- `/usr/local/bin/myother` → `/var/packages/<pkg>/target/bin/myother`

### Library Links

```json
{
    "usr-local-linker": {
        "lib": ["libfoo.so.1"]
    }
}
```

## Web Service

Configure web applications running under WebStation:

```json
{
    "webservice": {
        "services": [{
            "service": "mypackage",
            "display_name": "My Package",
            "type": "apache_php",
            "root": "web",
            "backend": 2,
            "icon": "ui/mypackage_{0}.png"
        }]
    }
}
```

### Service Types

| Type | Description |
|------|-------------|
| `apache_php` | PHP application |
| `nginx` | nginx web server |
| `node` | Node.js application |

### Backend Values

| Value | DSM 7.0-7.1 | DSM 7.2+ |
|-------|-------------|----------|
| 1 | Apache 2.2 | - |
| 2 | Apache 2.4 | Apache 2.4 |
| 3 | nginx | nginx |

## Variables in Resource Files

Wizard values can be referenced using Mustache syntax:

```json
{
    "data-share": {
        "shares": [{
            "name": "{{wizard_data_share}}"
        }]
    }
}
```

### Common Variables

| Variable | Source |
|----------|--------|
| `{{wizard_*}}` | From installation wizard |
| `{{SYNOPKG_PKGNAME}}` | Package name |
| `{{SYNOPKG_PKGVAR}}` | Package variable directory |

## DSM Version-Specific Resources

For different DSM versions, create separate conf directories:

```
spk/<package>/src/
├── conf/            # DSM 6 and DSM 7.0-7.1
│   └── resource
├── conf_7/          # DSM 7.0+
│   └── resource
└── conf_72/         # DSM 7.2+
    └── resource
```

The build system selects the appropriate version.

## Example: Complete Resource File

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

## Best Practices

1. **Minimal permissions** - Request only necessary folder access
2. **Document ports** - Use clear titles and descriptions
3. **Version-specific files** - Create separate resources for DSM 7.2+ features
4. **Test thoroughly** - Verify on actual DSM installations
