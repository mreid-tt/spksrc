PKG_NAME = mysql-connector-c++
PKG_VERS = 9.3.0
PKG_EXT = tar.gz
DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src
PKG_DIST_NAME = $(DIST_NAME).$(PKG_EXT)
PKG_DIST_SITE = https://cdn.mysql.com/archives/$(PKG_NAME)
PKG_DIR = $(DIST_NAME)

BUILD_DEPENDS = 

HOMEPAGE = https://downloads.mysql.com/archives/c-cpp/
COMMENT  = MySQL C++ API (libmysqlcppconnx)
LICENSE  = GNU GPLv2

include ../../mk/spksrc.cross-cmake.mk

# MySQL specific:
CMAKE_ARGS += -DCMAKE_INSTALL_LIBDIR=lib
# Fix for mariadb connector
CMAKE_ARGS += -DCMAKE_INSTALL_INCLUDEDIR=include/mysql

DEPENDS += cross/openssl
CMAKE_ARGS += -DWITH_SSL=system
DEPENDS += cross/zlib
CMAKE_ARGS += -DWITH_ZLIB=system

# Use gcc builtin atomic functions for ppc architectures
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),)
CMAKE_ARGS += -DHAVE_GCC_ATOMIC_BUILTINS=1
endif
