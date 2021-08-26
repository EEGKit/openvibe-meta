# ---------------------------------
# Finds third party boost
# Adds library to target
# Adds include path
# ---------------------------------

get_property(OV_PRINTED GLOBAL PROPERTY OV_TRIED_ThirdPartyBoost)

find_path(PATH_BOOST "include/boost/config/auto_link.hpp" PATHS ${LIST_DEPENDENCIES_PATH} PATH_SUFFIXES boost NO_DEFAULT_PATH)
find_path(PATH_BOOST "include/boost/config/auto_link.hpp" PATHS ${LIST_DEPENDENCIES_PATH} PATH_SUFFIXES boost)

IF(PATH_BOOST)
	OV_PRINT(OV_PRINTED "  Found boost includes...")
	include_directories(${PATH_BOOST}/include)

	add_definitions(-DTARGET_HAS_Boost)
else(PATH_BOOST)
	OV_PRINT(OV_PRINTED "  FAILED to find boost includes...")
endif(PATH_BOOST)

set_property(GLOBAL PROPERTY OV_TRIED_ThirdPartyBoost "Yes")

