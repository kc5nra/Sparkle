cmake_minimum_required(VERSION 2.8)

project(BinaryDelta)

set(CMAKE_C_FLAGS "-x objective-c")

find_library(COCOA Cocoa)
find_library(FOUNDATION Foundation)
find_library(BZ2 bz2)
find_library(XAR xar)

include_directories(
    ${COCOA}
    ${FOUNDATION})

set(BinaryDelta_SOURCE_FILES 
    Sparkle/SUBinaryDeltaApply.m
    Sparkle/SUBinaryDeltaCommon.m
    Sparkle/SUBinaryDeltaTool.m
    Vendor/bsdiff/bsdiff.c
    Vendor/bsdiff/bspatch.c
    Vendor/CocoatechCore/NTSynchronousTask.m
)

set(BinaryDelta_HEADER_FILES 
    Sparkle/SUBinaryDeltaApply.h
    Sparkle/SUBinaryDeltaCommon.h
)

include_directories(
    Vendor/bsdiff
    Vendor/CocoatechCore)

add_executable(
    BinaryDelta
    ${BinaryDelta_HEADER_FILES}
    ${BinaryDelta_SOURCE_FILES}
)

target_link_libraries(BinaryDelta
    ${COCOA}
    ${FOUNDATION}
    ${BZ2}
    ${XAR}
)