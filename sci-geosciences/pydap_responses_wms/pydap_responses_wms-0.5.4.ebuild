# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

MY_PN=${PN//_/.}
MY_P=${P//_/.}

DESCRIPTION="WMS responses for Pydap Data Access Protocol server"
HOMEPAGE="http://pydap.org"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3[${PYTHON_USEDEP}]"
RDEPEND="
	>=sci-geosciences/pydap-3.0_rc10[${PYTHON_USEDEP}]
	>=dev-python/paste-1.7.2[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]"

S="$WORKDIR/$MY_P"
