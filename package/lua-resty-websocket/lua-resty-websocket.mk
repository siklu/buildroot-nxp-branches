################################################################################
#
# lua-resty-websocket
#
################################################################################

LUA_RESTY_WEBSOCKET_VERSION = 0.10
LUA_RESTY_WEBSOCKET_SITE = $(call github,openresty,lua-resty-websocket,$(LUA_RESTY_WEBSOCKET_VERSION))
LUA_RESTY_WEBSOCKET_SUBDIR = lua-resty-websocket
LUA_RESTY_WEBSOCKET_LICENSE = BSD
LUA_RESTY_WEBSOCKET_LICENSE_FILES = LICENSE
LUA_RESTY_WEBSOCKET_DEPENDENCIES =

define LUA_RESTY_WEBSOCKET_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))

