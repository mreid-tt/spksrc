SPK_NAME = duplicity
SPK_VERS = 3.0.3.2
SPK_REV = 11
SPK_ICON = src/duplicity.png

# protobuf: missing atomics support 
# /upb/port/atomic.h:35:23: fatal error: stdatomic.h: No such file or directory
UNSUPPORTED_ARCHS = $(ARMv7L_ARCHS) $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE):gnupg>=2.1.6"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/librsync cross/duply

MAINTAINER = SynoCommunity
DESCRIPTION = Encrypted bandwidth-efficient backup using the rsync algorithm. Also contains duply wrapper script (duply is supported only for DSM >= 6.0).
STARTABLE = no
DISPLAY_NAME = Duplicity
CHANGELOG = "1. Update duplicity to v3.0.3.2 and duply to v2.5.5<br/>2. Update to OpenSSL 3.1.7<br/>3. Migrate to Python 3.12"

HOMEPAGE = https://duplicity.gitlab.io/duplicity-web/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

# use alternate TMPDIR as /tmp might be too small.
USE_ALTERNATE_TMPDIR = 1

SPK_COMMANDS = bin/duply bin/duplicity

SPK_USR_LOCAL_LINKS  = bin:env/bin/duplicity
SPK_USR_LOCAL_LINKS += bin:bin/duply

include ../../mk/spksrc.python.mk

# [cryptography]
DEPENDS += cross/cryptography

# [duplicity]
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
WHEELS_CFLAGS += [duplicity] -D__NO_FLOAT128
WHEELS_CFLAGS += [duplicity] -DNO_FLOAT128
WHEELS_CFLAGS += [duplicity] -D__NO_FLOAT64X
WHEELS_CFLAGS += [duplicity] -DNO_FLOAT64X
WHEELS_CFLAGS += [duplicity] -U_Float128
WHEELS_CFLAGS += [duplicity] -U_Float64x
WHEELS_CFLAGS += [duplicity] -march=armv7-a
WHEELS_CFLAGS += [duplicity] -U_Float128
WHEELS_CFLAGS += [duplicity] -mfloat-abi=hard
ifeq ($(findstring $(ARCH),comcerto2k),$(ARCH))
WHEELS_CFLAGS += [duplicity] -mfpu=neon
else
WHEELS_CFLAGS += [duplicity] -mfpu=vfpv3-d16
endif
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS) qoriq),$(ARCH))
WHEELS_CFLAGS += [duplicity] -D__NO_FLOAT128
WHEELS_CFLAGS += [duplicity] -DNO_FLOAT128
WHEELS_CFLAGS += [duplicity] -D__NO_FLOAT64X
WHEELS_CFLAGS += [duplicity] -DNO_FLOAT64X
WHEELS_CFLAGS += [duplicity] -U_Float128
WHEELS_CFLAGS += [duplicity] -U_Float64x
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
WHEELS_CFLAGS += [duplicity] -mcpu=e500v2
WHEELS_CFLAGS += [duplicity] -mfloat-gprs=double
else
WHEELS_CFLAGS += [duplicity] -march=armv8-a+simd
WHEELS_CFLAGS += [duplicity] -mabi=lp64
endif
endif

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [lxml] -std=c11
endif

# [protobuf]
WHEELS_CPPFLAGS = [protobuf] -std=c99

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [PyYAML]
DEPENDS += cross/libyaml
