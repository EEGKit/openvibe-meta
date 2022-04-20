###############################################################################
# Software License Agreement (AGPL-3 License)
#
# Module to find GTest library
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

if(EXISTS ${LIST_DEPENDENCIES_PATH}/gtest)
    set(GTEST_ROOT ${LIST_DEPENDENCIES_PATH}/gtest)
endif()

find_package(GTest REQUIRED)
