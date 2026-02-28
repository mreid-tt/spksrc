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

# For cross-compilation, we use a wrapper script instead of the cross-compiled
# pg_config binary (which cannot run on the build host). The wrapper returns:
# - Native PGXS path for building (from native/postgresql)
# - Cross-compiled library/share paths for installation
NATIVE_PG_DIR = $(realpath $(WORK_DIR)/../../../native/postgresql/work-native/install/usr/local)
PG_CONFIG_WRAPPER = $(WORK_DIR)/pg_config_wrapper

# Cross-compiled PostgreSQL paths (where PostGIS will be installed)
CROSS_PG_LIBDIR = $(STAGING_INSTALL_PREFIX)/lib
CROSS_PG_SHAREDIR = $(STAGING_INSTALL_PREFIX)/share
CROSS_PG_INCLUDEDIR = $(STAGING_INSTALL_PREFIX)/include
CROSS_PG_BINDIR = $(STAGING_INSTALL_PREFIX)/bin

CONFIGURE_ARGS  = --with-pgconfig=$(PG_CONFIG_WRAPPER)
CONFIGURE_ARGS += --with-geosconfig=$(STAGING_INSTALL_PREFIX)/bin/geos-config
CONFIGURE_ARGS += --with-projdir=$(STAGING_INSTALL_PREFIX)

# Provide PROJ version to avoid cross-compilation test failure
CONFIGURE_ARGS += PROJ_VERSION=8.2.1

CONFIGURE_ARGS += --without-raster
CONFIGURE_ARGS += --without-protobuf
CONFIGURE_ARGS += --without-gui
CONFIGURE_ARGS += --without-topology

# Disable parallel build to avoid race conditions in SQL file generation
# Also override CC since native PGXS makefile hardcodes CC=gcc
COMPILE_MAKE_OPTIONS = -j1 CC="$(TC_PATH)$(TC_PREFIX)gcc"

# Set up pg_config wrapper before configure runs
PRE_CONFIGURE_TARGET = postgis_setup_wrapper

# Custom install target to handle paths correctly
INSTALL_TARGET = postgis_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: postgis_setup_wrapper
postgis_setup_wrapper:
	@echo "Creating pg_config wrapper for cross-compilation..."
	@echo '#!/bin/sh' > $(PG_CONFIG_WRAPPER)
	@echo '# pg_config wrapper for PostGIS cross-compilation' >> $(PG_CONFIG_WRAPPER)
	@echo 'NATIVE_PG="$(NATIVE_PG_DIR)"' >> $(PG_CONFIG_WRAPPER)
	@echo 'case "$$1" in' >> $(PG_CONFIG_WRAPPER)
	@echo '  --version) echo "PostgreSQL 17.4" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --pgxs) echo "$$NATIVE_PG/lib/postgresql/pgxs/src/makefiles/pgxs.mk" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --includedir) echo "$(CROSS_PG_INCLUDEDIR)" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --includedir-server) echo "$(CROSS_PG_INCLUDEDIR)/server" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --pkgincludedir) echo "$(CROSS_PG_INCLUDEDIR)" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --libdir) echo "$(CROSS_PG_LIBDIR)" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --pkglibdir) echo "$(CROSS_PG_LIBDIR)" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --sharedir) echo "$(CROSS_PG_SHAREDIR)" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --bindir) echo "$(CROSS_PG_BINDIR)" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --docdir) echo "$(CROSS_PG_SHAREDIR)/doc" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --htmldir) echo "$(CROSS_PG_SHAREDIR)/doc" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --mandir) echo "$(CROSS_PG_SHAREDIR)/man" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --localedir) echo "$(CROSS_PG_SHAREDIR)/locale" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --sysconfdir) echo "$(CROSS_PG_INCLUDEDIR)/../etc" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --cflags) "$$NATIVE_PG/bin/pg_config" --cflags ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --cppflags) "$$NATIVE_PG/bin/pg_config" --cppflags ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --ldflags) echo "-L$(CROSS_PG_LIBDIR)" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --libs) echo "-lssl -lcrypto -lpthread -lm" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  --cc) echo "$(TC_PATH)$(TC_PREFIX)gcc" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  "")' >> $(PG_CONFIG_WRAPPER)
	@echo '    echo "BINDIR = $(CROSS_PG_BINDIR)"' >> $(PG_CONFIG_WRAPPER)
	@echo '    echo "INCLUDEDIR = $(CROSS_PG_INCLUDEDIR)"' >> $(PG_CONFIG_WRAPPER)
	@echo '    echo "INCLUDEDIR-SERVER = $(CROSS_PG_INCLUDEDIR)/server"' >> $(PG_CONFIG_WRAPPER)
	@echo '    echo "LIBDIR = $(CROSS_PG_LIBDIR)"' >> $(PG_CONFIG_WRAPPER)
	@echo '    echo "PKGLIBDIR = $(CROSS_PG_LIBDIR)"' >> $(PG_CONFIG_WRAPPER)
	@echo '    echo "SHAREDIR = $(CROSS_PG_SHAREDIR)"' >> $(PG_CONFIG_WRAPPER)
	@echo '    echo "PGXS = $$NATIVE_PG/lib/postgresql/pgxs/src/makefiles/pgxs.mk"' >> $(PG_CONFIG_WRAPPER)
	@echo '    echo "VERSION = PostgreSQL 17.4"' >> $(PG_CONFIG_WRAPPER)
	@echo '    ;;' >> $(PG_CONFIG_WRAPPER)
	@echo '  *) "$$NATIVE_PG/bin/pg_config" "$$1" ;;' >> $(PG_CONFIG_WRAPPER)
	@echo 'esac' >> $(PG_CONFIG_WRAPPER)
	@chmod +x $(PG_CONFIG_WRAPPER)
	@echo "pg_config wrapper created at $(PG_CONFIG_WRAPPER)"

.PHONY: postgis_install
postgis_install:
	@echo "Installing PostGIS..."
	$(RUN) $(MAKE) install DESTDIR=""
	@# Verify installation
	@if [ -f "$(CROSS_PG_LIBDIR)/postgis-3.so" ]; then \
	  echo "PostGIS installed successfully: $(CROSS_PG_LIBDIR)/postgis-3.so"; \
	else \
	  echo "ERROR: PostGIS library not found"; \
	  exit 1; \
	fi
