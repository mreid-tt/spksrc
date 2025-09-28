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

HOMEPAGE = https://downloads.mysql.com/archives/community/
COMMENT  = MySQL C API (libmysqlclient)
LICENSE  = GNU GPLv2

include ../../mk/spksrc.cross-cmake.mk

# custom mysql socket addr (default is /tmp/mysql.sock)
# on DSM 7 (only MariaDB 10 available)
# /run/mysqld/mysqld10.sock  (links to /run/mysqld/mysqld.sock)
# /run/mysqld/mysqld.sock
# on DSM 6 with mariadb 5 and 10
# /run/mysqld/mysqld.sock (MariaDB 5)
# /run/mysqld/mysqld10.sock (MariaDB 10)
ifeq ($(MYSQL_DB_SOCKET),)
# default mysql socket for DSM
MYSQL_DB_SOCKET = /run/mysqld/mysqld.sock
endif
CMAKE_ARGS += -DMYSQL_UNIX_ADDR=$(MYSQL_DB_SOCKET)

# # Mandatory for build
# CMAKE_ARGS += -DHAVE_LLVM_LIBCPP_EXITCODE=1 
# CMAKE_ARGS += -DHAVE_CXX_FLOATING_POINT_OPTIMIZATION_PROBLEMS_EXITCODE=1
# CMAKE_ARGS += -DHAVE_C_FLOATING_POINT_OPTIMIZATION_PROBLEMS_EXITCODE=1
# CMAKE_ARGS += -DHAVE_C_FLOATING_POINT_OPTIMIZATION_PROBLEMS_EXITCODE__TRYRUN_OUTPUT=1
# # MySQL specific:
# CMAKE_ARGS += -DSTACK_DIRECTION=1
# CMAKE_ARGS += -DWITH_UNIT_TESTS=OFF
# CMAKE_ARGS += -DWITH_EMBEDDED_SERVER=FALSE
# CMAKE_ARGS += -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
# # Fix full lib version:
# CMAKE_ARGS += -DSHARED_LIB_PATCH_VERSION=0
# # Fix for mariadb connector
# CMAKE_ARGS += -DINSTALL_INCLUDEDIR=include/mysql

# MySQL client specific:
CMAKE_ARGS += -DWITHOUT_SERVER=ON
CMAKE_ARGS += -DWITH_UNIT_TESTS=OFF
CMAKE_ARGS += -DDEFAULT_CHARSET=utf8
CMAKE_ARGS += -DDEFAULT_COLLATION=utf8_general_ci

# Fix for build exceptions:
CMAKE_ARGS += -DHAVE_C_FLOATING_POINT_FUSED_MADD=0
CMAKE_ARGS += -DHAVE_CXX_FLOATING_POINT_FUSED_MADD=0
CMAKE_ARGS += -DHAVE_SETNS=0
CMAKE_ARGS += -DHAVE_CLOCK_GETTIME=0
CMAKE_ARGS += -DHAVE_CLOCK_REALTIME=0
CMAKE_ARGS += -DLIBEVENT_VERSION=2.1.11
CMAKE_ARGS += -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY

DEPENDS += cross/ncursesw
CMAKE_ARGS += -DCURSES_LIBRARY=$(WORK_DIR)/ncurses-6.5/lib/libncursesw.so

DEPENDS += cross/openssl
CMAKE_ARGS += -DWITH_SSL=system
DEPENDS += cross/zlib
CMAKE_ARGS += -DWITH_ZLIB=system

# Use gcc builtin atomic functions for ppc architectures
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),)
CMAKE_ARGS += -DHAVE_GCC_ATOMIC_BUILTINS=1
endif
