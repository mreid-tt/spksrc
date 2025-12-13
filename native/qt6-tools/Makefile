PKG_NAME = qt6-tools
PKG_VERS = 6.8.1
PKG_EXT = tar.xz
PKG_DIST_NAME = qttools-everywhere-src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.qt.io/official_releases/qt/6.8/$(PKG_VERS)/submodules
PKG_DIR = qttools-everywhere-src-$(PKG_VERS)

HOMEPAGE = https://www.qt.io/
COMMENT  = Qt 6 developer host tools
LICENSE  = GPL-3.0-or-later

DEPENDS = native/qt6-base

CMAKE_SOURCE_DIR = $(WORK_DIR)/$(PKG_DIR)

CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)/qt6-host
CMAKE_ARGS += -DQT_BUILD_TESTS=OFF
CMAKE_ARGS += -DQT_BUILD_EXAMPLES=OFF
CMAKE_ARGS += -DQT_BUILD_BENCHMARKS=OFF
CMAKE_ARGS += -DBUILD_WITH_PCH=OFF

include ../../mk/spksrc.native-cmake.mk
