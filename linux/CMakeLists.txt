cmake_minimum_required(VERSION 3.5)
project(edutrack LANGUAGES CXX)

# إعدادات أساسية
set(BINARY_NAME "edutrack")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# سياسات CMake
cmake_policy(VERSION 3.14...3.25)
cmake_policy(SET CMP0091 NEW) # لحل مشاكل MSVC Runtime

# إعدادات خاصة بـ Windows
if(WIN32)
    add_definitions(-DUNICODE -D_UNICODE -DWIN32_LEAN_AND_MEAN)
    add_compile_options(/Zc:__cplusplus /permissive- /W4 /WX)
    add_compile_options($<$<CONFIG:Debug>:/MTd> $<$<CONFIG:Release>:/MT>)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()

# تكوين أنماط البناء
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
    set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release" CACHE STRING "" FORCE)
else()
    if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
        set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Flutter build mode" FORCE)
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Profile" "Release")
    endif()
endif()

# إعدادات Profile لتكون مشابهة للـ Release
set(CMAKE_EXE_LINKER_FLAGS_PROFILE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELEASE}")

# تكوين Firebase
set(FIREBASE_CPP_SDK_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter/ephemeral/.plugin_symlinks/firebase_cpp_sdk")
if(EXISTS "${FIREBASE_CPP_SDK_DIR}")
    set(ENV{FIREBASE_CPP_SDK_DIR} "${FIREBASE_CPP_SDK_DIR}")
    add_subdirectory("${FIREBASE_CPP_SDK_DIR}" firebase_cpp_sdk)
endif()

# مكتبات النظام المطلوبة
find_package(Threads REQUIRED)

# دالة تطبيق الإعدادات القياسية
function(APPLY_STANDARD_SETTINGS TARGET)
    target_compile_features(${TARGET} PUBLIC cxx_std_17)
    if(MSVC)
        target_compile_options(${TARGET} PRIVATE 
            /W4
            /WX
            /wd4099  # تجاهل تحذيرات PDB المفقودة
            /wd4100  # تجاهل معامل غير مستخدم
            /EHsc    # تمكين استثناءات C++
        )
        target_compile_definitions(${TARGET} PRIVATE
            "_HAS_EXCEPTIONS=1"
            "$<$<CONFIG:Debug>:_DEBUG>"
        )
        target_link_libraries(${TARGET} PRIVATE
            firebase_app
            firebase_auth
            firebase_firestore
            Threads::Threads
            ws2_32.lib
            crypt32.lib
            advapi32.lib
            shell32.lib
            userenv.lib
        )
    endif()
endfunction()

# تضمين Flutter
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

# تضمين Runner
add_subdirectory("runner")

# تضمين الإضافات
include(flutter/generated_plugins.cmake)

# إعدادات التثبيت
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")
set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "Installation Directory" FORCE)
endif()

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

# تثبيت الملفات
install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}" COMPONENT Runtime)
install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)
install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)

if(PLUGIN_BUNDLED_LIBRARIES)
    install(FILES "${PLUGIN_BUNDLED_LIBRARIES}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)
endif()

# تثبيت الموارد الأصلية
set(NATIVE_ASSETS_DIR "${PROJECT_BUILD_DIR}native_assets/windows/")
install(DIRECTORY "${NATIVE_ASSETS_DIR}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)

# إعادة نسخ ملفات الأصول
set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
install(CODE "
    file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")
" COMPONENT Runtime)
install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}" 
    DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

# تثبيت مكتبة AOT
install(FILES "${AOT_LIBRARY}" 
    DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" 
    CONFIGURATIONS Profile;Release 
    COMPONENT Runtime)