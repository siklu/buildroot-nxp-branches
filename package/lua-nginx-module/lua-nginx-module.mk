################################################################################
#
# lua-nginx-module
#
################################################################################

LUA_NGINX_MODULE_VERSION = 0.10.25
LUA_NGINX_MODULE_SITE = $(call github,openresty,lua-nginx-module,$(LUA_NGINX_MODULE_VERSION))
LUA_NGINX_MODULE_LICENSE = BSD-2-Clause
LUA_NGINX_MODULE_LICENSE_FILES = LICENSE
LUA_NGINX_MODULE_DEPENDENCIES =

$(eval $(generic-package))
