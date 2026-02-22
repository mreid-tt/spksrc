SPK_NAME = dnscrypt-proxy
SPK_VERS = 2.1.15
SPK_REV = 6
SPK_ICON = src/dnscrypt-proxy.png

DEPENDS = cross/dnscrypt-proxy
SPK_CONFLICT = DNSServer
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
REQUIRED_MAX_DSM = 6.999

MAINTAINER = publicarray
DESCRIPTION = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTPS.
DISPLAY_NAME = dnscrypt-proxy
HELPURL = https://github.com/DNSCrypt/dnscrypt-proxy/wiki
HOMEPAGE = https://github.com/DNSCrypt/dnscrypt-proxy
LICENSE = ISC
CHANGELOG = "Update to 2.1.15 with built-in monitoring dashboard"

STARTABLE = yes

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf
FWPORTS = src/${SPK_NAME}.sc
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
DSM_UI_CONFIG = src/app/config
SERVICE_PORT = 53
SERVICE_PORT_TITLE = DNS
ADMIN_PORT = 8153
SERVICE_PORT_ALL_USERS = false
STARTSTOP_RESTART_SERVICE = cron

PRE_COPY_TARGET = dnscrypt_extra_install

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
NATIVE_GO = native/go_1.23
else
NATIVE_GO = native/go
endif

include ../../mk/spksrc.spk.mk

.PHONY: dnscrypt_extra_install
dnscrypt_extra_install: copy_msg
	@$(MSG) "Copying offline cache and blocklist files"
	install -m 755 -d $(STAGING_DIR)/offline-cache/
	install -m 755 -d $(STAGING_DIR)/blocklist/
	cp -rf $(CURDIR)/src/offline-cache/* $(STAGING_DIR)/offline-cache/
	install -m 755 $(CURDIR)/src/update-blocklist.sh $(STAGING_DIR)/blocklist/update-blocklist.sh
