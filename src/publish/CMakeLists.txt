list(
    APPEND SOAPBOX_PUBLISH_PACKAGES
    supervisor
)

add_custom_target(
    soapbox-publish-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_PUBLISH_PACKAGES}
)

add_dependencies(soapbox-install-packages soapbox-publish-install-packages)

execute_process(
    OUTPUT_VARIABLE SOAPBOX_PUBLISH_PERL_MODULES
    OUTPUT_STRIP_TRAILING_WHITESPACE
    COMMAND sh -c "soapbox-build-dump-modules ${SOAPBOX_SRC_CORE}/modules.txt"
)

add_custom_target(
    soapbox-publish-install-modules

    ALL
    DEPENDS contrib-perl-bootstrap2
    COMMAND sh -c "${SOAPBOX_INSTALL_PERL_MODULE_COMMAND} ${SOAPBOX_PUBLISH_PERL_MODULES}"
)

add_dependencies(soapbox-install-modules soapbox-publish-install-modules)

ExternalProject_Add(
    soapbox-publish DEPENDS contrib-perl soapbox-core soapbox-publish-install-modules

    SOURCE_DIR ${SOAPBOX_SRC_PUBLISH}
    BUILD_IN_SOURCE ON

    STEP_TARGETS build
    CONFIGURE_COMMAND perl ./Build.PL
    BUILD_COMMAND ./Build
    TEST_COMMAND  ""
    INSTALL_COMMAND ""
)

add_custom_target(
    soapbox-publish-test
    DEPENDS soapbox-publish-build
    WORKING_DIRECTORY ${SOAPBOX_SRC_CORE}
    COMMAND ./Build test
)

add_dependencies(soapbox-test soapbox-publish-test)
