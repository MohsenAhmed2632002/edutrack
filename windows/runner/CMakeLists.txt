cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Force MSVC to use the dynamic CRT (/MDd for Debug, /MD for Release)
if (MSVC)
  # For Debug configuration
  set(CMAKE_C_FLAGS_DEBUG   "${CMAKE_C_FLAGS_DEBUG}   /MDd")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MDd")
  # For Release configuration
  set(CMAKE_C_FLAGS_RELEASE   "${CMAKE_C_FLAGS_RELEASE}   /MD")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MD")
  
  # Ensure CMake generator uses v142 toolset
  set(CMAKE_GENERATOR_TOOLSET "v143" CACHE STRING "" FORCE)
endif()

# Define the executable
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Apply your standard settings (warnings, C++17, etc.)
apply_standard_settings(${BINARY_NAME})

# Version definitions
target_compile_definitions(${BINARY_NAME} PRIVATE
  "FLUTTER_VERSION=\"${FLUTTER_VERSION}\""
  "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}"
  "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}"
  "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}"
  "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}"
)

# Disable conflicting Windows macros
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Link to Flutter libraries
target_link_libraries(${BINARY_NAME} PRIVATE
  flutter
  flutter_wrapper_app
  dwmapi.lib
)

# Include current source dir (for Runner.rc)
target_include_directories(${BINARY_NAME} PRIVATE
  "${CMAKE_SOURCE_DIR}"
)

# Build the Flutter assets
add_dependencies(${BINARY_NAME} flutter_assemble)
