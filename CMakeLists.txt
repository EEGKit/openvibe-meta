cmake_minimum_required(VERSION 3.12)

cmake_policy(SET CMP0026 OLD)
cmake_policy(SET CMP0039 NEW)
cmake_policy(SET CMP0042 OLD)
cmake_policy(SET CMP0043 OLD)
cmake_policy(SET CMP0045 OLD)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0057 NEW)



set(OPENVIBE_MAJOR_VERSION 3)
set(OPENVIBE_MINOR_VERSION 0)
set(OPENVIBE_PATCH_VERSION 0)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(OpenVIBE VERSION ${OPENVIBE_MAJOR_VERSION}.${OPENVIBE_MINOR_VERSION}.${OPENVIBE_PATCH_VERSION})

set(CMAKE_MODULE_PATH_BASE "${CMAKE_SOURCE_DIR}/CMake")

set(BUILD_ARCH "x64")
if(${BUILD_ARCH} STREQUAL "x64")
  set(DEPENDENCIES_ARCH "_x64")
endif()

# Set CMake variables
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build Type (Debug, Release, RelWithDebInfo, MinSizeRel")
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/dist/${CMAKE_BUILD_TYPE}" CACHE PATH "Install directory" FORCE)

# Set OV variables
set(OV_CUSTOM_DEPENDENCIES_PATH "${CMAKE_SOURCE_DIR}/dependencies${DEPENDENCIES_ARCH}" CACHE PATH "Dependencies folder" )
set(OV_CONFIG_SUBDIR "openvibe-3.0.0")
set(OVT_TEST_DATA_DIR "${OV_CUSTOM_DEPENDENCIES_PATH}/test-input")


# Options
option(Flag_VerboseOutput "Verbose CMake output" OFF)
option(OV_DISPLAY_ERROR_LOCATION "display complete error locations" ON)
option(OV_PACKAGE "Create a package in build directory" OFF)
option(BUILD_VALIDATION_TEST "Build the validation tests" ON)
option(BUILD_UNIT_TEST "Build the unit tests" ON)

# Add some dependencies to PATH
#Could (SHOULD) be replaced with find_path / find_package functionnalities
set(ENV{PATH} "$ENV{PATH};${OV_CUSTOM_DEPENDENCIES_PATH}/expat/bin")
set(ENV{PATH} "$ENV{PATH};${OV_CUSTOM_DEPENDENCIES_PATH}/vcredist")
set(ENV{PATH} "$ENV{PATH};${OV_CUSTOM_DEPENDENCIES_PATH}/xerces-c/lib")
set(ENV{PATH} "$ENV{PATH};${OV_CUSTOM_DEPENDENCIES_PATH}/gtk/bin")

# Add SDK to build
add_subdirectory(sdk)

#OPENVIBE_SDK_PATH
set(LIST_DEPENDENCIES_PATH "${CMAKE_SOURCE_DIR}/dependencies${DEPENDENCIES_ARCH}" )
add_subdirectory(designer)

add_subdirectory(extras)