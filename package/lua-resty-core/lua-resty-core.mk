################################################################################
#
# lua-resty-core
#
################################################################################

# lua-resty-core hard-checks ngx.config.ngx_lua_version for exact equality against the
# lua-nginx-module release it shipped with (lib/resty/core/base.lua) -- pin to the release
# that matches this tree's LUA_NGINX_MODULE_VERSION (0.10.31 -> ngx_http_lua_version 10031),
# not just the latest stable tag.
LUA_RESTY_CORE_VERSION = 0.1.34rc3
LUA_RESTY_CORE_SITE = $(call github,openresty,lua-resty-core,v$(LUA_RESTY_CORE_VERSION))
LUA_RESTY_CORE_LICENSE = BSD
LUA_RESTY_CORE_LICENSE_FILES = LICENSE
LUA_RESTY_CORE_DEPENDENCIES =

define LUA_RESTY_CORE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) PREFIX=/usr LUA_VERSION=5.1 install
endef

$(eval $(generic-package))
