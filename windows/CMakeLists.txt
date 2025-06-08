cmake_minimum_required(VERSION 3.14)
project(edutrack LANGUAGES CXX)
set(CMAKE_GENERATOR_TOOLSET "v143" CACHE STRING "Visual Studio 2022 Toolset" FORCE)
# =============================================
# Manual Firebase SDK Path Fix
# =============================================
set(FIREBASE_CPP_SDK_DIR "C:/Users/sphinx_Mohsen/StudioProjects/edutrack/build/windows/x64/extracted/firebase_cpp_sdk_windows")
# Verify SDK exists
if(NOT EXISTS "${FIREBASE_CPP_SDK_DIR}")
  message(FATAL_ERROR "Firebase SDK not found at: ${FIREBASE_CPP_SDK_DIR}.")
else()
  message(STATUS "Using Firebase SDK at: ${FIREBASE_CPP_SDK_DIR}")
endif()

# Set Firebase variables
set(FIREBASE_INCLUDE_DIR "${FIREBASE_CPP_SDK_DIR}/include")
set(FIREBASE_LIBRARY_DIR "${FIREBASE_CPP_SDK_DIR}/libs/x64")
include_directories(${FIREBASE_INCLUDE_DIR})
link_directories(${FIREBASE_LIBRARY_DIR})
# تحديد Platform Toolset
set(CMAKE_GENERATOR_TOOLSET "v143" CACHE STRING "Platform Toolset" FORCE)

# تحديد Runtime Library
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

# إضافة مسارات مكتبات Firebase
set(FIREBASE_CPP_SDK_DIR "C:/Users/sphinx_Mohsen/StudioProjects/edutrack/build/windows/x64/extracted/firebase_cpp_sdk")
set(FIREBASE_LIBRARY_ARCHITECTURE "x64")

# =============================================
# Firebase Fixes - Add these at the very top
# =============================================
if(MSVC)
  # Standard and compatibility settings
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  
  # Important compiler flags for Firebase compatibility
  add_compile_options(/Zc:__cplusplus)
  add_compile_options(/Zc:twoPhase-)
  add_compile_options(/Zc:inline-)
  add_compile_options(/Zc:throwingNew-)
  
  # Disable warnings that might cause issues
  add_compile_options(/D_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING)
  add_compile_options(/D_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS)
  
  # Use dynamic runtime (important for Firebase compatibility)
  set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
  
  # Apply runtime settings to all configurations
  foreach(config DEBUG RELEASE RELWITHDEBINFO MINSIZEREL)
    string(TOUPPER ${config} CONFIG_UPPER)
    set(CMAKE_CXX_FLAGS_${CONFIG_UPPER} "${CMAKE_CXX_FLAGS_${CONFIG_UPPER}} /${CMAKE_MSVC_RUNTIME_LIBRARY}")
  endforeach()
  
  # Debug information format
  add_compile_options(/Z7)
endif()

# =============================================
# Original Flutter Configuration
# =============================================
set(BINARY_NAME "edutrack")

cmake_policy(VERSION 3.14...3.25)

# Build configuration
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
set(CMAKE_GENERATOR_TOOLSET "v142")

# Unicode support
add_definitions(-DUNICODE -D_UNICODE)

# Standard settings function
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd"4100")
  target_compile_options(${TARGET} PRIVATE /EHsc)
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()

# =============================================
# Additional Firebase Linker Fixes
# =============================================
if(MSVC)
  # Fix for unresolved symbols
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:libcmt.lib")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:libcmtd.lib")
  
  # Explicitly link required libraries
  link_libraries(advapi32.lib)
  link_libraries(ws2_32.lib)
  link_libraries(crypt32.lib)
  link_libraries(secur32.lib)
  link_libraries(ole32.lib)
  link_libraries(oleaut32.lib)
  link_libraries(bcrypt.lib)
  link_libraries(legacy_stdio_definitions.lib)
  link_libraries(oldnames.lib)
endif()

# =============================================
# Flutter and Project Setup
# =============================================
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

add_subdirectory("runner")

include(flutter/generated_plugins.cmake)

# =============================================
# Firebase Runtime Library Enforcement
# =============================================
if(MSVC)
  # Apply consistent runtime settings to all targets
  function(apply_runtime_settings target)
    set_target_properties(${target} PROPERTIES
      MSVC_RUNTIME_LIBRARY "${CMAKE_MSVC_RUNTIME_LIBRARY}"
    )
  endfunction()
  
  # Apply to main executable
  apply_runtime_settings(${BINARY_NAME})
  
  # Apply to all plugins
  get_property(plugin_targets DIRECTORY PROPERTY BUILDSYSTEM_TARGETS)
  foreach(target IN LISTS plugin_targets)
    apply_runtime_settings(${target})
  endforeach()
endif()

# =============================================
# Manual Firebase Targets Creation
# =============================================
if(NOT TARGET firebase_app)
  message(STATUS "Creating manual Firebase targets")
  
  add_library(firebase_app STATIC IMPORTED)
  set_target_properties(firebase_app PROPERTIES
    IMPORTED_LOCATION "${FIREBASE_LIBRARY_DIR}/firebase_app.lib"
    INTERFACE_INCLUDE_DIRECTORIES "${FIREBASE_INCLUDE_DIR}"
  )
  
  add_library(firebase_auth STATIC IMPORTED)
  set_target_properties(firebase_auth PROPERTIES
    IMPORTED_LOCATION "${FIREBASE_LIBRARY_DIR}/firebase_auth.lib"
    INTERFACE_INCLUDE_DIRECTORIES "${FIREBASE_INCLUDE_DIR}"
  )
  
  add_library(firebase_firestore STATIC IMPORTED)
  set_target_properties(firebase_firestore PROPERTIES
    IMPORTED_LOCATION "${FIREBASE_LIBRARY_DIR}/firebase_firestore.lib"
    INTERFACE_INCLUDE_DIRECTORIES "${FIREBASE_INCLUDE_DIR}"
  )
  
  add_library(firebase_storage STATIC IMPORTED)
  set_target_properties(firebase_storage PROPERTIES
    IMPORTED_LOCATION "${FIREBASE_LIBRARY_DIR}/firebase_storage.lib"
    INTERFACE_INCLUDE_DIRECTORIES "${FIREBASE_INCLUDE_DIR}"
  )
  
  # Link Firebase libraries to the main executable
  target_link_libraries(${BINARY_NAME} PRIVATE 
    firebase_app 
    firebase_auth 
    firebase_firestore 
    firebase_storage
  )
endif()

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