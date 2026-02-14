---
title: SynoCli Kernel Tools
description: Kernel and device utilities for Synology NAS
tags:
  - cli
  - kernel
  - tools
---

# SynoCli Kernel Tools

SynoCli Kernel Tools provides utilities for kernel and device management.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-kernel |
| License | GPL |

## Included Tools

| Tool | Description |
|------|-------------|
| fuser | Identify processes using files |
| usb-devices | List USB devices |
| usbhid-dump | Dump USB HID device data |
| synocli-kernelmodule.sh | Install kernel modules helper |

## Usage Examples

### fuser - Find Processes Using Files

```bash
# Find processes using a file
fuser /volume1/data/file.txt

# Find processes using a mount point
fuser -m /volume1

# Kill processes using a file
fuser -k /volume1/data/file.txt

# Show verbose output
fuser -v /volume1
```

### usb-devices - List USB Devices

```bash
# List all USB devices
usb-devices

# Output includes:
# - Device path
# - Vendor/Product IDs
# - Manufacturer/Product strings
# - Driver bindings
```

### synocli-kernelmodule.sh - Kernel Module Helper

This script helps install kernel modules from SynoKernel packages:

```bash
# Install kernel modules
sudo synocli-kernelmodule.sh install

# List available modules
synocli-kernelmodule.sh list
```

## Related Packages

- [SynoKernel USB Serial](synokernel-usbserial.md) - USB serial drivers
- [SynoKernel CD-ROM](synokernel-cdrom.md) - CD-ROM drivers
- [SynoCli Misc Tools](synocli-misc.md) - System utilities
