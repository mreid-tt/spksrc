PKG_NAME = postgis
PKG_VERS = 3.5.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.osgeo.org/postgis/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/postgresql cross/libgeos cross/libproj
BUILD_DEPENDS = native/postgresql

HOMEPAGE = https://postgis.net/
COMMENT = PostGIS is a spatial database extender for PostgreSQL
LICENSE = GPLv2

GNU_CONFIGURE = 1

# Path to cross-compiled PostgreSQL
CROSS_PG_CONFIG = $(STAGING_INSTALL_PREFIX)/bin/pg_config

CONFIGURE_ARGS  = --with-pgconfig=$(CROSS_PG_CONFIG)
CONFIGURE_ARGS += --with-geosconfig=$(STAGING_INSTALL_PREFIX)/bin/geos-config
CONFIGURE_ARGS += --with-projdir=$(STAGING_INSTALL_PREFIX)

# Provide PROJ version to avoid cross-compilation test failure
CONFIGURE_ARGS += PROJ_VERSION=8.2.1

CONFIGURE_ARGS += --without-raster
CONFIGURE_ARGS += --without-protobuf
CONFIGURE_ARGS += --without-gui
CONFIGURE_ARGS += --without-topology

# Disable parallel build to avoid race conditions in SQL file generation
COMPILE_MAKE_OPTIONS = -j1

# Override install to use a custom target that handles PGXS path issues
# PostGIS uses PGXS which gets paths from pg_config. The cross-compiled
# pg_config returns paths with INSTALL_DIR baked in (e.g., /workspace/.../install/var/packages/...)
# Since these paths already contain the install directory, we use DESTDIR=""
# and PostGIS will install directly to the correct staging location.
INSTALL_TARGET = postgis_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: postgis_install
postgis_install:
	@echo "Installing PostGIS with custom target..."
	$(RUN) $(MAKE) install DESTDIR=""
	@# Verify PostGIS files were installed
	@PKGLIBDIR=$$($(CROSS_PG_CONFIG) --pkglibdir); \
	if [ -f "$$PKGLIBDIR/postgis-3.so" ]; then \
	  echo "PostGIS installation verified: $$PKGLIBDIR/postgis-3.so"; \
	else \
	  echo "ERROR: PostGIS shared library not found at $$PKGLIBDIR"; \
	  exit 1; \
	fi
