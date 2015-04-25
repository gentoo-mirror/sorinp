# Copyright 1999-${V_YEAR} Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="VeriCAD"
HOMEPAGE="http://www.varicad.com/en/home/products/download/"

LANG=${PN/*-/}
MY_PN=${PN/-*/}
V_YEAR=${PV/\.*/}
V_MINOR=${PV/$V_YEAR\./}
SRC_URI="${MY_PN}${V_YEAR}-${LANG}_${V_MINOR}_${ARCH}.deb"

LICENSE=""
SLOT="0"

# NOTE: varicad binaries are supplied just pre-stripped.
RESTRICT="fetch strip"

KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXt
	virtual/opengl"

S="${WORKDIR}"

pkg_nofetch() {
	echo
	eerror "Please go to: http://www.varicad.com/"
	eerror
	eerror "and download the VariCAD for Linux ${V_YEAR} ${V_MINOR}"
	eerror " Debian package for your platform"
	eerror "After downloading it, put the .deb into:"
	eerror "  ${DISTDIR}"
	echo
}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
	cd "${S}"

	# removing not necessary content
	rm control.tar.gz data.tar.gz debian-binary \
		opt/VariCAD/desktop/*.sh \
		usr/share/menu/varicad${V_YEAR}-en \
		opt/VariCAD/desktop/varicad.mdkmenu \
		opt/VariCAD/desktop/varicad.wmconfig

	# NOTE: we need to strip some (useless) quotes
	sed -i \
		-e "s:\"::g" opt/VariCAD/desktop/varicad.desktop \
		|| die "seding varicad.desktop failed"
}

src_install() {
	# creating the desktop menu
	domenu opt/VariCAD/desktop/varicad.desktop || die "domenu failed."
	domenu opt/VariCAD/desktop/x-varicad.desktop || die "domenu mime-type failed."
	doicon opt/VariCAD/desktop/{varicad_*.png,varicad.xpm} || die "doicon failed."
	rm opt/VariCAD/desktop/*.desktop \
		opt/VariCAD/desktop/varicad_*.png
	rm -r opt/VariCAD/desktop

	# Fixing permissions so that any user can run Varicad.
	# This is a desktop system so typically only one user uses it.
	# If there are more users, the first to install a license will become
	# the only user allowed to use VariCAD on that system, as the license
	# permissions will likely be 644 on that file with the current user as owner,
	# so other users will not be able to overwrite the license.
	chown -R :users opt/VariCAD
	chmod -R g+w opt/VariCAD

	# installing the docs
	dodoc usr/share/doc/varicad${V_YEAR}-en/{README-en.txt,README.Debian,copyright,changelog.gz}
	rm usr/share/doc/varicad${V_YEAR}-en/*

	# installing VariCAD
	cp -pPR * "${D}"/ || die "installing data failed"
}
