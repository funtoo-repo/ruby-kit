# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

inherit ruby-ng prefix

DESCRIPTION="Library packaging and distribution for Ruby."
HOMEPAGE="https://rubygems.org/ https://github.com/rubygems/rubygems"
SRC_URI="https://github.com/rubygems/rubygems/tarball/cffd973142d35f1216b530a47e32b74d6fa8c926 -> rubygems-3.6.5-cffd973.tar.gz"

KEYWORDS="*"
LICENSE="GPL-2 || ( Ruby MIT )"
SLOT="0"
IUSE="server test"
RESTRICT="!test? ( test )"

PDEPEND="server? ( =dev-ruby/builder-3* )"

ruby_add_depend "virtual/ruby-ssl"
ruby_add_bdepend "
	test? (
		dev-ruby/json
		dev-ruby/minitest:5
		dev-ruby/rake
		dev-ruby/rdoc
		dev-ruby/webrick
	)"

post_src_unpack() {
	if [ ! -d "${S}/all/${P}" ] ; then
		mv "${WORKDIR}"/all/rubygems-rubygems-* "${S}"/all/"${P}" || die
	fi
}

all_ruby_prepare() {
	# Remove unpackaged automatiek from Rakefile which stops it from working
	sed -i -e '/automatiek/ s:^:#:' -e '/Automatiek/,/^end/ s:^:#:' Rakefile || die

	mkdir -p lib/rubygems/defaults || die
	cp "${REPODIR}/dev-ruby/files/${PN}/gentoo-defaults-5.rb" lib/rubygems/defaults/operating_system.rb || die

	eprefixify lib/rubygems/defaults/operating_system.rb

	# Disable broken tests when changing default values:
	sed -i -e '/test_default_path/,/^  end/ s:^:#:' test/rubygems/test_gem.rb || die
	sed -i -e '/test_initialize_\(path_with_defaults\|regexp_path_separator\)/aomit "gentoo"' test/rubygems/test_gem_path_support.rb || die
	# Avoid test that won't work as json is also installed as plain ruby code
	sed -i -e '/test_realworld_\(\|upgraded_\)default_gem/aomit "gentoo"' test/rubygems/test_require.rb || die

	# Avoid test that requires additional utility scripts
	rm -f test/test_changelog_generator.rb || die

	# Update manifest after changing files to avoid a test failure
	if use test; then
		rake update_manifest || die
	fi
	if [ -d "${S}/exe" ]; then
		export BIN_EXE_DIR=exe
	else
		export BIN_EXE_DIR=bin
	fi
}

each_ruby_compile() {
	# Not really a build but...
	sed -i -e 's:#!.*:#!'"${RUBY}"':' $BIN_EXE_DIR/gem || die
}

each_ruby_test() {
	# Unset RUBYOPT to avoid interferences, bug #158455 et. al.
	#unset RUBYOPT

	if [[ "${EUID}" -ne "0" ]]; then
		RUBYLIB="$(pwd)/lib${RUBYLIB+:${RUBYLIB}}" ${RUBY} --disable-gems -I.:lib:test:bundler/lib \
			-e 'require "rubygems"; gem "minitest", "~>5.0"; Dir["test/**/test_*.rb"].each { |tu| require tu }' || die "tests failed"
	else
		ewarn "The userpriv feature must be enabled to run tests, bug 408951."
		eerror "Testsuite will not be run."
	fi
}

each_ruby_install() {
	# Unset RUBYOPT to avoid interferences, bug #158455 et. al.
	unset RUBYOPT
	export RUBYLIB="$(pwd)/lib${RUBYLIB+:${RUBYLIB}}"

	pushd lib &>/dev/null
	doruby -r *
	popd &>/dev/null

	local sld=$(ruby_rbconfig_value 'sitelibdir')
	insinto "${sld#${EPREFIX}}"  # bug #320813
	newbin $BIN_EXE_DIR/gem $(basename ${RUBY} | sed -e 's:ruby:gem:')
}

all_ruby_install() {
	dodoc CHANGELOG.md README.md

	if use server; then
		newinitd "${REPODIR}/dev-ruby/files/${PN}/init.d-gem_server2" gem_server
		newconfd "${REPODIR}/dev-ruby/files/${PN}/conf.d-gem_server" gem_server
	fi
}

pkg_postinst() {
	if [[ ! -n $(readlink "${ROOT}"/usr/bin/gem) ]] ; then
		eselect ruby set $(eselect --brief --colour=no ruby show | head -n1)
	fi

	ewarn
	ewarn "To switch between available Ruby profiles, execute as root:"
	ewarn "\teselect ruby set ruby(26|27|30|31|...)"
	ewarn
}