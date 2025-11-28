# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby27 ruby30 ruby31 ruby32"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Additional test assertions for Ruby standard libraries"
HOMEPAGE="https://github.com/ruby/test-unit-ruby-core"
SRC_URI="https://github.com/ruby/test-unit-ruby-core/tarball/f31f6dbc1dd1984ff72f9ddf87d0e226be825e2d -> test-unit-ruby-core-1.0.14-f31f6db.tar.gz"

KEYWORDS="*"
LICENSE="|| ( Ruby GPL-2 ) PSF-2"
SLOT="2"