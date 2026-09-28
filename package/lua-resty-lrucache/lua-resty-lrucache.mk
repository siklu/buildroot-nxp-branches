################################################################################
#
# lua-resty-lrucache
#
################################################################################

LUA_RESTY_LRUCACHE_VERSION = 0.13
LUA_RESTY_LRUCACHE_SITE = $(call github,openresty,lua-resty-lrucache,$(LUA_RESTY_LRUCACHE_VERSION))
LUA_RESTY_LRUCACHE_SUBDIR = lua-resty-core
LUA_RESTY_LRUCACHE_LICENSE = BSD
LUA_RESTY_LRUCACHE_LICENSE_FILES = LICENSE
LUA_RESTY_LRUCACHE_DEPENDENCIES =

define LUA_RESTY_LRUCACHE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) PREFIX=/usr LUA_VERSION=5.1 install
endef

$(eval $(generic-package))

