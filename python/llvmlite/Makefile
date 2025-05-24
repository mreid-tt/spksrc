PKG_NAME = llvmlite
PKG_VERS = 0.44.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/l/llvmlite
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/llvm

HOMEPAGE = https://llvmlite.readthedocs.io/
COMMENT  = A lightweight LLVM-Python binding for writing JIT compilers
LICENSE  = BSD 2-Clause License

include ../../mk/spksrc.python-wheel.mk
