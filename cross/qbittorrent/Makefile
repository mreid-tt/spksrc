PKG_NAME = qbittorrent
PKG_VERS = 5.1.4
PKG_EXT = tar.gz
PKG_DIST_NAME = release-$(PKG_VERS).tar.gz
PKG_DIST_SITE = https://github.com/qbittorrent/qBittorrent/archive/refs/tags
PKG_DIR = qBittorrent-release-$(PKG_VERS)

UNSUPPORTED_ARCHS = 88f6281 hi3535 powerpc ppc824x ppc853x ppc854x

DEPENDS = cross/libtorrent-rasterbar cross/qt6-base cross/qt6-tools cross/qt6-svg cross/openssl3 cross/zlib cross/boost

HOMEPAGE = https://www.qbittorrent.org/
COMMENT  = qBittorrent headless daemon (qbittorrent-nox)
LICENSE  = GPL-2.0-or-later

CMAKE_SOURCE_DIR = $(WORK_DIR)/$(PKG_DIR)

CMAKE_ARGS += -DGUI=OFF
CMAKE_ARGS += -DWEBUI=ON
CMAKE_ARGS += -DSTACKTRACE=OFF
CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=Release
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cmake.mk
