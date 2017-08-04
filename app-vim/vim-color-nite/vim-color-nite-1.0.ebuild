# Copyright 2017 Lukáš Hrázký
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A color scheme for vim"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"

LICENSE="GPL-2"
SLOT="0"

COMMON_DEPEND="=app-editors/vim-8.0*"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S=${WORKDIR}

src_install() {
	insinto /usr/share/vim/vim80/colors
	doins "${FILESDIR}/nite.vim" || die
}
