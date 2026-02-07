SPK_NAME = icingaweb2
SPK_VERS = 2.12.6
SPK_REV = 1
SPK_ICON = src/icingaweb2.png

DEPENDS  = cross/icingaweb2
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 7.2
SPK_DEPENDS = WebStation:PHP8.2:Apache2.4:MariaDB10

MAINTAINER = SynoCommunity
DESCRIPTION = Icinga Web 2 is a powerful PHP framework for web applications that provides the frontend for Icinga 2 monitoring.
DISPLAY_NAME = Icinga Web 2
CHANGELOG = "Initial release of Icinga Web 2 v2.12.6"

HOMEPAGE = https://icinga.com/
LICENSE = GPLv2

WIZARDS_TEMPLATES_DIR = src/wizard_templates
SERVICE_WIZARD_SHARENAME = wizard_icinga_share

SYSTEM_GROUP = http

ADMIN_URL = /icingaweb2/

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
CONF_DIR = src/conf/

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

POST_STRIP_TARGET = icingaweb2_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: icingaweb2_extra_install
icingaweb2_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 755 -d $(WORK_DIR)/conf/modules/monitoring
	install -m 644 src/conf/modules/monitoring/*.ini $(WORK_DIR)/conf/modules/monitoring/
