SPK_NAME = postgresql
SPK_VERS = 17.4
SPK_REV = 1
SPK_ICON = src/postgresql.png

DEPENDS = cross/postgresql

MAINTAINER = DigitalBox98
DESCRIPTION = PostgreSQL is a powerful, open source object-relational database system with over 30 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance.
CHANGELOG = "Initial package release."
DISPLAY_NAME = PostgreSQL
STARTABLE = yes

HOMEPAGE = https://www.postgresql.org
LICENSE = PostgreSQL Licence

# Default port (Synology uses 5432, so we use 5433)
SERVICE_PORT = 5433
SERVICE_PORT_TITLE = PostgreSQL
# PostgreSQL uses its own protocol, not HTTP - no web UI shortcut
NO_SERVICE_SHORTCUT = 1

include ../../mk/spksrc.common.mk
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
CONF_DIR = src/conf
WIZARDS_DIR = src/wizard.dsm7
SERVICE_SETUP = src/service-setup.sh
else
CONF_DIR = src/conf.root
WIZARDS_DIR = src/wizard
SERVICE_SETUP = src/service-setup.as-root.sh
endif

# sc-postgresql is not a valid user (sc_postgres is defined in privilege file as package/service user)
#SERVICE_USER=auto
SSS_SCRIPT = src/start-stop-status.sh

include ../../mk/spksrc.spk.mk
