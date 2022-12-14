cmake_minimum_required (VERSION 2.8 FATAL_ERROR)

project(TrustedQSL)

find_package(OpenSSL REQUIRED)

if ( CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64" )
  if ( CMAKE_VERSION VERSION_LESS 2.8.12 )
    SET ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC" )
  else()
    ADD_COMPILE_OPTIONS("-fPIC")
  endif ( CMAKE_VERSION VERSION_LESS 2.8.12 )
endif( CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64" )

SET (LINUX FALSE)
IF (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    SET(LINUX TRUE)
ENDIF ()

# These attempts to play with LIB_SUFFIX aren't portable.
# Comment this out, and let GNUInstallDirs do this.
# Uncomment if you're sure it's needed.
#SET (LIB_SUFFIX "")
#
# Pre-set LIB_SUFFIX for 64-bit Linux platforms
#IF (LINUX AND CMAKE_SHARED_LIBRARY_PREFIX STREQUAL "lib64")
#  SET (LIB_SUFFIX "64")
#ENDIF()
#
# Make sure that there's a value for LIB_SUFFIX
#IF (LINUX AND NOT CMAKE_SHARED_LIBRARY_PREFIX AND NOT LIB_SUFFIX) 
#  # check 64 bit
#    IF (CMAKE_SIZEOF_VOID_P EQUAL 4)
#      SET (LIB_SUFFIX "")
#    ELSE (CMAKE_SIZEOF_VOID_P EQUAL 4)
#      SET (LIB_SUFFIX "64")
#    ENDIF (CMAKE_SIZEOF_VOID_P EQUAL 4)
#ENDIF (LINUX AND NOT CMAKE_SHARED_LIBRARY_PREFIX AND NOT LIB_SUFFIX) 

if(LINUX)
	include(GNUInstallDirs)
	if(NOT DEFINED CMAKE_INSTALL_LIBDIR)
		if(CMAKE_SIZEOF_VOID_P EQUAL 4)
			set(CMAKE_INSTALL_LIBDIR lib)
		else()
			set(CMAKE_INSTALL_LIBDIR lib64)
		endif()
	endif()
	if(NOT DEFINED CMAKE_INSTALL_DATADIR)
		set(CMAKE_INSTALL_DATADIR share)
	endif()
	if(NOT DEFINED CMAKE_INSTALL_INCLUDEDIR)
		set(CMAKE_INSTLL_INCLUDEDIR include)
	endif()
	if(NOT DEFINED CMAKE_INSTALL_BINDIR)
		set(CMAKE_INSTALL_BINDIR bin)
	endif()
elseif (NOT APPLE)
	set(CMAKE_INSTALL_LIBDIR lib)
	set(CMAKE_INSTALL_DATADIR share)
	set(CMAKE_INSTALL_INCLUDEDIR include)
	set(CMAKE_INSTALL_BINDIR bin)
endif(LINUX)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmakemodules/")
find_package(OptionalAddSubdirectory REQUIRED)

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall")

# Prefer LMDB, fall back to BDB if that's not available
find_package(LMDB)
if(NOT LMDB_FOUND)
	set (LMDB_LIBRARIES "")
	find_package(BDB REQUIRED)
	set (LMDB_INCLUDE_DIR "")
else()
	add_definitions(-DUSE_LMDB)
	set (BDB_INCLUDE_DIR "")
endif()

if(NOT APPLE)
	add_definitions("-DCONFDIR=\"${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATADIR}/TrustedQSL/\"")
endif()

# 
set(TQSL_VERSION_MAJOR 2)
set(TQSL_VERSION_MINOR 5)
set(TQSL_VERSION_UPDATE 0)

IF(TQSL_VERSION_UPDATE AND NOT TQSL_VERSION_UPDATE EQUAL 0) 
	set(TQSLVERSION "${TQSL_VERSION_MAJOR}.${TQSL_VERSION_MINOR}.${TQSL_VERSION_UPDATE}")
else()
	set(TQSLVERSION "${TQSL_VERSION_MAJOR}.${TQSL_VERSION_MINOR}")
endif()
#
# Use conservative options when failed to run
set(OPTIMIZATION_FLAGS "-O2")
##
# For Sanitizers
# with Thread Sanitizer
#set(OPTIMIZATION_FLAGS "-fsanitize=thread -g -O2")
# with Address Sanitizer
#set(OPTIMIZATION_FLAGS "-fsanitize=address -g -O2")
# For valgrind check
#set(OPTIMIZATION_FLAGS "-g")
#
set(CMAKE_CXX_FLAGS "-Wall -fstack-protector-strong ${OPTIMIZATION_FLAGS}")
#
add_subdirectory(src) # build tqsllib ONLY
