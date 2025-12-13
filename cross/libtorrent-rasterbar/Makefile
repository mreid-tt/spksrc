PKG_NAME = libtorrent-rasterbar
PKG_VERS = 2.0.11
PKG_EXT = tar.gz
PKG_DIST_NAME = libtorrent-rasterbar-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/arvidn/libtorrent/releases/download/v$(PKG_VERS)
PKG_DIR = libtorrent-rasterbar-$(PKG_VERS)

UNSUPPORTED_ARCHS = 88f6281 hi3535 powerpc ppc824x ppc853x ppc854x

DEPENDS = cross/boost cross/openssl3 cross/zlib cross/libiconv cross/qt6-base

HOMEPAGE = https://www.libtorrent.org/
COMMENT  = libtorrent-rasterbar C++ library
LICENSE  = BSD-3-Clause

CMAKE_SOURCE_DIR = $(WORK_DIR)/$(PKG_DIR)

CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON
CMAKE_ARGS += -Dpython-bindings=OFF
CMAKE_ARGS += -Dbuild_tests=OFF
CMAKE_ARGS += -Dbuild_examples=OFF
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CXX_STANDARD=20
CMAKE_ARGS += -Ddeprecated-functions=OFF
CMAKE_ARGS += -Dboost-use-static-runtime=OFF

include ../../mk/spksrc.cross-cmake.mk
