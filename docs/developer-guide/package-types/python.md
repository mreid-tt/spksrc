# Python Packages

Python packages in spksrc use wheels to distribute dependencies alongside your SPK.

## Wheel Types

| Type | Requirements File | Description |
|------|-------------------|-------------|
| Pure Python | `requirements-pure.txt` | Platform-independent |
| Crossenv | `requirements-crossenv.txt` | Cross-compiled with C extensions |
| ABI3 Limited | `requirements-abi3.txt` | Limited API/ABI compatibility |
| Cross packages | `requirements-cross.txt` | Auto-generated from `cross/` |

## Basic Setup

```makefile
PYTHON_PACKAGE = python312
SPK_DEPENDS = "python312"

WHEELS = src/requirements-pure.txt
WHEELS += src/requirements-crossenv.txt

include ../../mk/spksrc.python.mk
```

## Service Setup

```bash
PYTHON_DIR="/var/packages/python312/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${PATH}"

service_postinst() {
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index \\
        -f ${SYNOPKG_PKGDEST}/share/wheelhouse \\
        ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl
}
```

## Crossenv Commands

```bash
# Create crossenv
make crossenv-x64-7.2

# Debug specific wheel
WHEEL="lxml-5.2.2" make crossenv-x64-7.2

# Clean crossenv
make crossenv-clean-x64-7.2
```

## Best Practices

1. **Pin all versions** - Use exact versions (`package==1.2.3`)
2. **Include all dependencies** - Don't rely on pip to resolve at install
3. **Exclude build tools** - Don't include setuptools, pip, wheel
4. **Test on hardware** - Verify on actual Synology devices

## Example

See [borgbackup](https://github.com/SynoCommunity/spksrc/tree/master/spk/borgbackup) for a comprehensive Python package.
