PKG_NAME = qt6-translations
PKG_VERS = 6.8.1
PKG_EXT = tar.xz
PKG_DIST_NAME = qttranslations-everywhere-src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.qt.io/official_releases/qt/6.8/$(PKG_VERS)/submodules
PKG_DIR = qttranslations-everywhere-src-$(PKG_VERS)

UNSUPPORTED_ARCHS = 88f6281 hi3535 powerpc ppc824x ppc853x ppc854x

DEPENDS = cross/qt6-base cross/qt6-tools

HOMEPAGE = https://www.qt.io/
COMMENT  = Qt 6 translation catalogs used by qbittorrent
LICENSE  = GPL-3.0-or-later

CMAKE_SOURCE_DIR = $(WORK_DIR)/$(PKG_DIR)

CMAKE_ARGS += -DQT_BUILD_TESTS=OFF
CMAKE_ARGS += -DQT_BUILD_EXAMPLES=OFF
CMAKE_ARGS += -DQT_BUILD_BENCHMARKS=OFF
CMAKE_ARGS += -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cmake.mk
