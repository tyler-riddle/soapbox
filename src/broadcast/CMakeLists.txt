list(
    APPEND SOAPBOX_BROADCAST_PACKAGES
    nginx libnginx-mod-rtmp
)

add_custom_target(
    soapbox-broadcast-install-packages
    COMMAND ${SOAPBOX_CONTRIB_APT_INSTALL} ${SOAPBOX_BROADCAST_PACKAGES}
)

add_dependencies(soapbox-install-packages soapbox-broadcast-install-packages)

execute_process(
    OUTPUT_VARIABLE SOAPBOX_BROADCAST_MODULES
    OUTPUT_STRIP_TRAILING_WHITESPACE
    COMMAND sh -c "soapbox-build-dump-modules ${SOAPBOX_SRC_BROADCAST}/modules.txt"
)

add_custom_target(
    soapbox-broadcast-install-modules

    ALL
    DEPENDS contrib-perl-bootstrap2 soapbox-core-install-modules
    COMMAND sh -c "${SOAPBOX_INSTALL_PERL_MODULE_COMMAND} ${SOAPBOX_BROADCAST_MODULES}"
)

ExternalProject_Add(
    soapbox-broadcast

    DEPENDS soapbox-core soapbox-media
    DEPENDS contrib-perl contrib-obs-studio contrib-qjackctl

    SOURCE_DIR ${SOAPBOX_SRC_BROADCAST}
    BUILD_IN_SOURCE ON

    STEP_TARGETS build
    CONFIGURE_COMMAND perl ./Build.PL
    BUILD_COMMAND ./Build
    TEST_COMMAND  ""
    INSTALL_COMMAND ""
)

add_custom_target(
    soapbox-broadcast-test
    DEPENDS soapbox-broadcast-build
    WORKING_DIRECTORY ${SOAPBOX_SRC_BROADCAST}
    COMMAND ./Build test
)

add_dependencies(soapbox-test soapbox-broadcast-test)
