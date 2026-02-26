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

# libicu dependency doesn't support these architectures
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

# Use auto-generated service user (sc-postgresql)
SERVICE_USER = auto

SERVICE_SETUP = src/service-setup.sh
WIZARDS_DIR = src/wizard
SSS_SCRIPT = src/start-stop-status.sh

include ../../mk/spksrc.spk.mk
