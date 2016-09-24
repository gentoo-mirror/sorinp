# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit readme.gentoo-r1

DESCRIPTION="Raspberry PI boot loader and firmware"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 raspberrypi-videocore-bin"
SLOT="0"
KEYWORDS="~arm -*"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${P/raspberrypi-}

RESTRICT="binchecks strip"

# Do not add periods after file names, as people may confuse the name of the files
DOC_CONTENTS="The package needs a configuration file: /boot/config.txt
If the file does not exist already, it will be installed now.
If the file exists already, a new file will be created: /boot/config.txt.dist
DO NOT alter the config.txt.dist file; please merge its contents to config.txt
config.txt.dist file will be overwritten at the next update

More information here:
 - https://www.raspberrypi.org/documentation/configuration/config-txt.md
 - http://elinux.org/RPi_config.txt"

pkg_preinst() {
	if ! grep "${ROOT}boot" /proc/mounts >/dev/null 2>&1; then
	ewarn "${ROOT}boot is not mounted, the files might not be installed at the right place"
	fi
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /boot
	newins ${FILESDIR}/raspberrypi-firmware-1_p20160620-config.txt config.txt.dist
	[ ! -e "$ROOT"/boot/config.txt ] && newins ${FILESDIR}/raspberrypi-firmware-1_p20160620-config.txt config.txt
	doins boot/bootcode.bin
	doins boot/*.elf
	doins boot/*.dat
	doins boot/LICENCE.broadcom

	readme.gentoo_create_doc
}
