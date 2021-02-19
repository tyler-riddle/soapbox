# perl build bootstrap phases
# 1. cpm is available for installing packages
# 2. bootstrap modules

set(SOAPBOX_CPANM_COMMAND soapbox-contrib-bootstrap-cpanm --notest)
set(SOAPBOX_INSTALL_PERL_MODULE_COMMAND soapbox-perl-install-module)

set(SOAPBOX_PERL_BOOTSTRAP_PACKAGES build-essential curl libssl-dev zlib1g-dev gettext)
set(SOAPBOX_PERL_BOOTSTRAP2_MODULES App::cpm bareword::filehandles Cpanel::JSON::XS indirect IPC::System::Simple Module::Build JSON::MaybeXS multidimensional Ref::Util::XS Variable::Magic XString YAML)
set(SOAPBOX_PERL_BOOTSTRAP3_MODULES OrePAN2 CPAN::FindDependencies)

ExternalProject_Add(
    contrib-perl-interpreter
    STEP_TARGETS build test
    TEST_BEFORE_INSTALL ON
    TEST_EXCLUDE_FROM_MAIN ON

    DOWNLOAD_DIR "${SOAPBOX_DISTFILES}"
    URL https://www.cpan.org/src/5.0/perl-5.32.1.tar.gz
    URL_HASH SHA256=03b693901cd8ae807231b1787798cf1f2e0b8a56218d07b7da44f784a7caeb2c

    BUILD_IN_SOURCE ON
    CONFIGURE_COMMAND sh Configure -de -Dusethreads -Duseshrplib -Dprefix=${CMAKE_INSTALL_PREFIX} -Accflags=-I${CMAKE_INSTALL_PREFIX}/include -Aldflags=-L${CMAKE_INSTALL_PREFIX}/lib
    BUILD_COMMAND $(MAKE)
    TEST_COMMAND $(MAKE) test
    INSTALL_COMMAND $(MAKE) install
)

add_custom_target(
    contrib-perl-interpreter-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_PERL_BOOTSTRAP_PACKAGES}
)

add_dependencies(contrib-install-packages contrib-perl-interpreter-install-packages)

# the perl tests take forever and there isn't anything expected
# to go wrong with it
add_dependencies(contrib-test-deep contrib-perl-interpreter-test)

add_custom_target(
    contrib-perl-app-cpm

    DEPENDS contrib-perl-interpreter
    COMMAND ${SOAPBOX_CPANM_COMMAND} App::cpm
)

add_custom_target(
    contrib-perl-bootstrap1

    DEPENDS contrib-perl-app-cpm
)

add_custom_target(
    contrib-perl-install-bootstrap2-modules

    DEPENDS contrib-perl-interpreter contrib-perl-bootstrap1
    COMMAND ${SOAPBOX_INSTALL_PERL_MODULE_COMMAND} ${SOAPBOX_PERL_BOOTSTRAP2_MODULES}
)

add_custom_target(
    contrib-perl-bootstrap2

    DEPENDS contrib-perl-bootstrap1 contrib-perl-install-bootstrap2-modules
)

add_custom_target(
    contrib-perl-install-modules

    DEPENDS contrib-perl-bootstrap2
)

add_custom_target(
    contrib-perl-bootstrap

    DEPENDS contrib-perl-bootstrap2 contrib-perl-install-modules
)

add_custom_target(
    contrib-perl

    ALL
    DEPENDS contrib-perl-interpreter contrib-perl-bootstrap
)
