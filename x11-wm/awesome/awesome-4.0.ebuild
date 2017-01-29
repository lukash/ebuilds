# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
CMAKE_MIN_VERSION="3.0"
inherit cmake-utils eutils

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="http://awesomewm.org/"

if [[ ${PV} != 999? ]]; then
	SRC_URI="https://github.com/awesomeWM/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
else
	inherit git-r3
	EGIT_REPO_URI="git://github.com/awesomeWM/${PN}.git"
	EGIT_BRANCH="master"
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="dbus elibc_FreeBSD gnome"
# luajit

	# luajit? ( >=dev-lang/luajit-2.0.2 )
COMMON_DEPEND="
	>=dev-lang/lua-5.1:0
	dev-libs/glib:2
	>=dev-libs/libxdg-basedir-1
	>=dev-lua/lgi-0.8.0
	x11-libs/cairo[xcb]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libxcb-1.6[xkb]
	>=x11-libs/pango-1.19.3[introspection]
	>=x11-libs/startup-notification-0.10_p20110426
	>=x11-libs/xcb-util-0.3.8
	>=x11-libs/xcb-util-xrm-1.0
	x11-libs/xcb-util-cursor
	x11-libs/libXcursor
	>=x11-libs/libX11-1.3.99.901
	dbus? ( >=sys-apps/dbus-1 )
	elibc_FreeBSD? ( dev-libs/libexecinfo )
"

DEPEND="
	${COMMON_DEPEND}
	>=app-text/asciidoc-8.4.5
	app-text/xmlto
	dev-util/gperf
	virtual/pkgconfig
	x11-base/xorg-server
	x11-libs/libxkbcommon
	media-gfx/imagemagick[png]
	>=x11-proto/xcb-proto-1.5
	>=x11-proto/xproto-7.0.15
"

RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-xsession.patch"
	# bug #509658
	epatch "${FILESDIR}/${PN}-master-cflag-cleanup.patch"

	# if use luajit; then
	#     epatch "${FILESDIR}/${PN}-luajit.patch"
	# fi

	eapply_user
}

src_configure() {
	# local mylualibs=""
	# if use luajit; then
	#     mylualibs="/usr/lib/libluajit-5.1.so"
	# fi
	mycmakeargs=(
		-DPREFIX="${EPREFIX}"/usr
		-DSYSCONFDIR="${EPREFIX}"/etc
		-DWITH_DBUS="$(usex dbus)"
	)
	# -DDOC="$(usex doc)"
	# -DLUA_LIBRARIES="${mylualibs}"
	cmake-utils_src_configure
}

src_compile() {
	local myargs="all"
	# if use luajit; then
	#     export LD_PRELOAD="/usr/lib/libluajit-5.1.so"
	# fi
	cmake-utils_src_make ${myargs}
}

src_install() {
	cmake-utils_src_install
	# rm -rf "${ED}"/usr/share/doc/${PN} || die "Cleanup of dupe docs failed"
	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN} || die
	# GNOME-based awesome
	if use gnome ; then
		insinto /usr/share/gnome-session/sessions
		newins "${FILESDIR}/${PN}-gnome-3.session" "${PN}-gnome.session" || die
		domenu "${FILESDIR}/${PN}-gnome.desktop" || die
		insinto /usr/share/xsessions/
		doins "${FILESDIR}/${PN}-gnome-xsession.desktop" || die
	fi
}

pkg_postinst() {
	# bug #447308
	if use gnome; then
		einfo
		elog "You have enabled the gnome USE flag."
		elog "Please note that quitting awesome won't kill your gnome session."
		elog "To really quit the session, you should bind your quit key"
		elog "to the following command:"
		elog "  gnome-session-quit --logout"
		elog "For more info visit"
		elog "  https://bugs.gentoo.org/show_bug.cgi?id=447308"
	fi
	# if use luajit; then
	#     elog "To enable luajit's jit add the following line to your"
	#     elog "~/.config/awesome/rc.lua:"
	#     elog "    pcall(function() jit.on() end)"
	# fi
	# bug #440724
	einfo
	elog "If you are having issues with Java application windows being"
	elog "completely blank, try installing"
	elog "  x11-misc/wmname"
	elog "and setting the WM name to LG3D."
	elog "For more info visit"
	elog "  https://bugs.gentoo.org/show_bug.cgi?id=440724"
	einfo
}
