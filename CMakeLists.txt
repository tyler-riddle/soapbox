project(soapbox)

cmake_minimum_required(VERSION 3.13)

if(NOT DEFINED ENV{SOAPBOX_ROOT})
    message(FATAL_ERROR "SOAPBOX_ROOT not set")
endif()

include(ExternalProject)

set(CMAKE_INSTALL_PREFIX $ENV{SOAPBOX_OPT})
set(ENV{SOAPBOX_VALIDATE_JOBS} ${SOAPBOX_VALIDATE_JOBS})

set(SOAPBOX_OPT $ENV{SOAPBOX_OPT})
set(SOAPBOX_SRC $ENV{SOAPBOX_SRC})
set(SOAPBOX_CONTRIB ${CMAKE_SOURCE_DIR}/contrib)

list(APPEND TARGET_NAMES install-packages inject-modules install-modules test test-deep)

foreach(TARGET_NAME IN LISTS TARGET_NAMES)
    add_custom_target(${TARGET_NAME})
endforeach()

function(create_targets TARGET_PREFIX)
    foreach(SUFFIX IN LISTS TARGET_NAMES)
        set(TARGET_NAME ${TARGET_PREFIX}-${SUFFIX})
        add_custom_target(${TARGET_NAME})
        add_dependencies(${SUFFIX} ${TARGET_NAME})
        endforeach()
endfunction()

include(${CMAKE_SOURCE_DIR}/contrib/CMakeLists.txt)
include(${CMAKE_SOURCE_DIR}/src/CMakeLists.txt)
