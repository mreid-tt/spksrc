KERNEL_ARCH = armada375
KERNEL_VERS = 6.2.4
KERNEL_BUILD = 25556
KERNEL_DIST = linux-3.x
KERNEL_BASE_ARCH = arm
KERNEL_URL_VERSION = 6.2
PRE_COMPILE_TARGET = kernel_platv2_pre_compile

include ../../mk/spksrc.kernel.mk
PHONY: kernel_platv2_pre_compile
kernel_platv2_pre_compile:
	cd $(KERNEL_DIR)/arch/arm/ && rm -rf plat-armada && ln -s plat-armada-v2 plat-armada
