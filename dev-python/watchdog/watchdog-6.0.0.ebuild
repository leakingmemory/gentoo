# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python API and shell utilities to monitor file system events"
HOMEPAGE="
	https://github.com/gorakhargosh/watchdog/
	https://pypi.org/project/watchdog/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pytest-timeout-0.3[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# known flaky
		tests/test_emitter.py::test_close
		# requires root powers via sudo (yes, seriously)
		tests/test_inotify_buffer.py::test_unmount_watched_directory_filesystem
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# there's a test opening 2048 files
	ulimit -n 4096 || die
	epytest -o addopts=
}

pkg_postinst() {
	optfeature "Bash completion" dev-python/argcomplete
}
