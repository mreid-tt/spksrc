PKG_NAME = libmysqlclient
PKG_REAL_NAME = mysql
PKG_VERS = 8.0.42
PKG_EXT = tar.gz
PKG_MAJOR_MINOR = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(DIST_NAME).$(PKG_EXT)
PKG_DIST_SITE = https://cdn.mysql.com/archives/$(PKG_REAL_NAME)-$(PKG_MAJOR_MINOR)
PKG_DIR = $(DIST_NAME)

REQUIRED_MIN_DSM = 7.1
# comcerto2k has older toolchain than other DSM 7.1 archs
UNSUPPORTED_ARCHS = comcerto2k

# build cross/libicu before cross/boost to build libboost_regex with unicode support
DEPENDS = cross/libicu cross/boost

HOMEPAGE = https://downloads.mysql.com/archives/community/
COMMENT  = MySQL C API (libmysqlclient)
LICENSE  = GNU GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cmake.mk

# Mandatory for build
CMAKE_ARGS += -DHAVE_LLVM_LIBCPP_EXITCODE=1 
CMAKE_ARGS += -DHAVE_CXX_FLOATING_POINT_OPTIMIZATION_PROBLEMS_EXITCODE=1
CMAKE_ARGS += -DHAVE_C_FLOATING_POINT_OPTIMIZATION_PROBLEMS_EXITCODE=1
CMAKE_ARGS += -DHAVE_C_FLOATING_POINT_OPTIMIZATION_PROBLEMS_EXITCODE__TRYRUN_OUTPUT=1
# MySQL specific:
CMAKE_ARGS += -DSTACK_DIRECTION=1
CMAKE_ARGS += -DWITH_UNIT_TESTS=OFF
CMAKE_ARGS += -DWITH_EMBEDDED_SERVER=FALSE
CMAKE_ARGS += -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
# Fix full lib version:
CMAKE_ARGS += -DSHARED_LIB_PATCH_VERSION=0
# Fix for mariadb connector
CMAKE_ARGS += -DINSTALL_INCLUDEDIR=include/mysql

# MySQL client specific:
CMAKE_ARGS += -DWITHOUT_SERVER=ON
CMAKE_ARGS += -DHAVE_C_FLOATING_POINT_FUSED_MADD=0
CMAKE_ARGS += -DHAVE_CXX_FLOATING_POINT_FUSED_MADD=0

DEPENDS += cross/openssl
CMAKE_ARGS += -DWITH_SSL=system
DEPENDS += cross/zlib
CMAKE_ARGS += -DWITH_ZLIB=system

# Use gcc builtin atomic functions for ppc architectures
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),)
CMAKE_ARGS += -DHAVE_GCC_ATOMIC_BUILTINS=1
endif
