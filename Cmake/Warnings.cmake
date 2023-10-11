# function(target_set_warnings)
#   set(oneValueArgs TARGET ENABLE AS_ERRORS)
#   cmake_parse_arguments(
#         TARGET_SET_WARNINGS
#         "${options}"
#         "${oneValueArgs}"
#         "${multiValueArgs}"
#         ${ARGN})
#
#   if(NOT ${TARGET_SET_WARNINGS_ENABLE})
#       message(STATUS "Warnings Disabled for: ${TARGET_SET_WARNINGS_TARGET}")
#       return()
#   endif()
#
#         # NOTE: add for MSVC
#
#   # extented for gcc
#   set(CLANG_WARNINGS
#       # Baseline
#       -Wall
#       -Wextra # reasonable and standard
#       -Wshadow # if a variable declaration shadows one from a parent context
#       -Wpedantic # warn if non-standard is used
#       # C and C++ Warnings
#       -Wunused # warn on anything being unused
#       -Wformat=2 # warn on security issues around functions that format output
#       -Wcast-align # warn for potential performance problem casts
#       -Wconversion # warn on type conversions that may lose data
#       -Wsign-conversion # warn on sign conversions
#       -Wnull-dereference # warn if a null dereference is detected
#       -Wdouble-promotion # warn if float is implicit promoted to double
#   )
#
#   set(GCC_WARNINGS
#       ${CLANG_WARNINGS}
#       -Wduplicated-cond # warn if if / else chain has duplicated conditions
#       # -Wduplicated-branches # warn if if / else branches have duplicated code
#       -Wlogical-op # warn about logical operations being used where bitwise were probably wanted
#   )
#
#   if(${TARGET_SET_WARNINGS_AS_ERRORS})
#     set(GCC_WARNINGS ${GCC_WARNINGS} -Werror)
#   endif()
#
#   target_compile_options(${TARGET_SET_WARNINGS_TARGET} PUBLIC ${GCC_WARNINGS})
#
# endfunction(target_set_warnings)
#
#
#
#










message("messages as errors:::::: ${ENABLE_WARNINGS_AS_ERRORS}")
message("messages as errors:::::: ${ENABLE_WARNINGS}")

if(${ENABLE_WARNINGS_AS_ERRORS})
  message("ERROREEEEEEEEDEDADASDASDASDSA")
  set(WARNING_AS_ERROR ${GCC_WARNINGS} -Werror)
endif()

if(CMAKE_C_COMPILER_ID MATCHES GNU)
               set(GNU_FLAGS
               -Wall
               # Check the code for syntax errors, but don’t do anything beyond that.
               -fsyntax-only
               # This enables some extra warning flags that are not enabled by -Wall.
               -Wextra
               # If TARGET_SET_WARNINGS_AS_ERRORS enabled, warnings become errors
               ${WARNING_AS_ERROR}
               )
   # message("GNU FLAGS", ${GNU_FLAGS})
   list(APPEND C_FLAGS ${GNU_FLAGS})
   list(APPEND C_FLAGS_DEBUG "-Wsuggest-final-types" 
                             "-Wsuggest-final-methods" 
                              "-fno-builtin"
                              "-fno-builtin-function"
                              "-fcond-mismatch"
                             )
   list(APPEND C_FLAGS_RELEASE "-O3" "-Wno-unused")
endif()

if(CMAKE_C_COMPILER_ID MATCHES Clang)
     set(CLANG_FLAGS
      # Baseline
      -Wall
      -Wextra # reasonable and standard
      -Wshadow # if a variable declaration shadows one from a parent context
      -Wpedantic # warn if non-standard is used
      # C and C++ Warnings
      -Wunused # warn on anything being unused
      -Wformat=2 # warn on security issues around functions that format output
      -Wcast-align # warn for potential performance problem casts
      -Wconversion # warn on type conversions that may lose data
      -Wsign-conversion # warn on sign conversions
      -Wnull-dereference # warn if a null dereference is detected
       # If TARGET_SET_WARNINGS_AS_ERRORS enabled, warnings become errors
       ${WARNING_AS_ERROR}
      )
 
  list(APPEND C_FLAGS ${CLANG_FLAGS})
  list(APPEND C_FLAGS_DEBUG "-Wdocumentation")
  list(APPEND C_FLAGS_RELEASE "-O3" "-Wno-unused")
endif()

add_library(compiler_flags INTERFACE )
target_compile_features(compiler_flags INTERFACE c_std_99)

target_compile_options(compiler_flags INTERFACE ${C_FLAGS}
     "$<$<CONFIG:Debug>:${C_FLAGS_DEBUG}>"
     "$<$<CONFIG:Release>:${C_FLAGS_RELEASE}>")
