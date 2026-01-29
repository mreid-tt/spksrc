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

# Use libxml2 for XML parsing (required by rTorrent)
CONFIGURE_ARGS += --enable-libxml2-backend

# Enable pthread support to make XML-RPC object handling thread-safe
# This is required to avoid crashes under concurrent SCGI/XML-RPC load
CONFIGURE_ARGS += --enable-pthread

# Disable unused components to reduce surface area and global state
CONFIGURE_ARGS += --disable-abyss-server      # Not used by rTorrent
CONFIGURE_ARGS += --disable-cplusplus         # rTorrent uses C API only
CONFIGURE_ARGS += --disable-libwww-client     # Unused HTTP client
CONFIGURE_ARGS += --disable-curl-client       # Avoid curl global state

# Ensure pthreads are consistently enabled for static builds
ADDITIONAL_CFLAGS   += -O2 -fno-strict-aliasing -fno-omit-frame-pointer -pthread
ADDITIONAL_CXXFLAGS += -O2 -fno-strict-aliasing -fno-omit-frame-pointer -pthread
ADDITIONAL_LDFLAGS  += -pthread

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
