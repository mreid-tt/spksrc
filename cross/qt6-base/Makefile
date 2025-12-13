PKG_NAME = qt6-base
PKG_VERS = 6.8.1
PKG_EXT = tar.xz
PKG_DIST_NAME = qtbase-everywhere-src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.qt.io/official_releases/qt/6.8/$(PKG_VERS)/submodules
PKG_DIR = qtbase-everywhere-src-$(PKG_VERS)

UNSUPPORTED_ARCHS = 88f6281 hi3535 powerpc ppc824x ppc853x ppc854x

BUILD_DEPENDS = native/qt6-tools
DEPENDS = cross/zlib cross/openssl3 cross/libicu-74.2 cross/sqlite cross/pcre2 cross/freetype cross/fontconfig

HOMEPAGE = https://www.qt.io/
COMMENT  = Qt 6 base components (Core/Network/Sql/Xml/DBus)
LICENSE  = GPL-3.0-or-later

CMAKE_SOURCE_DIR = $(WORK_DIR)/$(PKG_DIR)

CMAKE_ARGS += -DQT_BUILD_TESTS=OFF
CMAKE_ARGS += -DQT_BUILD_EXAMPLES=OFF
CMAKE_ARGS += -DQT_BUILD_BENCHMARKS=OFF
CMAKE_ARGS += -DQT_FORCE_BUILD_TOOLS=ON
CMAKE_ARGS += -DBUILD_WITH_PCH=OFF
CMAKE_ARGS += -DQT_FEATURE_gui=OFF
CMAKE_ARGS += -DQT_FEATURE_widgets=OFF
CMAKE_ARGS += -DQT_FEATURE_opengl=OFF
CMAKE_ARGS += -DQT_FEATURE_sql_sqlite=ON
CMAKE_ARGS += -DQT_FEATURE_dbus=ON
CMAKE_ARGS += -DQT_FEATURE_icu=ON
CMAKE_ARGS += -DQT_FEATURE_zstd=OFF
CMAKE_ARGS += -DOPENSSL_ROOT_DIR=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)

# Use native Qt6 host tools built via native/qt6-* packages
QT_HOST_PREFIX ?= $(abspath $(CURDIR)/../../native/qt6-base/work-native/install/usr/local/qt6-host)
ifneq ($(wildcard $(QT_HOST_PREFIX)/lib/cmake/Qt6HostInfo/Qt6HostInfoConfig.cmake),)
  CMAKE_ARGS += -DQT_HOST_PATH=$(QT_HOST_PREFIX)
  CMAKE_ARGS += -DQt6HostInfo_DIR=$(QT_HOST_PREFIX)/lib/cmake/Qt6HostInfo
endif

include ../../mk/spksrc.cross-cmake.mk
