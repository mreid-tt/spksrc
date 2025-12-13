PKG_NAME = libxkbcommon
PKG_VERS = 1.7.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://xkbcommon.org/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xcb-proto cross/libxcb cross/libX11 cross/libxml2

LIBXML2_PKGCONFIG = $(WORK_DIR)/../libxml2/work-$(ARCH)-$(TCVERSION)/install/usr/local/libxml2/lib/pkgconfig
LIBXML2_PC = $(LIBXML2_PKGCONFIG)/libxml-2.0.pc

ADDITIONAL_CFLAGS += -I$(STAGING_INSTALL_PREFIX)/include/libxml2
ADDITIONAL_LDFLAGS += -L$(STAGING_INSTALL_PREFIX)/lib
MESON_EXTRA_ENV += PKG_CONFIG_LIBDIR=$(LIBXML2_PKGCONFIG)

PRE_CONFIGURE_TARGET = libxkbcommon_pre_configure

.PHONY: libxkbcommon_pre_configure
libxkbcommon_pre_configure:
	@[ -f $(LIBXML2_PC) ] || { \
		$(MSG) "Installing libxml2 pkg-config files for $(NAME)"; \
		env $(ENV) $(MAKE) -C ../libxml2 install; \
	}

HOMEPAGE = https://xkbcommon.org/
COMMENT  = Keymap handling library for wayland and X11
LICENSE  = MIT

CMAKE_SOURCE_DIR = $(WORK_DIR)/$(PKG_DIR)

CMAKE_ARGS += -Denable-docs=OFF
CMAKE_ARGS += -Denable-wayland=OFF
CMAKE_ARGS += -Denable-xkbregistry=OFF
CMAKE_ARGS += -Denable-tools=OFF
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)

CONFIGURE_ARGS += -Denable-wayland=false

include ../../mk/spksrc.cross-meson.mk
