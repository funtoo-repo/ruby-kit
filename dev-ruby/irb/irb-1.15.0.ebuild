# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby27 ruby30 ruby31 ruby32"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_BINDIR="exe"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="interactive Ruby"
HOMEPAGE="https://github.com/ruby/irb"
SRC_URI="https://github.com/ruby/irb/tarball/d3531d8fc06445df726f66f2eac56693d0b9e009 -> irb-1.15.0-d3531d8.tar.gz"

KEYWORDS="*"
LICENSE="|| ( Ruby BSD-2 )"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit )"
ruby_add_rdepend "dev-ruby/reline"

post_src_unpack() {
	if [ ! -d "${S}/all/${P}" ] ; then
		mv "${WORKDIR}"/all/ruby-irb-* "${S}"/all/"${P}" || die
	fi
}

all_ruby_prepare() {
	sed -e 's:require_relative ":require "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_install() {
	doman man/irb.1
}