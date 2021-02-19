set(SOAPBOX_SRC_CORE ${SOAPBOX_SRC}/core)
set(SOAPBOX_SRC_WEBSITE ${SOAPBOX_SRC}/website)
set(SOAPBOX_SRC_BROADCAST ${SOAPBOX_SRC}/broadcast)
set(SOAPBOX_SRC_MEDIA ${SOAPBOX_SRC}/media)
set(SOAPBOX_SRC_PUBLISH ${SOAPBOX_SRC}/publish)

create_targets(soapbox)

include(${SOAPBOX_SRC_CORE}/CMakeLists.txt)
include(${SOAPBOX_SRC_MEDIA}/CMakeLists.txt)
include(${SOAPBOX_SRC_WEBSITE}/CMakeLists.txt)
include(${SOAPBOX_SRC_BROADCAST}/CMakeLists.txt)
include(${SOAPBOX_SRC_PUBLISH}/CMakeLists.txt)
