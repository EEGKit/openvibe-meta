###############################################################################
# Software License Agreement (AGPL-3 License)
#
# Module to find VRPN library and create a target to link against.
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

get_property(OV_PRINTED GLOBAL PROPERTY OV_TRIED_ThirdPartyVRPN)

if(EXISTS ${LIST_DEPENDENCIES_PATH}/vrpn)
    set(VRPN_DIR ${LIST_DEPENDENCIES_PATH}/vrpn)
endif()

find_library(VRPN_LIBRARY NAMES vrpn PATHS ${VRPN_DIR} PATH_SUFFIXES lib)
find_library(QUAT_LIBRARY NAMES quat PATHS ${VRPN_DIR} PATH_SUFFIXES lib)

if(NOT VRPN_LIBRARY STREQUAL VRPN_LIBRARY-NOTFOUND
   AND NOT QUAT_LIBRARY STREQUAL QUAT_LIBRARY-NOTFOUND)

    ov_print(OV_PRINTED "Found VRPN library")

    # Create target to link against.
    add_library(vrpn INTERFACE)
    target_include_directories(vrpn INTERFACE ${VRPN_DIR}/include)
    target_link_libraries(vrpn INTERFACE ${VRPN_LIBRARY} ${QUAT_LIBRARY})

else()
    # Add empty target to avoid errors in CMakeLists linking against it
    add_library(vrpn INTERFACE)
    ov_print(OV_PRINTED "  FAILED to find VRPN")
endif()

set_property(GLOBAL PROPERTY OV_TRIED_ThirdPartyVRPN "Yes")