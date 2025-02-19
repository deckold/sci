# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# upstream hasn't tested python 3.8 fully
PYTHON_COMPAT=( python3_{6..8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1 optfeature

DESCRIPTION="Statistical and interactive HTML plots for Python"
HOMEPAGE="https://bokeh.org/
	https://github.com/bokeh/bokeh
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# upstream authoritative dependencies
# https://github.com/bokeh/bokeh/blob/master/conda.recipe/meta.yaml
RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	>=www-servers/tornado-5[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/ipython_genutils[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		dev-python/pydot[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-conftest_py.patch
)

python_test() {
	# disable tests having network calls
	local SKIP_TESTS=" \
		not (test___init__ and TestWarnings and test_filters) and \
		not (test_json__subcommands and test_no_script) and \
		not (test_standalone and Test_autoload_static) and \
		not test_nodejs_compile_javascript and \
		not test_nodejs_compile_less and \
		not test_inline_extension and \
		not (test_model and test_select) and \
		not test_tornado__server and \
		not test_client_server and \
		not test_webdriver and \
		not test_export and \
		not test_server and \
		not test_bundle and \
		not test_ext \
	"
	pytest -m "not sampledata" tests/unit -k \
		   "${SKIP_TESTS}" -vv || die "unittests fail with ${EPYTHON}"
}

pkg_postinst() {
	optfeature "integration with amazon S3" dev-python/boto
	optfeature "pypi integration to publish packages" dev-python/twine
	optfeature "js library usage" net-libs/nodejs
}
