EXTRA_CFLAGS += $(USER_EXTRA_CFLAGS)
EXTRA_CFLAGS += -O1
#EXTRA_CFLAGS += -O3
EXTRA_CFLAGS += -Wall
#EXTRA_CFLAGS += -Wextra
#EXTRA_CFLAGS += -Werror
#EXTRA_CFLAGS += -pedantic
#EXTRA_CFLAGS += -Wshadow -Wpointer-arith -Wcast-qual -Wstrict-prototypes -Wmissing-prototypes

EXTRA_CFLAGS += -I$(src)/include -I$(src)/hal -g

ccflags-y += -D__CHECK_ENDIAN__

#EXTRA_LDFLAGS += --strip-debug

########################### Features ###########################
#CONFIG_HW_PWRP_DETECTION = n
#CONFIG_INTEL_WIDI = n
#CONFIG_EXT_CLK = n
#CONFIG_TRAFFIC_PROTECT = y
#CONFIG_LOAD_PHY_PARA_FROM_FILE = y
#CONFIG_CALIBRATE_TX_POWER_BY_REGULATORY = n
#CONFIG_CALIBRATE_TX_POWER_TO_MAX = n
#CONFIG_ODM_ADAPTIVITY = n
#CONFIG_SKIP_SIGNAL_SCALE_MAPPING = n
######################### Wake On Lan ##########################
#CONFIG_WOWLAN = n
#CONFIG_GPIO_WAKEUP = n
#CONFIG_PNO_SUPPORT = n
#CONFIG_PNO_SET_DEBUG = n
#CONFIG_AP_WOWLAN = n
####################### Platform Related #######################
CONFIG_PLATFORM_I386_PC = y
###############################################################


EXTRA_CFLAGS += -I$(src)/hal/OUTSRC-BTCoexist

########### HAL_GSL680_ds #################################
MODULE_NAME = gslx680_ds

########### END OF PATH  #################################


ifeq ($(CONFIG_PLATFORM_I386_PC), y)
SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ | sed -e s/armv7l/arm/)
ARCH ?= $(SUBARCH)
CROSS_COMPILE ?=
KVER  := $(shell uname -r)
KSRC := /lib/modules/$(KVER)/build
MODDESTDIR := /lib/modules/$(KVER)/kernel/drivers/net/wireless/
INSTALL_PREFIX :=
endif

ifneq ($(KERNELRELEASE),)

$(MODULE_NAME)-$(CONFIG_INTEL_WIDI) += core/rtw_intel_widi.o

#$(MODULE_NAME)-y += $(_OS_INTFS_FILES)
$(MODULE_NAME)-y += $(_PLATFORM_FILES)

obj-$(CONFIG_RTL8723BS) := $(MODULE_NAME).o

endif

export CONFIG_RTL8723BS = m

all: modules

modules:
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KSRC) M=$(shell pwd)  modules

strip:
	$(CROSS_COMPILE)strip $(MODULE_NAME).ko --strip-unneeded

install:
	install -p -m 644 $(MODULE_NAME).ko  $(MODDESTDIR)
	@mkdir -p /lib/firmware/gslx680/
	echo "FIXME"
	exit 1
	/sbin/depmod -a ${KVER}

uninstall:
	rm -f $(MODDESTDIR)/$(MODULE_NAME).ko
	/sbin/depmod -a ${KVER}

config_r:
	@echo "make config"
	/bin/bash script/Configure script/config.in

cppcheck: cppcheck.log

cppcheck.log:
	@echo "Creating cppcheck.log"
	cppcheck -f --enable=all -Iinclude -Ihal -Ios_dep  . 2> cppcheck.log

.PHONY: modules clean

clean:
	@rm -fr hal/*/*.mod.c hal/*/*.mod hal/*/*.o hal/*/.*.cmd hal/*/*.ko \
		hal/*.mod.c hal/*.mod hal/*.o hal/.*.cmd hal/*.ko \
		core/*.mod.c core/*.mod core/*.o core/.*.cmd core/*.ko \
		os_dep/*.mod.c os_dep/*.mod os_dep/*.o os_dep/.*.cmd *.ko \
		platform/*.mod.c platform/*.mod platform/*.o platform/.*.cmd platform/*.ko \
		Module.symvers Module.markers modules.order *.mod.c *.mod *.o .*.cmd *.ko *~ .tmp_versions \
		cppcheck.log
