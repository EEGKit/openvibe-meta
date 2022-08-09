###############################################################################
# Software License Agreement (AGPL-3 License)
#
# Module to add VRPN library as an external project.
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
set(LIB vrpn)
set(LIB_VERSION 07.31)

# #############################################################################
# List the dependencies of the project
# #############################################################################
list(APPEND ${LIB}_DEPENDENCIES "")

# #############################################################################
# CMake Arguments
# #############################################################################
set(${LIB}_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

set(${LIB}_CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${EP_DEPENDENCIES_DIR}/${LIB}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_CXX_FLAGS=${${LIB}_CXX_FLAGS}
        -DVRPN_BUILD_CLIENTS=OFF
        -DVRPN_BUILD_SERVERS=OFF
        -DCMAKE_POLICY_DEFAULT_CMP0053:STRING=OLD
)

# #############################################################################
# Prepare the project
# #############################################################################
if (NOT USE_SYSTEM_${LIB})

    # #############################################################################
    # Setup download
    # #############################################################################
    set(GIT_URL https://github.com/vrpn/vrpn.git)
    set(GIT_TAG v${LIB_VERSION})

    # #############################################################################
    # Add external-project
    # #############################################################################
    find_program(GIT_BIN NAMES git)
    set (patch_cmd ${GIT_BIN} apply --ignore-whitespace ${CMAKE_SOURCE_DIR}/patches/VRPNCMakeLists.patch)

    ExternalProject_Add(${LIB}
            PREFIX ${EP_DEPENDENCIES_WORK_DIR}/${LIB}
            GIT_REPOSITORY ${GIT_URL}
            GIT_TAG ${GIT_TAG}
            GIT_SUBMODULES ""
            BUILD_IN_SOURCE OFF
            CMAKE_GENERATOR ${CMAKE_GENERATOR}
            CMAKE_GENERATOR_PLATFORM ${CMAKE_GENERATOR_PLATFORM}
            CMAKE_ARGS ${${LIB}_CMAKE_ARGS}
            PATCH_COMMAND "${patch_cmd}"
            DEPENDS ${${LIB}_DEPENDENCIES}
    )

endif() #NOT USE_SYSTEM_LIB

unset(LIB)
unset(LIB_VERSION)