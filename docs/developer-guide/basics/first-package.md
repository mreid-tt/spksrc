# Your First Package

This guide walks you through building an existing package to verify your development environment and learn the basic workflow.

## Prerequisites

- Development environment set up ([Docker](../setup/docker.md), [VM](../setup/vm.md), or [LXC](../setup/lxc.md))
- Repository cloned and `make setup` completed

## Building a Simple Package

Let's build `transmission`, a lightweight BitTorrent client. It's a good first package because:

- It's relatively quick to build
- Has minimal dependencies
- Produces a working binary you can test

### Step 1: Navigate to the Package

```bash
cd /path/to/spksrc
cd spk/transmission
```

### Step 2: Build the Package

```bash
make
```

This starts the build process. The first build will:

1. Download the appropriate toolchain (if not cached)
2. Download transmission source code
3. Cross-compile transmission and its dependencies
4. Create the SPK package

!!! tip "Build Time"
    First builds take longer due to toolchain downloads. Subsequent builds use cached files.

### Step 3: Find the Built Package

After a successful build, the SPK file is in:

```bash
ls ../../packages/
```

You'll see something like:

```
transmission_x64-7.2_4.0.6-8.spk
```

The filename format is: `<package>_<arch>-<dsm>_<version>-<rev>.spk`

## Specifying Architecture

By default, spksrc builds for architectures listed in `local.mk`. To build for a specific architecture:

```bash
# Build for Intel 64-bit, DSM 7.2
make ARCH=x64 TCVERSION=7.2

# Build for ARM 64-bit, DSM 7.2
make ARCH=aarch64 TCVERSION=7.2

# Build for multiple architectures
make ARCH="x64 aarch64" TCVERSION=7.2
```

## Understanding the Output

During the build, you'll see output like:

```
===> Downloading toolchain for x64-7.2
===> Extracting for openssl3-x64-7.2
===> Configuring for openssl3-x64-7.2
===> Compiling for openssl3-x64-7.2
===> Installing for openssl3-x64-7.2
===> Extracting for curl-x64-7.2
...
===> Creating package for transmission-x64-7.2
```

Each `===>` line indicates a build stage:

| Stage | Description |
|-------|-------------|
| Downloading | Fetching toolchain or source code |
| Extracting | Unpacking source archives |
| Configuring | Running `./configure` or equivalent |
| Compiling | Building the software |
| Installing | Installing to staging directory |
| Creating package | Building the final SPK |

## Cleaning Up

### Clean Package Build

Remove build artifacts for this package only:

```bash
make clean
```

### Clean All Builds

Remove all build artifacts (keeps downloads):

```bash
make realclean
```

### Clean Everything

Remove all build artifacts and downloads:

```bash
make distclean
```

## Troubleshooting

### Build Fails with Missing Dependency

```
Error: missing dependency: cross/something
```

**Solution:** Dependencies should be built automatically. If not:

```bash
make -C ../../cross/something
```

Then retry the SPK build.

### Download Fails

```
Error: Failed to download ...
```

**Solutions:**

1. Check your internet connection
2. Verify the URL in `cross/<package>/Makefile` is valid
3. Try downloading manually to `distrib/`

### Build Takes Too Long

Enable parallel builds in `local.mk`:

```makefile
MAKEFLAGS += -j$(shell nproc)
```

### Out of Disk Space

```bash
make clean          # Clean this package
make realclean      # Clean all packages
rm -rf distrib/*    # Remove downloads (will re-download)
```

## Next Steps

- **[Package Anatomy](package-anatomy.md)** - Understand how packages are structured
- **[Build Workflow](build-workflow.md)** - Learn more build commands
- **[Packaging Guide](../packaging/index.md)** - Create your own package
