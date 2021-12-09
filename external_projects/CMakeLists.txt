###############################################################################
# Software License Agreement (AGPL-3 License)
#
# Module to include in order to get all needed dependencies for OpenViBE
# as CMake targets directly.
#
# Copyright (C) Inria 2021
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

cmake_minimum_required(VERSION 3.12)
project(Dependencies)

# #############################################################################
# Setup
# #############################################################################
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMake)
set(DEPENDENCIES_WORK_DIR ${CMAKE_SOURCE_DIR}/arch)

if (NOT DEPENDENCIES_DIR)
    message(FATAL_ERROR "DEPENDENCIES_DIR variable required")
endif()

include(Boost)