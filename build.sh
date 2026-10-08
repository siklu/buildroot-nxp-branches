#!/bin/bash
# @(#) Convenience script for building Siklu portfolio NXP Buildroot
# For convenience and reference only, not used by sdk_nxp/platform.mk.

# Set PROJECT_ROOT_DIR to some place where you have checked out the portfolio
# repo so that you will have access to the scripts that are used in Siklu's
# additions to Buildroot. This variable does not affect the place where
# Buildroot is built, which is in the current directory where this script
# resides. [The requirement is to define this variable in the Buildroot
# directory is a Siklu design flaw that should be fixed.]
export PROJECT_ROOT_DIR="$(pwd)"

# Before running this script you must set CACHE_ROOT_DIR to a directory in a
# partition that has sufficient space for the ccache and Buildroot dl directory
# for your rootfs configuration.
if [ -z "${CACHE_ROOT_DIR+x}" ]
then
	echo "ERROR: Before running this script please export the variable"
	echo "CACHE_ROOT_DIR who's value should be a dirname that will hold"
	echo "the ccache and Buildroot dl directories."
	exit 1
fi
if [ ! -d "${CACHE_ROOT_DIR}" ]
then
	echo "ERROR: The envar CACHE_ROOT_DIR is not set to a dirname."
	exit 1
fi

# Buildroot builds its own gcc (BR2_TOOLCHAIN_BUILDROOT_GLIBC); no external
# cross compiler is needed. Every source, the toolchain's kernel headers
# included, downloads from BUILDROOT_80XX_MIRROR (BR2_PRIMARY_SITE_ONLY), so
# export it as setupNxp in the portfolio repo does. The portfolio build also
# sets LINUX_HEADERS_OVERRIDE_SRCDIR to its kernel tree; a standalone build
# without it needs the linux-headers tarball on the mirror.

# Temporarily comment out whatever you don't need.
#make oldconfig
make siklu_80X0_defconfig
#make menuconfig
#make savedefconfig
make clean
make
