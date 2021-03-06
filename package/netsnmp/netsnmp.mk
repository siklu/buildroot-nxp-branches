################################################################################
#
# netsnmp
#
################################################################################

NETSNMP_VERSION = 5.9
NETSNMP_SITE = https://downloads.sourceforge.net/project/net-snmp/net-snmp/$(NETSNMP_VERSION)
NETSNMP_SOURCE = net-snmp-$(NETSNMP_VERSION).tar.gz
NETSNMP_LICENSE = Various BSD-like
NETSNMP_LICENSE_FILES = COPYING
NETSNMP_CPE_ID_VENDOR = net-snmp
NETSNMP_CPE_ID_PRODUCT = $(NETSNMP_CPE_ID_VENDOR)
NETSNMP_SELINUX_MODULES = snmp
NETSNMP_INSTALL_STAGING = YES
NETSNMP_CONF_ENV = \
	ac_cv_NETSNMP_CAN_USE_SYSCTL=no \
	ac_cv_path_PSPROG=/bin/ps
NETSNMP_CONF_OPTS = \
	--with-persistent-directory=/var/lib/snmp \
	--with-defaults \
	--enable-mini-agent \
	--without-rpm \
	--with-logfile=none \
	--without-kmem-usage \
	--enable-as-needed \
	--without-perl-modules \
	--disable-embedded-perl \
	--disable-perl-cc-checks \
	--disable-scripts \
	--with-default-snmp-version="1" \
	--enable-silent-libtool \
	--enable-mfd-rewrites \
	--with-sys-contact="root@localhost" \
	--with-sys-location="Unknown" \
	--with-mib-modules="$(call qstrip,$(BR2_PACKAGE_NETSNMP_WITH_MIB_MODULES))" \
	--with-out-mib-modules="$(call qstrip,$(BR2_PACKAGE_NETSNMP_WITHOUT_MIB_MODULES))" \
	--disable-manuals
NETSNMP_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) LIB_LDCONFIG_CMD=true install
NETSNMP_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) LIB_LDCONFIG_CMD=true install
NETSNMP_MAKE = $(MAKE1)
NETSNMP_CONFIG_SCRIPTS = net-snmp-config
NETSNMP_AUTORECONF = YES
WITH_OUT_MIB_MODULES:="mibII/snmp_mib, mibII/system_mib, mibII/sysORTable"
WITH_MIB_MODULES:="ucd-snmp/dlmod agentx"
NET_SNMP_PERSISTENT_DIR:=/var
TARGET_CFLAGS = -DNETSNMP_NO_INLINE

ifeq ($(BR2_ENDIAN),"BIG")
NETSNMP_CONF_OPTS += --with-endianness=big
else
NETSNMP_CONF_OPTS += --with-endianness=little
endif

ifeq ($(BR2_PACKAGE_LIBNL),y)
NETSNMP_DEPENDENCIES += host-pkgconf libnl
NETSNMP_CONF_OPTS += --with-nl
else
NETSNMP_CONF_OPTS += --without-nl
endif

# OpenSSL
ifeq ($(BR2_PACKAGE_OPENSSL),y)
NETSNMP_DEPENDENCIES += host-pkgconf openssl
NETSNMP_CONF_OPTS += \
	--with-openssl=$(STAGING_DIR)/usr/include/openssl \
	--with-security-modules="tsm,usm" \
	--with-transports="DTLSUDP,TLSTCP"
NETSNMP_CONF_ENV += LIBS=`$(PKG_CONFIG_HOST_BINARY) --libs openssl`
else ifeq ($(BR2_PACKAGE_NETSNMP_OPENSSL_INTERNAL),y)
NETSNMP_CONF_OPTS += --with-openssl=internal
else
NETSNMP_CONF_OPTS += --without-openssl
endif

# There's no option to forcibly enable or disable it
ifeq ($(BR2_PACKAGE_PCIUTILS),y)
NETSNMP_DEPENDENCIES += pciutils
endif

# For ucd-snmp/lmsensorsMib
ifeq ($(BR2_PACKAGE_LM_SENSORS),y)
NETSNMP_DEPENDENCIES += lm-sensors
endif

