cmake_minimum_required(VERSION 3.14...3.25)
project(edutrack LANGUAGES CXX)

# اسم الملف التنفيذي (التطبيق)
set(BINARY_NAME "edutrack")

# تفعيل سياسات CMake الحديثة لتجنب التحذيرات
cmake_policy(VERSION 3.14...3.25)

# تحديد نوع البناء (Debug, Profile, Release)
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release"
    CACHE STRING "" FORCE)
else()
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Flutter build mode" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Profile" "Release")
  endif()
endif()

# إعدادات خاصة بنمط Profile لتكون مماثلة للـ Release
set(CMAKE_EXE_LINKER_FLAGS_PROFILE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELEASE}")

# استخدام Unicode لجميع المشاريع
add_definitions(-DUNICODE -D_UNICODE)

# دالة لإضافة إعدادات التجميع الموحدة للمشاريع
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
  # /W4: أعلى مستوى تحذيرات في MSVC، /WX: تحويل تحذيرات إلى أخطاء
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd4100) # تحذير تجاهل المعامل غير المستخدم
  target_compile_options(${TARGET} PRIVATE /EHsc) # تمكين استثناءات C++ المترابطة
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()

# إضافة مجلد Flutter (عادة ملفات البناء المتعلقة بـ Flutter)
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

# إضافة مجلد التشغيل (Runner)
add_subdirectory("runner")

# تضمين قواعد بناء الإضافات (plugins)
include(flutter/generated_plugins.cmake)

# === تثبيت الملفات ===

# مجلد تثبيت الملفات (عادة نفس مكان الملف التنفيذي)
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")

# تعيين التثبيت الافتراضي لعملية البناء
set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "Installation Directory" FORCE)
endif()

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

# تثبيت الملف التنفيذي
install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}" COMPONENT Runtime)

# تثبيت بيانات ICU (تعريب النصوص)
install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

# تثبيت مكتبة Flutter الأساسية
install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)

# تثبيت مكتبات الإضافات في حال وجودها
if(PLUGIN_BUNDLED_LIBRARIES)
  install(FILES "${PLUGIN_BUNDLED_LIBRARIES}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)
endif()

# تثبيت الموارد الأصلية (native assets)
set(NATIVE_ASSETS_DIR "${PROJECT_BUILD_DIR}native_assets/windows/")
install(DIRECTORY "${NATIVE_ASSETS_DIR}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)

# إعادة نسخ مجلد الأصول flutter_assets عند كل تثبيت لتجنب الملفات القديمة
set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")
  " COMPONENT Runtime)
install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

# تثبيت مكتبة AOT فقط في نمط Profile و Release
install(FILES "${AOT_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" CONFIGURATIONS Profile;Release COMPONENT Runtime)
