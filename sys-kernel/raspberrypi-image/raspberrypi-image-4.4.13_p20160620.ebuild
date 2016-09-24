# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit readme.gentoo-r1

DESCRIPTION="Raspberry PI Linux kernel and device tree"
HOMEPAGE="https://github.com/raspberrypi/firmware"
FIRMWARE_VERSION="1.${PV//*p/}"
MY_PV="${PV//_*/}"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${FIRMWARE_VERSION}.tar.gz -> raspberrypi-firmware-${FIRMWARE_VERSION}.tar.gz"

# FIXME: do we need raspberrypi-videocore-bin?
LICENSE="GPL-2 raspberrypi-videocore-bin"
SLOT="${MY_PV}"
KEYWORDS="~arm -*"
IUSE="+hardfp"

DEPEND=""
RDEPEND="=sys-boot/raspberrypi-firmware-${FIRMWARE_VERSION}"

RESTRICT=""
S="${WORKDIR}/raspberrypi-firmware-${FIRMWARE_VERSION}"

# Do not add periods after file names, as people may confuse the name of the files.
DOC_CONTENTS="The package needs a configuration file: /boot/cmdline.txt
If the file does not exist already, it will be installed now.
If the file exists already, a new file will be created: /boot/cmdline.txt.dist
DO NOT alter the cmdline.txt.dist file; please merge its contents to cmdline.txt
config.txt.dist file will be overwritten at the next update.

More information here:
 - http://elinux.org/RPi_cmdline.txt"

pkg_preinst() {
	if ! grep "${ROOT}boot" /proc/mounts >/dev/null 2>&1; then
		ewarn "${ROOT}boot is not mounted, the files might not be installed at the right place"
	fi
}

src_unpack() {
	if [ "${A}" != "" ]
	then
		unpack ${A}
		# FIXME: why is this necessary here and not in raspberrypi-userland-bin and raspberrypi-firmware?
		mv ${WORKDIR}/firmware-${FIRMWARE_VERSION} ${WORKDIR}/raspberrypi-firmware-${FIRMWARE_VERSION}
	fi
}

src_install() {
	# TODO: only install files relevant to the current architecture.
	# FIXME: fix it for cross compilation: detect arch unless specified.
	readme.gentoo_create_doc

	dodir /boot/overlays
	insinto /boot
		doins boot/COPYING.linux
		doins boot/*.dtb
		newins ${FILESDIR}/raspberrypi-firmware-1_p20160620-cmdline.txt cmdline.txt.dist
		[ ! -e "$ROOT"/boot/cmdline.txt ] && newins ${FILESDIR}/raspberrypi-firmware-1_p20160620-cmdline.txt cmdline.txt.dist
		doins extra/dt-blob.dts
		doins extra/git_hash
	insinto /boot/overlays
		doins -r boot/overlays

	# FIXME: fix this for cross compilation: detect arch unless specified.
	#		 should we use useflags?
	[ -z "${arch}" ] && arch="$( uname -m )"
	case ${arch} in
	armv6l)
		dodir /lib/modules/${MY_PV}+
		insinto /boot
			doins boot/kernel.img
			doins extra/Module.symvers
			doins extra/System.map
			doins extra/uname_string
		insinto /lib/modules/${MY_PV}+
			doins -r modules/${MY_PV}+/*
	;;
	armv7l)
		dodir /lib/modules/${MY_PV}-v7+
		insinto /boot
			doins boot/kernel7.img
			doins extra/Module7.symvers
			doins extra/System7.map
			doins extra/uname_string7
		insinto /lib/modules/${MY_PV}-v7+
			doins -r modules/${MY_PV}-v7+/*
	;;
	esac

	readme.gentoo_create_doc
}

