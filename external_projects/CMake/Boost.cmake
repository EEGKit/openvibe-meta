###############################################################################
# Software License Agreement (AGPL-3 License)
#
# Module to add boost as an external project.
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
set(LIB boost)
set(LIB_VERSION 1.71.0)

# #############################################################################
# List the dependencies of the project
# #############################################################################

list(APPEND ${LIB}_DEPENDENCIES "")

# #############################################################################
# Prepare the project
# #############################################################################

if (NOT USE_SYSTEM_${LIB})

    # Setup download
    set(GIT_URL https://github.com/boostorg/boost.git)
    set(GIT_TAG boost-${LIB_VERSION})

    # Modules to build
    set(WITH_MODULES
            --with-chrono
            --with-date_time
            --with-filesystem
            --with-regex
            --with-system
            --with-thread
    )

    # Setup build
    if(UNIX)
        set(CONFIG_CMD ./bootstrap.sh)
        set(BUILD_CMD ./b2)
        set(${LIB}_CXXFLAGS "-fPIC")
    else()
        if(WIN32)
            set(CONFIG_COMMAND bootstrap.bat)
            set(BUILD_CMD b2.exe)
        endif()
    endif()

    # Setup link option (options are "static", "shared" or "static,shared")
    set(${LIB}_LINK "static")

    ## #############################################################################
    ## Add external-project
    ## #############################################################################

    ExternalProject_Add(${LIB}
            PREFIX ${DEPENDENCIES_WORK_DIR}/${LIB}
            GIT_REPOSITORY ${GIT_URL}
            GIT_TAG ${GIT_TAG}
            BUILD_IN_SOURCE ON
            CONFIGURE_COMMAND ${CONFIG_CMD} --prefix=${DEPENDENCIES_DIR}/${LIB}
            BUILD_COMMAND ${BUILD_CMD} install link=${${LIB}_LINK} cxxflags=${${LIB}_CXXFLAGS} ${WITH_MODULES}
            INSTALL_COMMAND ""
            DEPENDS ${${LIB}_DEPENDENCIES}
    )

endif() #NOT USE_SYSTEM_LIB

unset(LIB)
unset(LIB_VERSION)