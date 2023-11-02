################################################################################
#
# ngx_devel_kit
#
################################################################################

NGX_DEVEL_KIT_VERSION = 0.3.2
NGX_DEVEL_KIT_SITE = $(call github,vision5,ngx_devel_kit,$(NGX_DEVEL_KIT_VERSION))
NGX_DEVEL_KIT_LICENSE = BSD-2-Clause
NGX_DEVEL_KIT_LICENSE_FILES = LICENSE
NGX_DEVEL_KIT_DEPENDENCIES =

$(eval $(generic-package))


