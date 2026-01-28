PKG_NAME = xmlrpc-c
PKG_VERS = 1.60.05
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/xmlrpc-c/files/Xmlrpc-c%20Super%20Stable/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2

HOMEPAGE = http://xmlrpc-c.sourceforge.net/
COMMENT  = Programming library for writing an XML-RPC server or client in C or C++.
LICENSE  = BSD

GNU_CONFIGURE = 1

# Use the libxml2 backend for XML parsing (required by rTorrent)
CONFIGURE_ARGS = --enable-libxml2-backend
# Disable the built-in Abyss HTTP server — rTorrent does not use it
CONFIGURE_ARGS += --disable-abyss-server
# Disable the C++ bindings — rTorrent only uses the C API
CONFIGURE_ARGS += --disable-cplusplus
# Disable HTTP client support via libwww — not needed by rTorrent
CONFIGURE_ARGS += --disable-libwww-client
# Disable curl client support — avoids global curl state and threading issues
CONFIGURE_ARGS += --disable-curl-client

# Compiler flags for better stability in static builds
# -fno-strict-aliasing prevents subtle memory corruption inside xmlrpc-c
# -fno-omit-frame-pointer preserves stack frames for safer crash behavior
ADDITIONAL_CFLAGS += -O2 -fno-strict-aliasing -fno-omit-frame-pointer
ADDITIONAL_CXXFLAGS += -O2 -fno-strict-aliasing -fno-omit-frame-pointer

# Limit parallelism for xmlrpc-c; avoid races in libxmlrpc_util.so build
DISABLE_PARALLEL_MAKE = 1

# requires xml2-config in path to build libxml2-backend
ENV += PATH=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin:$$PATH

POST_INSTALL_TARGET = xmlrpc_c_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: xmlrpc_c_post_install
xmlrpc_c_post_install:
	# make xmlrpc-c-config use xml2-config from the same dir
	sed -i -e 's|LIBXML=`xml2-config --libs`|LIBXML=`"$$\(dirname "$$0")/xml2-config" --libs`|' \
		$(STAGING_INSTALL_PREFIX)/bin/xmlrpc-c-config
