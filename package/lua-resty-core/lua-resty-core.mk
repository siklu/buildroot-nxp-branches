################################################################################
#
# lua-resty-core
#
################################################################################

LUA_RESTY_CORE_VERSION = 0.1.27
LUA_RESTY_CORE_SITE = $(call github,openresty,lua-resty-core,$(LUA_RESTY_CORE_VERSION))
LUA_RESTY_CORE_LICENSE = BSD-2-Clause
LUA_RESTY_CORE_LICENSE_FILES = LICENSE
LUA_RESTY_CORE_DEPENDENCIES =

define LUA_RESTY_CORE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
