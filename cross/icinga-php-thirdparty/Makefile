PKG_NAME = icinga-php-thirdparty
PKG_VERS = 0.14.0
PKG_EXT = deb
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS)-1+debian12_all.$(PKG_EXT)
PKG_DIST_SITE = https://packages.icinga.com/debian/pool/main/i/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/Icinga/icinga-php-thirdparty
COMMENT  = Third-party PHP libraries for Icinga Web 2 including Zend Framework 1
LICENSE  = Multiple

# Skip default extract, we handle deb extraction manually
EXTRACT_TARGET = icinga_php_thirdparty_extract
INSTALL_TARGET = icinga_php_thirdparty_install

include ../../mk/spksrc.install-resources.mk

.PHONY: icinga_php_thirdparty_extract
icinga_php_thirdparty_extract:
	mkdir -p $(WORK_DIR)/$(PKG_DIR)
	dpkg-deb -x $(DISTRIB_DIR)/$(PKG_DIST_NAME) $(WORK_DIR)/$(PKG_DIR)

.PHONY: icinga_php_thirdparty_install
icinga_php_thirdparty_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/icinga-php
	cp -r $(WORK_DIR)/$(PKG_DIR)/usr/share/icinga-php/vendor $(STAGING_INSTALL_PREFIX)/share/icinga-php/
