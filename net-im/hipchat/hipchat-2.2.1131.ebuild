# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Group chat and video chat built for teams."
HOMEPAGE="https://www.hipchat.com/"
[ "$ARCH" == 'amd64' ] && MY_ARCH='x86_64'
[ "$ARCH" == 'x86' ] && MY_ARCH='i686'
SRC_URI="http://downloads.${PN}.com/linux/arch/${PN}-${MY_ARCH}.tar.xz"

LICENSE="Atlassian"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}

RDEPEND=""

# Avoid QA notices
QA_PREBUILT="/opt/HipChat/bin/${PN}"
QA_PRESTRIPPED="/opt/HipChat/lib/*"

src_prepare(){
	# Avoid QA notices
	sed -ri 's/Terminal=0/Terminal=false/g;s/\.png//g' usr/share/applications/hipchat.desktop || die "Could not modify hipchat.desktop. Was fixed upstream?"
}

src_install() {
	insinto /opt
	doins -r opt/HipChat
	chmod a+x ${D}/opt/HipChat/bin/hipchat ${D}/opt/HipChat/lib/hipchat.bin
	dodir /opt/bin
	dosym /opt/HipChat/bin/hipchat /opt/bin/hipchat
	dosym libz.so.1 /opt/HipChat/lib/libz.so
	dosym libuuid.so.1 /opt/HipChat/lib/libuuid.so
	dosym liblzma.so.5 /opt/HipChat/lib/liblzma.so

	ICONDIR='usr/share/icons/hicolor/apps'
	for res in 16 24 32 128 256
	do
		[ -f ${ICONDIR}/${res}x${res}/hipchat.png ] && \
			doicon -s ${res} ${ICONDIR}/${res}x${res}/hipchat.png
		[ -f ${ICONDIR}/${res}x${res}/hipchat-attention.png ] && \
			doicon -s ${res} ${ICONDIR}/${res}x${res}/hipchat-attention.png
	done

	domenu usr/share/applications/hipchat.desktop
}
