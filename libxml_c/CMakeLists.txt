cmake_minimum_required(VERSION 3.5)
project(myxml2)


# check if compiler has c++11 support

include(CheckCXXCompilerFlag)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")


# source files

file(GLOB_RECURSE SRC "./*.c")


# check operating system

message(STATUS "We are working on ohos")
include_directories("./include")


# compile options


add_library(myxml2 SHARED ${SRC})

#only in Release type use strip
if(CMAKE_BUILD_TYPE)
    if(${CMAKE_BUILD_TYPE} STREQUAL "Release")
        add_custom_command(TARGET ${PROJECT_NAME}
                    POST_BUILD
                    COMMAND ${CMAKE_STRIP} -s "$<TARGET_FILE:${PROJECT_NAME}>"
                  )
    endif()
endif()