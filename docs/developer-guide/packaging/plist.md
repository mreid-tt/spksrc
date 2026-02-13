# PLIST Files

PLIST (Package List) files define which files are included in a package.

## Purpose

PLIST files serve several purposes:

1. **Include files** - Specify which files go into the SPK
2. **Set destinations** - Define where files are installed
3. **Set permissions** - Configure file ownership and modes
4. **Track files** - Used during upgrades and uninstalls

## File Location

- `cross/<package>/PLIST` - For cross packages
- `spk/<package>/PLIST` - For SPK packages (if needed)

## Basic Format

```
<destination>:<source_path>
```

### Example

```
bin:bin/myapp
lib:lib/libfoo.so.1
share:share/myapp/data.txt
etc:etc/myapp.conf
```

## Destination Types

| Destination | Location on NAS | Description |
|-------------|-----------------|-------------|
| `bin` | `target/bin/` | Executables |
| `lib` | `target/lib/` | Libraries |
| `share` | `target/share/` | Data files |
| `etc` | `target/etc/` | Configuration |
| `include` | `target/include/` | Headers (rarely used) |
| `var` | `var/` | Variable data |

## Wildcards

### Glob Patterns

```
# All .so files
lib:lib/*.so

# All .so files recursively
lib:lib/*.so*

# All files in directory
share:share/myapp/*
```

### Recursive Inclusion

```
# Use rr: prefix for recursive
rr:share:share/myapp
```

This includes all files under `share/myapp/` maintaining directory structure.

## Permissions

### Basic Permissions

```
# Format: destination:path:mode:owner:group
bin:bin/myapp:0755
lib:lib/libfoo.so:0644
etc:etc/myapp.conf:0600
```

### With Owner/Group

```
bin:bin/myapp:0755:root:root
var:var/data:0750:sc-myapp:sc-myapp
```

## Special Entries

### Directories

```
# Create empty directory
d:var/cache:0755

# Create directory with permissions
d:var/log:0750:sc-myapp:sc-myapp
```

### Symbolic Links

```
# Create symlink
l:bin/link:target/bin/real
```

## Generated PLIST

For cross packages, PLIST can be auto-generated:

```bash
make -C cross/mypackage plist
```

This creates PLIST from the staging directory contents.

### Filtering Generated PLIST

Edit the generated PLIST to:

- Remove unnecessary files (docs, man pages)
- Adjust permissions
- Add special entries

## Best Practices

### Do Include

- Executables the user will run
- Libraries required at runtime
- Configuration templates
- Essential data files

### Don't Include

- Development headers (unless needed)
- Static libraries (usually)
- Man pages (saves space)
- Documentation (link to online docs instead)

### Common Patterns

```
# Binary with library
bin:bin/myapp
lib:lib/libmyapp.so*

# Application with data
bin:bin/myapp
rr:share:share/myapp

# Python application
rr:lib:lib/python*/site-packages/myapp
bin:bin/myapp
```

## Debugging PLIST Issues

### View Staging Contents

```bash
find cross/mypackage/work-x64-7.2/staging -type f
```

### Compare with PLIST

```bash
# What's in staging but not in PLIST
comm -23 <(find work-*/staging -type f | sort) <(cat PLIST | cut -d: -f2 | sort)
```

### Test Package Contents

After building, examine the SPK:

```bash
tar -tvf packages/mypackage_x64-7.2_*.spk
```

## Multi-Architecture Considerations

### Platform-Specific Files

```makefile
# In Makefile, add to PLIST dynamically
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
PLIST_TRANSFORM = sed -e 's/@@ARM@@/bin:bin\/arm-specific/'
else
PLIST_TRANSFORM = sed -e '/@@ARM@@/d'
endif
```

### Library Versioning

Use wildcards for library versions:

```
# Handles libfoo.so.1, libfoo.so.1.2.3, etc.
lib:lib/libfoo.so*
```
