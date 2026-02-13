# Package Anatomy

This page explains the structure of spksrc packages and how the different components fit together.

## Directory Structure

spksrc has a flat directory structure with three main areas:

```
spksrc/
├── cross/           # Cross-compiled libraries and tools
│   ├── curl/
│   ├── openssl/
│   └── ...
├── native/          # Tools built for the build host
│   ├── cmake/
│   └── ...
├── spk/             # Final SPK packages
│   ├── transmission/
│   ├── git/
│   └── ...
├── mk/              # Build system makefiles
├── toolchain/       # Synology toolchains (downloaded)
├── distrib/         # Downloaded source files (cache)
└── packages/        # Built SPK files (output)
```

## Cross Package Structure

A `cross/` package compiles software for the target NAS architecture:

```
cross/curl/
├── Makefile         # Build configuration
├── digests          # Checksums for source files
├── PLIST            # List of installed files (optional)
└── patches/         # Source code patches (optional)
    └── 001-fix-something.patch
```

### Cross Package Makefile

```makefile
PKG_NAME = curl
PKG_VERS = 8.4.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://curl.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = https://curl.se/
COMMENT  = Command line tool and library for transferring data
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ssl --with-zlib

include ../../mk/spksrc.cross-cc.mk
```

Key variables:

| Variable | Purpose |
|----------|--------|
| `PKG_NAME` | Package name |
| `PKG_VERS` | Package version |
| `PKG_DIST_SITE` | Download URL |
| `DEPENDS` | Other cross packages this depends on |
| `GNU_CONFIGURE` | Set to 1 if package uses autoconf |
| `CONFIGURE_ARGS` | Additional configure arguments |

## SPK Package Structure

An `spk/` package creates the final installable SPK:

```
spk/transmission/
├── Makefile         # SPK configuration
├── CHANGELOG        # Version history
├── LICENSE          # License file (optional)
├── PLIST            # Files to include
└── src/             # Package-specific files
    ├── service-setup.sh    # Service configuration
    ├── dsm-control.sh      # Start/stop script (DSM 6)
    ├── conf/               # Configuration files
    │   └── resource         # DSM 7 resource file
    └── wizard_templates/   # Install wizard (optional)
        ├── install_uifile
        └── install_uifile.yml
```

### SPK Makefile

```makefile
SPK_NAME = transmission
SPK_VERS = 4.1.0
SPK_REV = 1
SPK_ICON = src/transmission.png

DEPENDS = cross/transmission
SPK_DEPENDS = "WebStation>=3.0"

MAINTAINER = SynoCommunity
DESCRIPTION = Fast, easy, and free BitTorrent client
DISPLAY_NAME = Transmission
CHANGELOG = "Update to v4.1.0"

HOMEPAGE = https://transmissionbt.com/
LICENSE = GPLv2/GPLv3

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

include ../../mk/spksrc.spk.mk
```

Key variables:

| Variable | Purpose |
|----------|--------|
| `SPK_NAME` | Package name shown in Package Center |
| `SPK_VERS` | Version shown to users |
| `SPK_REV` | Package revision (increment for same version) |
| `DEPENDS` | Cross packages to include |
| `SPK_DEPENDS` | Other SPK packages required |
| `SERVICE_USER` | Create dedicated user (auto/specific name) |
| `STARTABLE` | Whether package has a service to start |

## PLIST Files

PLIST files define which files to include in the package:

```
bin:bin/transmission-daemon
bin:bin/transmission-remote
lib:lib/libtransmission.so
```

Format: `<destination>:<source path>`

Common destinations:

| Destination | Location on NAS |
|-------------|----------------|
| `bin` | `/var/packages/<pkg>/target/bin/` |
| `lib` | `/var/packages/<pkg>/target/lib/` |
| `share` | `/var/packages/<pkg>/target/share/` |
| `etc` | `/var/packages/<pkg>/target/etc/` |

See [PLIST Files](../packaging/plist.md) for detailed documentation.

## Service Scripts

Packages with daemons use service scripts:

**service-setup.sh** - Defines service variables:

```bash
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/transmission-daemon"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
```

**dsm-control.sh** (DSM 6) - Start/stop/status commands:

```bash
case $1 in
    start)
        ${SYNOPKG_PKGDEST}/bin/transmission-daemon
        ;;
    stop)
        killall transmission-daemon
        ;;
esac
```

See [Service Scripts](../packaging/service-scripts.md) for detailed documentation.

## Build Artifacts

During builds, spksrc creates work directories:

```
cross/curl/
└── work-x64-7.2/           # Per-architecture build
    ├── curl-8.4.0/          # Extracted source
    ├── install/             # Installed files
    └── staging/             # Files for SPK

spk/transmission/
└── work-x64-7.2/
    ├── staging/             # All files for SPK
    ├── image/               # Package layout
    └── transmission-x64-7.2.spk
```

## Next Steps

- **[Build Workflow](build-workflow.md)** - Learn the build process
- **[Packaging Guide](../packaging/index.md)** - Create your own package
