# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby27 ruby30 ruby31 ruby32"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_BINDIR="exe"
RUBY_FAKEGEM_EXTENSIONS=(ext/debug/extconf.rb)
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Debugging functionality for Ruby"
HOMEPAGE="https://github.com/ruby/debug"
SRC_URI="https://github.com/ruby/debug/tarball/bead0984d241a91235e3d3bacd247f0363d2d530 -> debug-1.10.0-bead098.tar.gz"

KEYWORDS="*"
LICENSE="|| ( Ruby BSD-2 )"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit )"

post_src_unpack() {
	if [ ! -d "${S}/all/${P}" ] ; then
		mv "${WORKDIR}"/all/ruby-debug-* "${S}"/all/"${P}" || die
	fi
}

all_ruby_prepare() {
	sed -e "s:require_relative ':require './:" \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -e 's:require_relative ":require "./:' \
		-i Rakefile || die
}

all_ruby_install() {
	ruby_fakegem_binwrapper rdbg
}