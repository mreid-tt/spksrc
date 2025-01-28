SPK_NAME = bazarr
SPK_VERS = 1.5.1
SPK_REV = 16
SPK_ICON = src/bazarr.png

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
PYTHON_PACKAGE = python311
else ifneq ($(findstring $(ARCH),comcerto2k),$(ARCH))
PYTHON_PACKAGE = python312
else
PYTHON_PACKAGE = python311
endif

SPK_DEPENDS = "$(PYTHON_PACKAGE):ffmpeg7"

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/bazarr
DEPENDS += cross/unrar

MAINTAINER = smaarn
DESCRIPTION = "Bazarr is a companion application to Sonarr and Radarr. It manages and downloads subtitles based on your requirements. You define your preferences by TV show or movies and Bazarr takes care of everything for you."
DISPLAY_NAME = Bazarr
CHANGELOG = "1. Update bazarr to 1.5.1. <br/>See changelogs of <a href="https://github.com/morpheus65535/bazarr/releases/tag/v1.5.1">1.5.1</a> and <a href="https://github.com/morpheus65535/bazarr/releases/tag/v1.5.0">1.5.0</a> for more details. <br/>2. Update to Python 3.12 (DSM 7)."

HOMEPAGE  = https://www.bazarr.media/
LICENSE   = GPLv3
STARTABLE = yes

# [numpy] <= 1.21.6 (armv5)  - gcc-4.6.4 - unsupported
# [numpy] <= 1.22.4 (armv7l) - gcc-4.8.3 - unsupported
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

SERVICE_USER  = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 6767
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.python.mk

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [lxml] -std=c11
endif

# [numpy] <= 1.24.4 last working version with gcc-4.9
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
WHEELS += src/requirements-crossenv-numpy-py311-gcc4.txt
# [numpy] >= 1.25.0 requires c++17
else ifeq ($(call version_gt, $(TC_GCC), 5.0),1)
ifeq ($(PYTHON_PACKAGE),python311)
WHEELS += src/requirements-crossenv-numpy-py311.txt
else
WHEELS += src/requirements-crossenv-numpy-py312.txt
endif
endif

# [Pillow]
DEPENDS += cross/pillow
