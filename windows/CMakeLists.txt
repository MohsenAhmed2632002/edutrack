cmake_minimum_required(VERSION 3.14...3.25)
project(edutrack LANGUAGES CXX)

# =============================================
# Firebase Configuration
# =============================================
set(FIREBASE_CPP_SDK_DIR "C:/Users/sphinx_Mohsen/Downloads/firebase_cpp_sdk")
set(FIREBASE_LIBRARY_ARCHITECTURE "x64")

# Verify Firebase SDK exists
if(NOT EXISTS "${FIREBASE_CPP_SDK_DIR}")
    message(FATAL_ERROR "Firebase SDK not found at: ${FIREBASE_CPP_SDK_DIR}")
else()
    message(STATUS "Using Firebase SDK at: ${FIREBASE_CPP_SDK_DIR}")
endif()

# =============================================
# Application Configuration
# =============================================
set(BINARY_NAME "edutrack")

# Enable modern CMake behaviors
cmake_policy(VERSION 3.14...3.25)

# Build configuration setup
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
    set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release" CACHE STRING "" FORCE)
else()
    if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
        set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Flutter build mode" FORCE)
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Profile" "Release")
    endif()
endif()

# Profile mode settings
set(CMAKE_EXE_LINKER_FLAGS_PROFILE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELEASE}")

# Unicode support
add_definitions(-DUNICODE -D_UNICODE)

# Standard settings function
function(APPLY_STANDARD_SETTINGS TARGET)
    target_compile_features(${TARGET} PUBLIC cxx_std_17)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE /W4 /WX /wd"4100")
        target_compile_options(${TARGET} PRIVATE /EHsc)
        target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
        target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
    else()
        target_compile_options(${TARGET} PRIVATE -Wall -Werror)
    endif()
endfunction()

# =============================================
# Firebase Integration (الطريقة الصحيحة بدون تكرار)
# =============================================
if(NOT TARGET firebase_app)
    add_subdirectory(${FIREBASE_CPP_SDK_DIR} bin/ EXCLUDE_FROM_ALL)
    
    set(firebase_libs
        firebase_app
        firebase_auth
        firebase_firestore
    )
endif()

# =============================================
# Flutter Integration
# =============================================
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

# Application build
add_subdirectory("runner")

# Generated plugins
include(flutter/generated_plugins.cmake)

# =============================================
# Final Linking
# =============================================
target_link_libraries(${BINARY_NAME} PRIVATE
    flutter_wrapper_app
    ${firebase_libs}
    # Required system libraries
    advapi32.lib
    ws2_32.lib
    crypt32.lib
)

# =============================================
# Installation Settings
# =============================================
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")
set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}" COMPONENT Runtime)
install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)
install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)

if(PLUGIN_BUNDLED_LIBRARIES)
    install(FILES "${PLUGIN_BUNDLED_LIBRARIES}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)
endif()

set(NATIVE_ASSETS_DIR "${PROJECT_BUILD_DIR}native_assets/windows/")
install(DIRECTORY "${NATIVE_ASSETS_DIR}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)

set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
install(CODE "file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")" COMPONENT Runtime)
install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

install(FILES "${AOT_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" CONFIGURATIONS Profile;Release COMPONENT Runtime)

message(STATUS "Firebase integration completed successfully")