SPK_NAME = synokernel-usbaudio
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synokernel-usbaudio.png

DEPENDS =

REQUIRE_KERNEL ?= 1
# Base sound/ALSA core modules (required dependencies for USB audio)
REQUIRE_KERNEL_MODULE  = CONFIG_SOUND:sound:soundcore
REQUIRE_KERNEL_MODULE += CONFIG_SND:sound/core:snd
REQUIRE_KERNEL_MODULE += CONFIG_SND_TIMER:sound/core:snd-timer
REQUIRE_KERNEL_MODULE += CONFIG_SND_PCM:sound/core:snd-pcm
REQUIRE_KERNEL_MODULE += CONFIG_SND_HWDEP:sound/core:snd-hwdep
REQUIRE_KERNEL_MODULE += CONFIG_SND_RAWMIDI:sound/core:snd-rawmidi
# USB Audio driver
REQUIRE_KERNEL_MODULE += CONFIG_SND_USB_AUDIO:sound/usb:snd-usb-audio

MAINTAINER = mreid-tt
DESCRIPTION = "Provides USB audio drivers for DSM 7+ including ALSA core and USB audio modules."
CHANGELOG = "Initial release with USB audio support for DSM 7.x."

# PPC platforms don't have DSM 7 toolchains available
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
# USB audio kernel modules only available for DSM 7+
REQUIRED_MIN_DSM = 7.0
# SRM 1.2 kernel build fails with yylloc multiple definition error
REQUIRED_MIN_SRM = 1.3

STARTABLE = no
DISPLAY_NAME = SynoKernel USB Audio drivers

HOMEPAGE = https://www.kernel.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel

STRIP_TARGET = synokernel-usbaudio_strip
POST_STRIP_TARGET = synokernel-usbaudio_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: synokernel-usbaudio_strip
synokernel-usbaudio_strip:
	@$(MSG) Strip debug symbols in kernel modules
	find $(STAGING_DIR) -type f -name "*.ko" -exec $(STRIP) --strip-debug {} \;

.PHONY: synokernel-usbaudio_extra_install
synokernel-usbaudio_extra_install:
	install -m 755 -d $(STAGING_DIR)/rules.d
	install -m 644 src/60-$(SPK_NAME).rules $(STAGING_DIR)/rules.d/60-$(SPK_NAME).rules
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/$(SPK_NAME).cfg $(STAGING_DIR)/etc/$(SPK_NAME).cfg
