PKG_NAME = libmysqlclient
PKG_REAL_NAME = mysql
PKG_VERS = 8.0.42
PKG_EXT = tar.gz
PKG_MAJOR_MINOR = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(DIST_NAME).$(PKG_EXT)
PKG_DIST_SITE = https://cdn.mysql.com/archives/$(PKG_REAL_NAME)-$(PKG_MAJOR_MINOR)
PKG_DIR = $(DIST_NAME)

BUILD_DEPENDS = 

HOMEPAGE = https://downloads.mysql.com/archives/community/
COMMENT  = MySQL C API (libmysqlclient)
LICENSE  = GNU GPLv2

include ../../mk/spksrc.cross-cmake.mk

# MySQL client specific:
CMAKE_ARGS += -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY
CMAKE_ARGS += -DHAVE_C_FLOATING_POINT_FUSED_MADD=0
CMAKE_ARGS += -DWITH_UNIT_TESTS=OFF
CMAKE_ARGS += -DWITHOUT_SERVER=ON
# Fix for mariadb connector
# CMAKE_ARGS += -DCMAKE_INSTALL_INCLUDEDIR=include/mysql

DEPENDS += cross/openssl
CMAKE_ARGS += -DWITH_SSL=system
DEPENDS += cross/zlib
CMAKE_ARGS += -DWITH_ZLIB=system

# Use gcc builtin atomic functions for ppc architectures
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),)
CMAKE_ARGS += -DHAVE_GCC_ATOMIC_BUILTINS=1
endif
