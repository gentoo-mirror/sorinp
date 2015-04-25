# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="3D / 2D CAD software for mechanical engineering"
HOMEPAGE="http://www.varicad.com/"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE="en linguas_de linguas_en linguas_pt"

LANG='en'
use linguas_de && LANG='de'
use linguas pt && LANG='pt'
use en && LANG='en'

RDEPEND="( sci-misc/varicad-${LANG} )"
