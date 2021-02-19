list(APPEND SOAPBOX_MEDIA_PACKAGES libimage-magick-perl)

add_custom_target(
    soapbox-media-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_CONTRIB_IKIWIKI_PACKAGES}
)

add_dependencies(soapbox-install-packages soapbox-media-install-packages)

execute_process(
    OUTPUT_VARIABLE SOAPBOX_MEDIA_MODULES
    OUTPUT_STRIP_TRAILING_WHITESPACE
    COMMAND sh -c "soapbox-build-dump-modules ${SOAPBOX_SRC_MEDIA}/modules.txt"
)

add_custom_target(
    soapbox-media-install-modules

    ALL
    DEPENDS contrib-perl-bootstrap2 soapbox-core-install-modules
    COMMAND sh -c "${SOAPBOX_INSTALL_PERL_MODULE_COMMAND} ${SOAPBOX_MEDIA_MODULES}"
)

ExternalProject_Add(
    soapbox-media

    DEPENDS contrib-perl contrib-imagemagick soapbox-media-install-modules soapbox-core

    SOURCE_DIR ${SOAPBOX_SRC_MEDIA}
    BUILD_IN_SOURCE ON

    STEP_TARGETS build
    CONFIGURE_COMMAND perl ./Build.PL
    BUILD_COMMAND ./Build
    TEST_COMMAND  ""
    INSTALL_COMMAND ""
)

add_custom_target(
    soapbox-media-test
    DEPENDS soapbox-media-build
    WORKING_DIRECTORY ${SOAPBOX_SRC_MEDIA}
    COMMAND ./Build test
)

add_dependencies(soapbox-test soapbox-media-test)
