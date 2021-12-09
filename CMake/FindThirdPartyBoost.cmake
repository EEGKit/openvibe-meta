# ---------------------------------
# Finds third party boost
# Adds library to target
# Adds include path
# ---------------------------------

get_property(OV_PRINTED GLOBAL PROPERTY OV_TRIED_ThirdPartyBoost)
if(EXISTS ${LIST_DEPENDENCIES_PATH}/boost)
    set(BOOST_ROOT ${LIST_DEPENDENCIES_PATH}/boost)
endif()

set(Boost_USE_STATIC_LIBS ON)
find_package(Boost 1.71.0 COMPONENTS chrono filesystem regex system thread)

set_property(GLOBAL PROPERTY OV_TRIED_ThirdPartyBoost "Yes")