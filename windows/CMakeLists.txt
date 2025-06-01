cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES C CXX)

set(BINARY_NAME "edutrack")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# حدد موقع flutter
set(FLUTTER_ROOT "$ENV{FLUTTER_ROOT}")
if(NOT FLUTTER_ROOT)
  message(FATAL_ERROR "FLUTTER_ROOT is not set. Run `flutter doctor` and set the environment variable.")
endif()

set(FLUTTER_WINDOWS_DIR "${FLUTTER_ROOT}/packages/flutter_tools/bin/windows")
include("${FLUTTER_WINDOWS_DIR}/flutter_config.cmake")
include("${FLUTTER_WINDOWS_DIR}/flutter.cmake")

flutter_add_flutter_library(${BINARY_NAME})

add_executable(${BINARY_NAME}
  "runner/main.cpp"
  "runner/resource.h"
  "runner/runner.cpp"
  "runner/runner.rc"
  "runner/utils.cpp"
)

target_link_libraries(${BINARY_NAME}
  PRIVATE
  flutter
  "advapi32.lib"
  "ws2_32.lib"
  "shell32.lib"
)

flutter_finalize(${BINARY_NAME})
