# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby27 ruby30 ruby31 ruby32"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Additional test assertions for Ruby standard libraries"
HOMEPAGE="https://github.com/ruby/test-unit-ruby-core"
SRC_URI="https://github.com/ruby/test-unit-ruby-core/tarball/9e74ba846449ad2bcc03867095a49762f34de697 -> test-unit-ruby-core-1.0.13-9e74ba8.tar.gz"

KEYWORDS="*"
LICENSE="|| ( Ruby GPL-2 ) PSF-2"
SLOT="2"