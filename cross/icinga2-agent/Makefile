PKG_NAME = icinga2-agent
PKG_VERS = 2.15.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Icinga/icinga2/archive/refs/tags
PKG_DIST_FILE = icinga2-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = icinga2-$(PKG_VERS)

# Icinga2 requires C++17 (GCC >= 7)
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

BUILD_DEPENDS = native/icinga2-tools

DEPENDS  = cross/boost_1.86
DEPENDS += cross/openssl3

HOMEPAGE = https://icinga.com/
COMMENT  = Icinga 2 agent for distributed monitoring (lightweight, connects to master)
LICENSE  = GPLv2

# Boost configuration
BOOST_LIBRARIES = coroutine context date_time filesystem iostreams thread program_options regex system
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

# Agent-only features (no IDO database, no notification, no compat)
CMAKE_ARGS += -DICINGA2_WITH_MYSQL=OFF
CMAKE_ARGS += -DICINGA2_WITH_PGSQL=OFF
CMAKE_ARGS += -DICINGA2_WITH_CHECKER=ON
CMAKE_ARGS += -DICINGA2_WITH_NOTIFICATION=OFF
CMAKE_ARGS += -DICINGA2_WITH_PERFDATA=OFF
CMAKE_ARGS += -DICINGA2_WITH_ICINGADB=OFF
CMAKE_ARGS += -DICINGA2_WITH_LIVESTATUS=OFF
CMAKE_ARGS += -DICINGA2_WITH_COMPAT=OFF
CMAKE_ARGS += -DICINGA2_WITH_TESTS=OFF
CMAKE_ARGS += -DUSE_SYSTEMD=OFF
CMAKE_ARGS += -DICINGA2_GIT_VERSION_INFO=OFF
CMAKE_ARGS += -DICINGA2_UNITY_BUILD=ON

# Boost paths
CMAKE_ARGS += -DBOOST_ROOT=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DBOOST_INCLUDEDIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DBOOST_LIBRARYDIR=$(STAGING_INSTALL_PREFIX)/lib
CMAKE_ARGS += -DBoost_NO_SYSTEM_PATHS=ON

# Disable editline/libedit
CMAKE_ARGS += -DICINGA2_WITH_EDITLINE=OFF

# OpenSSL paths
CMAKE_ARGS += -DOPENSSL_ROOT_DIR=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DOPENSSL_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DOPENSSL_CRYPTO_LIBRARY=$(STAGING_INSTALL_PREFIX)/lib/libcrypto.so
CMAKE_ARGS += -DOPENSSL_SSL_LIBRARY=$(STAGING_INSTALL_PREFIX)/lib/libssl.so

# nlohmann json is bundled in third-party
CMAKE_ARGS += -DJSON_INCLUDE:PATH=$(WORK_DIR)/$(PKG_DIR)/third-party/nlohmann_json
CMAKE_ARGS += -DUTF8CPP_INCLUDE:PATH=$(WORK_DIR)/$(PKG_DIR)/third-party/utf8cpp/source

# Installation directories
CMAKE_ARGS += -DICINGA2_USER=icinga
CMAKE_ARGS += -DICINGA2_GROUP=icinga
CMAKE_ARGS += -DICINGA2_COMMAND_GROUP=icingacmd

# Skip user/group impersonation
ADDITIONAL_CXXFLAGS = -DICINGA2_SKIP_IMPERSONATION

# Native tools from native/icinga2-tools package
NATIVE_BUILD_DIR = $(realpath $(WORK_DIR)/../../../native/icinga2-tools/work-native/install/usr/local)
ENV += PATH=$(NATIVE_BUILD_DIR)/bin:$$PATH

include ../../mk/spksrc.cross-cmake.mk
