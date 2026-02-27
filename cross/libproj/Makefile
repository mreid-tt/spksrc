PKG_NAME = libproj
PKG_VERS = 8.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = proj-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.osgeo.org/proj
PKG_DIR = proj-$(PKG_VERS)

DEPENDS = cross/sqlite cross/libtiff cross/curl

HOMEPAGE = https://proj.org/
COMMENT = PROJ is a generic coordinate transformation software
LICENSE = MIT

# PROJ uses CMake
CMAKE_ARGS += -DBUILD_TESTING=OFF
CMAKE_ARGS += -DENABLE_CURL=ON
CMAKE_ARGS += -DENABLE_TIFF=ON

include ../../mk/spksrc.cross-cmake.mk
