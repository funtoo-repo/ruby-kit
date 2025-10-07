# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby27 ruby30 ruby31 ruby32"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Additional test assertions for Ruby standard libraries"
HOMEPAGE="https://github.com/ruby/test-unit-ruby-core"
SRC_URI="https://github.com/ruby/test-unit-ruby-core/tarball/af45326cd4adca6f4d0a175c5309124ab76ddba8 -> test-unit-ruby-core-1.0.9-af45326.tar.gz"

KEYWORDS="*"
LICENSE="|| ( Ruby GPL-2 ) PSF-2"
SLOT="2"