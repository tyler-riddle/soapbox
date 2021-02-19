list(APPEND SOAPBOX_WEBSITE_PACKAGES libimage-magick-perl)

add_custom_target(
    soapbox-website-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_WEBSITE_PACKAGES}
)

add_dependencies(soapbox-install-packages soapbox-website-install-packages)

execute_process(
    OUTPUT_VARIABLE SOAPBOX_WEBSITE_MODULES
    OUTPUT_STRIP_TRAILING_WHITESPACE
    COMMAND sh -c "soapbox-build-dump-modules ${SOAPBOX_SRC_WEBSITE}/modules.txt"
)

add_custom_target(
    soapbox-website-install-modules

    ALL
    DEPENDS contrib-perl-bootstrap2 soapbox-core-install-modules
    COMMAND sh -c "${SOAPBOX_INSTALL_PERL_MODULE_COMMAND} ${SOAPBOX_WEBSITE_MODULES}"
)

ExternalProject_Add(
    soapbox-website

    DEPENDS contrib-perl soapbox-website-install-modules

    SOURCE_DIR ${SOAPBOX_SRC_WEBSITE}
    BUILD_IN_SOURCE ON

    STEP_TARGETS build
    CONFIGURE_COMMAND perl ./Build.PL
    BUILD_COMMAND ./Build
    TEST_COMMAND  ""
    INSTALL_COMMAND ""
)

add_custom_target(
    soapbox-website-test
    DEPENDS soapbox-website-build
    WORKING_DIRECTORY ${SOAPBOX_SRC_WEBSITE}
    COMMAND ./Build test
)

add_dependencies(soapbox-test soapbox-website-test)
