###############################################################################
# Software License Agreement (AGPL-3 License)
#
# Author: Thomas Prampart (Inria)
#
# Copyright (C) 2022 Inria
#
# Module to find BrainProducts Amplifier SDK
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

get_property(OV_PRINTED GLOBAL PROPERTY OV_TRIED_FindThirdPartyBrainProductsAmplifierSDK)

add_library(brainproducts-amplifier-sdk INTERFACE)

if(WIN32)

    if(EXISTS ${LIST_DEPENDENCIES_PATH}/sdk_brainproducts_amplifier)
        set(BRAINPRODUCTS_AMPLIFIER_SDK_DIR ${LIST_DEPENDENCIES_PATH}/sdk_brainproducts_amplifier)
    endif()

    find_library(BRAINPRODUCTS_AMPLIFIER_LIB AmplifierSDK PATHS ${BRAINPRODUCTS_AMPLIFIER_SDK_DIR} PATH_SUFFIXES lib)
    if(BRAINPRODUCTS_AMPLIFIER_LIB)
        ov_print(OV_PRINTED "  Found Brain Products Amplifier SDK API...")

        target_include_directories(brainproducts-amplifier-sdk INTERFACE ${BRAINPRODUCTS_AMPLIFIER_SDK_DIR}/include)
        target_link_libraries(brainproducts-amplifier-sdk INTERFACE ${BRAINPRODUCTS_AMPLIFIER_LIB})
        target_compile_options(brainproducts-amplifier-sdk
                               INTERFACE -DTARGET_HAS_ThirdPartyBrainProductsAmplifierSDK
        )

        # Copy the DLL file at install - Could it be attached to the target and installed with the depending target instead ?
        install(DIRECTORY ${BRAINPRODUCTS_AMPLIFIER_SDK_DIR}/bin/ DESTINATION ${DIST_BINDIR} FILES_MATCHING PATTERN "*.dll")
        install(DIRECTORY ${BRAINPRODUCTS_AMPLIFIER_SDK_DIR}/bin/ DESTINATION ${DIST_BINDIR} FILES_MATCHING PATTERN "*.bit")

    else(BRAINPRODUCTS_AMPLIFIER_LIB)
        ov_print(OV_PRINTED "  FAILED to find Brain Products Amplifier API (optional)")
    endif(BRAINPRODUCTS_AMPLIFIER_LIB)
endif(WIN32)

SET_PROPERTY(GLOBAL PROPERTY OV_TRIED_FindThirdPartyBrainProductsAmplifierSDK "Yes")
