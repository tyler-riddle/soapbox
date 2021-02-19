list(
    APPEND SOAPBOX_CORE_PACKAGES
    supervisor
)

add_custom_target(
    soapbox-core-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_CORE_PACKAGES}
)

add_dependencies(soapbox-install-packages soapbox-core-install-packages)

execute_process(
    OUTPUT_VARIABLE SOAPBOX_CORE_PERL_MODULES
    OUTPUT_STRIP_TRAILING_WHITESPACE
    COMMAND sh -c "soapbox-build-dump-modules ${SOAPBOX_SRC_CORE}/modules.txt"
)

add_custom_target(
    soapbox-core-install-modules

    ALL
    DEPENDS contrib-perl-bootstrap2
    COMMAND sh -c "${SOAPBOX_INSTALL_PERL_MODULE_COMMAND} ${SOAPBOX_CORE_PERL_MODULES}"
)

add_dependencies(soapbox-install-modules soapbox-core-install-modules)

add_custom_target(
    soapbox-core-inject-modules

    DEPENDS contrib-perl-bootstrap3
    COMMAND sh -c "soapbox-dpan-inject ${SOAPBOX_CORE_PERL_MODULES}"
)

add_dependencies(soapbox-inject-modules soapbox-core-inject-modules)

ExternalProject_Add(
    soapbox-core DEPENDS contrib-perl soapbox-core-install-modules

    SOURCE_DIR ${SOAPBOX_SRC_CORE}
    BUILD_IN_SOURCE ON

    STEP_TARGETS build
    CONFIGURE_COMMAND perl ./Build.PL
    BUILD_COMMAND ./Build
    TEST_COMMAND  ""
    INSTALL_COMMAND ""
)

add_custom_target(
    soapbox-core-test
    DEPENDS soapbox-core-build
    WORKING_DIRECTORY ${SOAPBOX_SRC_CORE}
    COMMAND ./Build test
)

add_dependencies(soapbox-test soapbox-core-test)
