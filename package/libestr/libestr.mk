################################################################################
#
# libestr
#
################################################################################

LIBESTR_VERSION = 0.1.10
#LIBESTR_SITE = http://libestr.adiscon.com/files/download
LIBESTR_SITE = $(BR2_SIKLU_FTP_URL)
LIBESTR_LICENSE = LGPL-2.1+
LIBESTR_LICENSE_FILES = COPYING
LIBESTR_INSTALL_STAGING = YES

$(eval $(autotools-package))
