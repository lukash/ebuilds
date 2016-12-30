# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="BS1770GAIN is a loudness scanner compliant with ITU-R BS.1770 and
its flavors EBU R128, ATSC A/85, and ReplayGain 2.0. It helps normalizing the
loudness of audio and video files to the same level."
HOMEPAGE="http://bs1770gain.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-video/ffmpeg
	media-sound/sox
"

RDEPEND="${DEPEND}"
