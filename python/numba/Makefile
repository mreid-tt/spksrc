PKG_NAME = numba
PKG_VERS = 0.61.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/n/numba
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://numba.pydata.org/
COMMENT  = Numba is an open source, NumPy-aware optimizing compiler for Python sponsored by Anaconda, Inc. It uses the LLVM compiler project to generate machine code from Python syntax.
LICENSE  = BSD-2-Clause license

# Requires gcc>=8.4 to build sucesfully
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

DEPENDS  = python/numpy

include ../../mk/spksrc.python-wheel.mk
