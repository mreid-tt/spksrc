# Reference

This section provides reference documentation for spksrc development.

## In This Section

- **[Architectures](architectures.md)** - CPU architectures and model mappings
- **[Ports](ports.md)** - Port allocations for Synology and SynoCommunity packages

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

**Synology Official Documentation:**

- [Package Developer Guide](https://help.synology.com/developer-guide/) - Official guide for DSM package development
- [Getting Started](https://help.synology.com/developer-guide/getting_started/gettingstarted.html) - Prerequisites and first steps
- [Package Structure](https://help.synology.com/developer-guide/synology_package/package_structure.html) - SPK file format and contents
- [Resource Files](https://help.synology.com/developer-guide/integrate_dsm/resource.html) - DSM 7 resource worker configuration
- [Privilege Configuration](https://help.synology.com/developer-guide/synology_package/privilege.html) - Service user and permissions
- [Synology Knowledge Base](https://kb.synology.com/) - General DSM documentation

**Source and Tools:**

- [Synology Toolkit (pkgscripts-ng)](https://github.com/SynologyOpenSource/pkgscripts-ng) - Official build toolkit
- [Synology GPL Source](https://sourceforge.net/projects/dsgpl/files/) - Toolchains and kernel sources
