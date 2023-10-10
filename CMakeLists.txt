include(Cmake/mingw-toolchain.cmake)
cmake_minimum_required(VERSION 3.22)

project(CProjectSkeleton 
        VERSION 1.0
        DESCRIPTION "template for C"
        HOMEPAGE_URL "https:/github/bla-bla"
        LANGUAGES C)


set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Options
# If you wana run options do not change it here, but as example  
# cmake -DENABLE_WARNINGS=ON -DENABLE_WARNINGS_AS_ERROS=ON ..
option(ENABLE_WARNINGS "Enable to add warnings to a target." ON)
option(ENABLE_WARNINGS_AS_ERRORS "Enable to treat warnings as errors." OFF)
option(CREATE_DOXYGEN_DOC "Enable to run Doxygen script" OFF)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/Cmake/)
include(ConfigGuard)
include(FetchCMocka)
include(mingw-toolchain)

if(ENABLE_WARNINGS)
    include(Warnings)
endif()

if(CREATE_DOXYGEN_DOC)
    include(Doc)
endif()

# App
# add_subdirectory(App)

# Utils
# add_subdirectory(Source/App/Utils)

# Scrible
add_subdirectory(Scrible)


# Create main executable 
add_executable(${PROJECT_NAME}
  App/main.c
)

# Link FreeRTOS as a static library
target_link_libraries(${PROJECT_NAME} 
                        )

target_include_directories(${PROJECT_NAME} PUBLIC
  App
  )

message(" ENABLE_WARNINGS before compile: ${ENABLE_WARNINGS} for ${PROJECT_NAME}")
if (ENABLE_WARNINGS)
    target_set_warnings(
        TARGET
        ${PROJECT_NAME} 
        ENABLE
        ${ENABLE_WARNINGS}
        AS_ERRORS
        ${ENABLE_WARNINGS_AS_ERRORS})
endif()


# UNIT TEST
add_subdirectory(Test)

# -----------------------------------
# DEVELOPER UTILS
# -----------------------------------
# set(CTAGS ON)
# include(ctags)
