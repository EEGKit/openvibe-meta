###############################################################################
# Software License Agreement (AGPL-3 License)
#
# Module to add LUA library as an external project.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version 3,
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.
# If not, see <http://www.gnu.org/licenses/>.
###############################################################################
include(ExternalProject)

# #############################################################################
# Library details
# #############################################################################
set(LIB lua)
set(LIB_VERSION 5.1.4)

# #############################################################################
# List the dependencies of the project
# #############################################################################
list(APPEND ${LIB}_DEPENDENCIES "")

# #############################################################################
# CMake Arguments
# #############################################################################
set(${LIB}_CMAKE_ARGS
    -DINSTALL_DIR=${EP_DEPENDENCIES_DIR}
)

# #############################################################################
# Prepare the project
# #############################################################################
if (NOT USE_SYSTEM_${LIB})

    # #############################################################################
    # Setup download
    # #############################################################################
    set(${LIB}_URL https://www.lua.org/ftp/lua-${LIB_VERSION}.tar.gz)

    # #############################################################################
    # Setup platform
    # #############################################################################
    #if(UNIX)
    #    set(${LIB}_PLATFORM linux)
    #    set(${LIB}_PATCH_COMMAND patch -p0 < ${CMAKE_SOURCE_DIR}/patches/${LIB}.patch)
    #elseif(WIN32)
    #    set(${LIB}_PLATFORM generic)
    #endif()

    message(STATUS " *** CMAKE_GENERATOR: ${CMAKE_GENERATOR}")
    message(STATUS " *** CMAKE_EXTRA_GENERATOR: ${CMAKE_EXTRA_GENERATOR}")
    message(STATUS " *** CMAKE_GENERATOR_PLATFORM: ${CMAKE_GENERATOR_PLATFORM}")
    # #############################################################################
    # Add external-project
    # #############################################################################
    ExternalProject_Add(${LIB}
            PREFIX ${EP_DEPENDENCIES_WORK_DIR}/${LIB}
            URL ${${LIB}_URL}
            PATCH_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/patches/LuaCMakeLists.txt ${EP_DEPENDENCIES_WORK_DIR}/${LIB}/src/${LIB}/CMakeLists.txt
            BUILD_IN_SOURCE ON
            CMAKE_GENERATOR ${CMAKE_GENERATOR}
            CMAKE_GENERATOR_PLATFORM ${CMAKE_GENERATOR_PLATFORM}
            CMAKE_ARGS ${${LIB}_CMAKE_ARGS}
            DEPENDS ${${LIB}_DEPENDENCIES}
            )

endif() #NOT USE_SYSTEM_LIB

unset(LIB)
unset(LIB_VERSION)