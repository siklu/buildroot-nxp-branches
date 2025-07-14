#!/bin/bash -eu
# See https://jira-siklu.atlassian.net/wiki/spaces/SIKLURND/pages/2220884306/NXP+5.8.18+New+BSP+External+Repos+HowTo

# Do not commit uncommented changes in this file except on topic branches.
# That is, in the main or master branch, all lines of this file should always
# be commented.

#my_topic_branch="DEVOPS-156-siklu-80XX-buildroot-mirror-site"

# For topic branch builds:
#	If you have made changes to code in the external repos,
#	then export the name of your topic branch in the external repo. 

# Repos
#export UBOOT_REPO_URL="https://github.com/siklu/u-boot-${vnd}-branches.git"
#export LINUX_REPO_URL="https://github.com/siklu/linux-${vnd}-branches.git"
#export BR2_REPO_URL="https://github.com/siklu/buildroot-${vnd}-branches.git"
#export SNMP_MIBS_REPO_URL="git@github.com:siklu/mibs.git"

# Branches and commits
#export UBOOT_BRANCH="${my_topic_branch}"
#export UBOOT_COMMIT=""

#export LINUX_BRANCH="${my_topic_branch}"
#export LINUX_COMMIT=""

#export BR2_BRANCH="${my_topic_branch}"
#export BR2_COMMIT="4f9b2dfc63c5d0370364a6d5138b624b0d7e4ea9"

#export SNMP_MIBS_BRANCH=${SNMP_MIBS_DEFAULT_BRANCH}
#export SNMP_MIBS_COMMIT="0deac70f1ebb99b5cd404274fb3d991c7ee88c50"

# Paths and URLs
#export LINUX_DTBS="imx6ull-14x14-siklu.dtb"

#export WEBUI_PACKAGE_NAME="eh80xx-0.0.1-911-31d3d945.tgz"
#export WEBUI_URL="http://siklu-ubuntu18/repository/portfolio/web2/${WEBUI_PACKAGE_NAME}"
#export BUILDROOT_80XX_MIRROR="http://siklu-ubuntu18/repository/portfolio/buildroot/80XX-29072022/"

# ARM toolchain
#export CROSS_COMPILE=/bin/arm-none-linux-gnueabihf-
# You can add to the current $PATH but not replace it
#export PATH=:$PATH

# Used in ~/shallow_clone/nxp/buildroot/portf-nxp-2021.11 and ~/swallow_clone/nxp/portf-nxp-2021.11
#export CACHE_ROOT_DIR=${HOME}

# Used to define the previous setup: NXP or not NXP
#export PS1="\[\e[35;1m\][Nxp SDK$SIKLU_DOCKER_PS1]\[\e[0m\]:\w> "
#
export RAM_DISK=/home/weber/projects
export CACHE_ROOT_DIR=${RAM_DISK}/cache
export CCACHE_DIR=${CACHE_ROOT_DIR}/ccache
export WEBUI_URL="http://192.168.10.4/${WEBUI_PACKAGE_NAME}"
export BUILDROOT_80XX_MIRROR="http://192.168.10.4/buildroot/"
export BUILD_THREADS_COUNT=86
