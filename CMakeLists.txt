cmake_minimum_required(VERSION 2.8)

project(BinaryDelta)

find_library(BZ2 bz2)
find_library(XAR xar)
find_library(CCRYPTO commonCrypto)
if (APPLE)
    find_library(FOUNDATION Foundation)
    include_directories(
        ${FOUNDATION})
    set(OBJC_LIBRARIES ${FOUNDATION})
else(APPLE)
    execute_process(COMMAND gnustep-config --objc-flags
        OUTPUT_VARIABLE OBJC_COMPILER_FLAGS_DIRTY
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(COMMAND gnustep-config --base-libs
        OUTPUT_VARIABLE OBJC_LINKER_FLAGS
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    #string(REPLACE "-fexec-charset=UTF-8" "" OBJC_COMPILER_FLAGS ${OBJC_COMPILER_FLAGS_DIRTY})
    set(CMAKE_C_FLAGS
        "${CMAKE_C_FLAGS} ${OBJC_COMPILER_FLAGS} -fobjc-nonfragile-abi -fobjc-arc -fconstant-string-class=NSConstantString")
    
    set(CMAKE_EXE_LINKER_FLAGS
        "${CMAKE_EXE_LINKER_FLAGS} ${OBJC_LINKER_FLAGS}")
    set(OBJC_LIBRARIES gnustep-base objc m)
    include_directories(/usr/local/include/GNUstep)
endif(APPLE)

set(BinaryDelta_SOURCE_FILES 
    Sparkle/SUBinaryDeltaApply.m
    Sparkle/SUBinaryDeltaCommon.m
    Sparkle/SUBinaryDeltaTool.m
    Vendor/bsdiff/bsdiff.c
    Vendor/bsdiff/bspatch.c
    Vendor/bsdiff/sais.c
)

set_source_files_properties(
    ${BinaryDelta_SOURCE_FILES} PROPERTIES LANGUAGE C)

set(BinaryDelta_HEADER_FILES 
    Sparkle/SUBinaryDeltaApply.h
    Sparkle/SUBinaryDeltaCommon.h
    Vendor/bsdiff/sais.h
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
    ${OBJC_LIBRARIES}    
    ${BZ2}
    ${XAR}
    ${CCRYPTO}
)
