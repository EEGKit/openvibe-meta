###############################################################################
# Software License Agreement (AGPL-3 License)
#
# Module to find TinyXML2 library and create a target to link against.
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

get_property(OV_PRINTED GLOBAL PROPERTY OV_TRIED_ThirdPartyTinyXML2)

if(EXISTS ${LIST_DEPENDENCIES_PATH}/tinyxml2)
ov_print(OV_PRINTED "Found TinyXML2 Path")
	# Create target to link against.
    set(TinyXML2_ROOT ${LIST_DEPENDENCIES_PATH}/tinyxml2)
    find_library(TinyXML2_LIBRARY NAMES tinyxml2 PATHS ${TinyXML2_ROOT} PATH_SUFFIXES lib)

	if(NOT TinyXML2_LIBRARY STREQUAL TinyXML2_LIBRARY-NOTFOUND)
		ov_print(OV_PRINTED "Found TinyXML2 library")
		add_library(tinyxml2 INTERFACE)
		target_include_directories(tinyxml2 INTERFACE ${TinyXML2_ROOT}/include)
		target_link_libraries(tinyxml2 INTERFACE ${TinyXML2_LIBRARY})
 	else()
		ov_print(OV_PRINTED "  FAILED to find TinyXML2 library")
	endif()
else()
    ov_print(OV_PRINTED "  FAILED to find TinyXML2 Path")
endif()

set_property(GLOBAL PROPERTY OV_TRIED_ThirdPartyTinyXML2 "Yes")
