# Reference

This section provides reference documentation for spksrc development.

## In This Section

- **[Architectures](architectures.md)** - CPU architectures and model mappings
- **[Ports](ports.md)** - Port allocations for Synology and SynoCommunity packages
- **[Makefile Reference](makefile-reference.md)** - Complete variable and target reference

## Quick Links

### Build System

| Topic | Description |
|-------|-------------|
| [Makefile Variables](../developer-guide/packaging/makefile-variables.md) | Common variables |
| [Build Rules](../developer-guide/packaging/build-rules.md) | Build targets and hooks |
| [PLIST Files](../developer-guide/packaging/plist.md) | Package contents |

### Package Types

| Type | Include File |
|------|-------------|
| Standard C/C++ | `spksrc.cross-cc.mk` |
| CMake | `spksrc.cross-cmake.mk` |
| Meson | `spksrc.cross-meson.mk` |
| Go | `spksrc.cross-go.mk` |
| Rust | `spksrc.cross-rust.mk` |
| Python | `spksrc.python.mk` |

### External Resources

- [Synology DSM Developer Guide](https://help.synology.com/developer-guide/)
- [Package Center Specifications](https://help.synology.com/developer-guide/synology_package/)
- [Synology Knowledge Base](https://kb.synology.com/)
