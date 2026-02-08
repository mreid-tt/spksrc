PKG_NAME = icinga-php-library
PKG_VERS = 0.18.1
PKG_EXT = deb
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS)-1+debian12_all.$(PKG_EXT)
PKG_DIST_SITE = https://packages.icinga.com/debian/pool/main/i/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/Icinga/icinga-php-library
COMMENT  = Icinga PHP Library (IPL) for Icinga Web 2 modules
LICENSE  = MIT

# Skip default extract, we handle deb extraction manually
EXTRACT_TARGET = icinga_php_library_extract
INSTALL_TARGET = icinga_php_library_install

include ../../mk/spksrc.install-resources.mk

.PHONY: icinga_php_library_extract
icinga_php_library_extract:
	mkdir -p $(WORK_DIR)/$(PKG_DIR)
	dpkg-deb -x $(DISTRIB_DIR)/$(PKG_DIST_NAME) $(WORK_DIR)/$(PKG_DIR)

.PHONY: icinga_php_library_install
icinga_php_library_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/icinga-php
	cp -r $(WORK_DIR)/$(PKG_DIR)/usr/share/icinga-php/ipl $(STAGING_INSTALL_PREFIX)/share/icinga-php/
