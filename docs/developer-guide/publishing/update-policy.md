# Update Policy and Process

This guide covers the SynoCommunity package update policy, including supported DSM versions, build priorities, and the publish workflow.

## Supported DSM Versions

| Version | Status | Notes |
|---------|--------|-------|
| DSM 7.1 | **Active** | Primary target |
| DSM 7.2 | **Active** | Supported (opt-in) |
| DSM 6.2.4+ | **Active** | Supported |
| DSM 6.0-6.2.3 | Limited | May work, not tested |
| DSM 5.2 | Legacy | On request only |
| SRM 1.x | Limited | Manual install only |

!!! note
    DSM 5.2 packages are no longer built automatically. Older toolchains may not support recent upstream versions.


## Testing Checklist

Before publishing, verify:

### Package Features

- [ ] Description translations are correct
- [ ] Wizard pages function correctly (install and upgrade)
- [ ] Wizard translations are complete

### Service Operation

- [ ] Service starts from Package Center (verify with `ps`)
- [ ] Service stops from Package Center (verify with `ps`)
- [ ] "View log" button works (DSM 6.x only)
- [ ] Log files exist in `/var/packages/{package}/var/`
- [ ] DSM shortcut opens the interface

### Command Line Tools

- [ ] Binaries appear in PATH (via `/usr/local/bin` links)
- [ ] Version commands work (`--version`, `-v`)
- [ ] Help commands work (`--help`, `-h`)

### Uninstall

- [ ] Package removes cleanly from `/var/packages/{package}/`
- [ ] Service account removed from `/etc/passwd`

## Build Process

### Building for All Architectures

Build all supported architectures in parallel:

```bash
make -j$(nproc) all-supported
```

Or build specific architectures:

```bash
make -j$(nproc) arch-x64-7.1 arch-armv7-7.1 arch-aarch64-7.1
```

### Generic Architectures

These architectures generate a single package for multiple CPU models:

| Generic Arch | Covers |
|--------------|--------|
| x64 | All Intel/AMD 64-bit |
| armv7 | 32-bit ARM Cortex |
| aarch64 | 64-bit ARM |

## Publish Process

### Prerequisites

1. Get your API key from [synocommunity.com/profile](https://synocommunity.com/profile)
2. Create `local.mk` in the spksrc root:

```makefile
PUBLISH_URL = https://api.synocommunity.com
PUBLISH_API_KEY = <your-key>
DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com/
REPORT_URL = https://github.com/SynoCommunity/spksrc/issues
DEFAULT_TC = 7.1 7.2
```

Or generate automatically:

```bash
make setup-synocommunity
```

### Publishing

Publish packages (one at a time, not parallel):

```bash
make publish-all-supported
```

Or specific architectures:

```bash
make publish-arch-x64-7.1 publish-arch-armv7-7.1 publish-arch-aarch64-7.1
```

!!! warning
    Do not parallelize publishing. The spkrepo server cannot handle concurrent uploads.

### Repository Activation

After publishing:

1. Log in at [synocommunity.com/admin/](https://synocommunity.com/admin/)
2. Check your builds at [synocommunity.com/admin/build/](https://synocommunity.com/admin/build/)
3. Activate your test build
4. Install/upgrade from DSM Package Center to verify signing
5. If successful, activate the Version at [synocommunity.com/admin/version/](https://synocommunity.com/admin/version/)

## Dynamic Library Linking

Some packages share dependencies through dynamic linking:

```bash
cd spk/chromaprint
for arch in x64 evansport 88f6281 armv7 aarch64 hi3535; do
    make publish ARCH=$arch TCVERSION=7.1
done
```

Packages using this pattern: tvheadend, chromaprint, comskip

## SRM Packages

SRM (Synology Router Manager) has no Package Center custom repository support.

Users must:

1. Download packages manually from [synocommunity.com/packages](https://synocommunity.com/packages)
2. Install via manual upload

Build SRM packages:

```bash
make publish ARCH=armv7 TCVERSION=1.2
```
