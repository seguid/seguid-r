SHELL=bash

BROWSER=google-chrome

all: install check check-cli

#---------------------------------------------------------------
# Install package
#---------------------------------------------------------------
requirements:
	Rscript -e "install.packages(c('knitr', 'rmarkdown'))"

install: doc
	Rscript -e "install.packages('.', repos = NULL)"

#---------------------------------------------------------------
# Build documentation
#---------------------------------------------------------------
doc:
	Rscript -e "devtools::document()"

#---------------------------------------------------------------
# Build R package tarball
#---------------------------------------------------------------
build: doc
	mkdir -p ".local"
	rm .local/seguid_*.tar.gz || true
	cd ".local" && R CMD build ..

#---------------------------------------------------------------
# Check package
#---------------------------------------------------------------
check: build
	cd ".local" && R CMD check --as-cran seguid_*.tar.gz

#---------------------------------------------------------------
# Estimate test code coverage
#---------------------------------------------------------------
coverage-html:
	tf=$$(mktemp --suffix="-report.html"); \
	Rscript -e "c <- covr::package_coverage(quiet = FALSE); print(c); r <- covr::report(c, file='$${tf}'); utils::browseURL(r, browser = '$(BROWSER)')"

#---------------------------------------------------------------
# Check spelling
#---------------------------------------------------------------
spelling:
	Rscript -e "spelling::spell_check_package()"
	Rscript -e "spelling::spell_check_files(c('NEWS.md', dir('vignettes', pattern='[.]Rmd$$', full.names=TRUE)), ignore=readLines('inst/WORDLIST', warn=FALSE))"

#---------------------------------------------------------------
# Check via https://win-builder.r-project.org/
#---------------------------------------------------------------
WIN_BUILDER = win-builder.r-project.org
win-builder-devel: .local/seguid_*.tar.gz
	curl -v -T "$?" ftp://anonymous@$(WIN_BUILDER)/R-devel/

win-builder-release: .local/seguid_*.tar.gz
	curl -v -T "$?" ftp://anonymous@$(WIN_BUILDER)/R-release/

win-builder: win-builder-devel win-builder-release

#---------------------------------------------------------------
# Check CLI using 'seguid-tests' test suite
#---------------------------------------------------------------
check-cli: Makefile.seguid-tests tests/cli.bats
	make MAKE="$(MAKE) -f Makefile.seguid-tests" -f Makefile.seguid-tests check-cli/seguid-python

Makefile.seguid-tests: 
	curl -H "Cache-Control: no-cache" -L -o "$@" https://raw.githubusercontent.com/seguid/seguid-tests/main/Makefile

tests/cli.bats:
	curl -H "Cache-Control: no-cache" -L -o "$@" https://raw.githubusercontent.com/seguid/seguid-tests/main/tests/cli.bats

update-seguid-tests:
	rm -f Makefile.seguid-tests
	$(MAKE) Makefile.seguid-tests
	rm -f tests/cli.bats
	$(MAKE) tests/cli.bats
