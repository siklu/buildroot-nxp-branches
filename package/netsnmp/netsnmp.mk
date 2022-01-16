#############################################################
#
# netsnmp
#	# 26 March 2017
#	Siklu code need same version used in CVMX: 5.4.2.1
#	In addition we need 3 patches:
#
#	1. _netsnmp-001-config.h.patch
#  	2. netsnmp-002-agent.patch      
#	3. netsnmp-003-agent.c.patch
#		But first patch file _netsnmp-001-config.h.patch should be applied 
#		after configuration process, therefore we can't use standard buildroot patch enginee and file name "corrupted" by add prefix "_"
#		For this purpose used	NETSNMP_POST_CONFIGURE_HOOKS roole. See below
#	All compilation flags copied as-is from CVMX	
#
#############################################################

# NETSNMP_VERSION = 5.7.2
# NETSNMP_VERSION = 5.4.4

# Siklu uses follow version:
NETSNMP_VERSION = 5.4.2.1

#NETSNMP_SITE = http://downloads.sourceforge.net/project/net-snmp/net-snmp/$(NETSNMP_VERSION)
NETSNMP_SITE = $(BR2_SIKLU_FTP_URL)
NETSNMP_SOURCE = net-snmp-$(NETSNMP_VERSION).tar.gz
NETSNMP_LICENSE = Various BSD-like
NETSNMP_LICENSE_FILES = COPYING
NETSNMP_INSTALL_STAGING = YES
NETSNMP_CONF_ENV = ac_cv_NETSNMP_CAN_USE_SYSCTL=yes

NET_SNMP_PERSISTENT_DIR:=/var
WITH_OUT_MIB_MODULES:="mibII/snmp_mib, mibII/system_mib, mibII/sysORTable"
WITH_MIB_MODULES:="ucd-snmp/dlmod"
NET_SNMP_PERSISTENT_DIR:=/var

TARGET_CFLAGS = -DNETSNMP_NO_INLINE




NETSNMP_CONF_OPTS = --silent --enable-agent --disable-manuals --enable-as-needed \
		--disable-scripts --enable-ipv6 --disable-embedded-perl --disable-perl-cc-checks \
		--with-transports="UDPIPv6" \
		--with-out-transports="TCPIPv6 AAL5PVC IPX" --without-rpm \
		--enable-mini-agent --disable-mib-loading \
		--with-sys-contact=root@ --with-sys-location=unknown --with-logfile=none  \
		--with-perl-modules=no --disable-snmptrapd-subagent --with-default-snmp-version=2 \
		--with-out-mib-modules=${WITH_OUT_MIB_MODULES} --with-mib-modules=${WITH_MIB_MODULES} \
		--with-persistent-directory=${NET_SNMP_PERSISTENT_DIR} \
		--enable-shared --disable-static \
		--with-enterprise-sysoid=1.3.6.1.4.1.31926 --with-enterprise-notification-oid=1.3.6.1.4.1.31926 --with-enterprise-oid=31926 \
		--with-gnu-ld --with-cflags=${TARGET_CFLAGS}


### --enable-static --disable-shared \

NETSNMP_MAKE = $(MAKE1)
NETSNMP_BLOAT_MIBS = BRIDGE DISMAN-EVENT DISMAN-SCHEDULE DISMAN-SCRIPT EtherLike RFC-1215 RFC1155-SMI RFC1213 SCTP SMUX

ifeq ($(BR2_ENDIAN),"BIG")
	NETSNMP_CONF_OPTS += --with-endianness=big
else
	NETSNMP_CONF_OPTS += --with-endianness=little
endif



# Remove IPv6 MIBs if there's no IPv6
ifneq ($(BR2_INET_IPV6),y)
define NETSNMP_REMOVE_MIBS_IPV6
	rm -f $(TARGET_DIR)/usr/share/snmp/mibs/IPV6*
endef
endif


define NETSNMP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) install
	$(INSTALL) -D -m 0755 package/netsnmp/S59snmpd \
		$(TARGET_DIR)/etc/init.d/S59snmpd
	for mib in $(NETSNMP_BLOAT_MIBS); do \
		rm -f $(TARGET_DIR)/usr/share/snmp/mibs/$$mib-MIB.txt; \
	done
	$(NETSNMP_REMOVE_MIBS_IPV6)
endef

define NETSNMP_UNINSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) uninstall
	rm -f $(TARGET_DIR)/etc/init.d/S59snmpd
	rm -f $(TARGET_DIR)/usr/lib/libnetsnmp*
endef

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