ifneq ($(BR2_PACKAGE_NETSNMP_ENABLE_MIBS),y)
NETSNMP_CONF_OPTS += --disable-mib-loading
NETSNMP_CONF_OPTS += --disable-mibs
NETSNMP_CONF_OPTS += --silent
NETSNMP_CONF_OPTS += --enable-agent
NETSNMP_CONF_OPTS += --disable-manuals
NETSNMP_CONF_OPTS += --enable-as-needed
NETSNMP_CONF_OPTS += --disable-scripts
NETSNMP_CONF_OPTS += --enable-ipv6
NETSNMP_CONF_OPTS += --disable-embedded-perl
NETSNMP_CONF_OPTS += --disable-perl-cc-checks
NETSNMP_CONF_OPTS += --with-transports="UDPIPv6 TCPIPv6"
NETSNMP_CONF_OPTS += --with-out-transports="AAL5PVC IPX"
NETSNMP_CONF_OPTS += --without-rpm
NETSNMP_CONF_OPTS += --enable-mini-agent
NETSNMP_CONF_OPTS += --disable-mib-loading
NETSNMP_CONF_OPTS += --with-sys-contact=root@
NETSNMP_CONF_OPTS += --with-sys-location=unknown
NETSNMP_CONF_OPTS += --with-logfile=none
NETSNMP_CONF_OPTS += --with-perl-modules=no
NETSNMP_CONF_OPTS += --with-default-snmp-version=2
NETSNMP_CONF_OPTS += --with-out-mib-modules=${WITH_OUT_MIB_MODULES}
NETSNMP_CONF_OPTS += --with-mib-modules=${WITH_MIB_MODULES}
NETSNMP_CONF_OPTS += --with-persistent-directory=${NET_SNMP_PERSISTENT_DIR}
NETSNMP_CONF_OPTS += --enable-shared
NETSNMP_CONF_OPTS += --disable-static
NETSNMP_CONF_OPTS += --with-enterprise-sysoid=1.3.6.1.4.1.31926
NETSNMP_CONF_OPTS += --with-enterprise-notification-oid=1.3.6.1.4.1.31926
NETSNMP_CONF_OPTS += --with-enterprise-oid=31926
NETSNMP_CONF_OPTS += --with-gnu-ld
NETSNMP_CONF_OPTS += --with-cflags=${TARGET_CFLAGS}
endif

ifneq ($(BR2_PACKAGE_NETSNMP_ENABLE_DEBUGGING),y)
NETSNMP_CONF_OPTS += --disable-debugging
endif

ifeq ($(BR2_PACKAGE_NETSNMP_SERVER),y)
NETSNMP_CONF_OPTS += --enable-agent
else
NETSNMP_CONF_OPTS += --disable-agent
endif

ifeq ($(BR2_PACKAGE_NETSNMP_CLIENTS),y)
NETSNMP_CONF_OPTS += --enable-applications
else
NETSNMP_CONF_OPTS += --disable-applications
endif

ifeq ($(BR2_PACKAGE_NETSNMP_SERVER),y)
define NETSNMP_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/netsnmp/S59snmpd \
		$(TARGET_DIR)/etc/init.d/S59snmpd
endef
endif
define NETSNMP_STAGING_NETSNMP_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include\',g" \
		-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" \
		$(STAGING_DIR)/usr/bin/net-snmp-config
endef

define NETSNMP_POST_PATCH_FIXUP
	echo " ============ Patch net-snmp-config.h file after configure ============="
	$(SED) 's;#define STRUCT_NLIST_HAS_N_VALUE 1;/* #undef STRUCT_NLIST_HAS_N_VALUE */;g' $(@D)/include/net-snmp/net-snmp-config.h
	$(SED) 's;#define HAVE_NLIST_H 1;/* #undef HAVE_NLIST_H */;g' $(@D)/include/net-snmp/net-snmp-config.h
	echo " ================= DONE ================"
endef

NETSNMP_POST_CONFIGURE_HOOKS += NETSNMP_POST_PATCH_FIXUP

NETSNMP_POST_INSTALL_STAGING_HOOKS += NETSNMP_STAGING_NETSNMP_CONFIG_FIXUP

$(eval $(autotools-package))
