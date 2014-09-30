# - This module looks for CERTI installation
# CERTI is an Open Source HLA RunTime Infrastructure
# See https://savannah.nongnu.org/projects/certi or http://www.cert.fr/CERTI/
# You may help this script to find the appropriate
# CERTI installation by setting CERTI_HOME
# before calling FIND_PACKAGE(CERTI REQUIRED)
# If CERTI_HOME is not set then 
#
# Once done this will define:
#
#  CERTI_INCLUDE_DIRS        - the directory(ies) where CERTI includes file are found
#  CERTI_LIBRARIES               - The libraries to link against to use CERTI
#  CERTI_DEFINITIONS           - -DRTI_USES_STD_FSTREAM
#  CERTI_RTIG_EXECUTABLE - the RTIG program 
#  CERTI_RTIA_EXECUTABLE - the RTIA program 
#  CERTI_LIBRARY_DIRS        - the directory(ies) where CERTI libraries reside
#  CERTI_ROOT_DIR              - the CERTI install prefix 
#  CERTI_FOUND                    - true if all necessary components are found
#  CERTI_RUNTIME_LIBRARY_DIRS - the CERTI runtime libraries search path
#  CERTI_BINARY_DIRS                    - the directory(ies) where the rtig, rtia programs resides
# ************   End of FindCERTI.cmake ******************

MACRO(MESSAGE_QUIETLY QUIET TYPE MSG)
   IF(NOT ${QUIET})
       MESSAGE(${TYPE} "${MSG}")
   ENDIF(NOT ${QUIET})
ENDMACRO(MESSAGE_QUIETLY QUIET TYPE MSG)

MESSAGE("FindCERTI is deprecated you should use FindRTI instead.")
MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for CERTI library and programs...")

IF ("$ENV{CERTI_HOME}" STRGREATER "")
  FILE(TO_CMAKE_PATH "$ENV{CERTI_HOME}" CERTI_HOME)
  MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Using environment defined CERTI_HOME : ${CERTI_HOME}")
ENDIF ("$ENV{CERTI_HOME}" STRGREATER "")

IF (NOT CERTI_HOME)
  SET(CERTI_HOME "/usr")
ENDIF (NOT CERTI_HOME)

SET(CERTI_ROOT_DIR ${CERTI_HOME})

SET(PATH_DIRS "${CERTI_ROOT_DIR};/usr/local")
SET(PATH_LIBS "${CERTI_ROOT_DIR};/usr/local")
SET(PATH_INCLUDE "${CERTI_ROOT_DIR};/usr/local")

SET(CERTI_DEFINITIONS "-DRTI_USES_STD_FSTREAM")

FIND_PROGRAM(CERTI_RTIG_EXECUTABLE 
  NAMES rtig 
  PATHS ${PATH_DIRS} 
  PATH_SUFFIXES bin
  DOC "The RTI Gateway")
IF (CERTI_RTIG_EXECUTABLE)
  IF (NOT CERTI_FIND_QUIETLY) 
      MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for CERTI... - found rtig is ${CERTI_RTIG_EXECUTABLE}")
  ENDIF(NOT CERTI_FIND_QUIETLY) 
  SET(CERTI_RTIG_FOUND "YES")
  GET_FILENAME_COMPONENT(CERTI_BINARY_DIRS ${CERTI_RTIG_EXECUTABLE} PATH)
ELSE (CERTI_RTIG_EXECUTABLE) 
  SET(CERTI_RTIG_FOUND "NO")
  IF (NOT CERTI_FIND_QUIETLY) 
      MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for CERTI... - rtig NOT FOUND")
  ENDIF(NOT CERTI_FIND_QUIETLY)
ENDIF (CERTI_RTIG_EXECUTABLE) 

FIND_PROGRAM(CERTI_RTIA_EXECUTABLE 
  NAMES rtia
  PATHS ${PATH_DIRS} 
  PATH_SUFFIXES bin
  DOC "The RTI Ambassador")
IF (CERTI_RTIA_EXECUTABLE)
   IF (NOT CERTI_FIND_QUIETLY)
     MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for CERTI... - found rtia is ${CERTI_RTIA_EXECUTABLE}")
  ENDIF(NOT CERTI_FIND_QUIETLY)
  SET(CERTI_RTIA_FOUND "YES")
  GET_FILENAME_COMPONENT(CERTI_BINARY_DIRS ${CERTI_RTIA_EXECUTABLE} PATH)
ELSE (CERTI_RTIA_EXECUTABLE) 
  SET(CERTI_RTIA_FOUND "NO")
  IF (NOT CERTI_FIND_QUIETLY)
     MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for CERTI... - rtia NOT FOUND")
  ENDIF(NOT CERTI_FIND_QUIETLY)
ENDIF (CERTI_RTIA_EXECUTABLE) 

FIND_LIBRARY(CERTI_CERTI_LIBRARY
  NAMES CERTI
  PATHS ${PATH_LIBS}	
  PATH_SUFFIXES lib
  DOC "The CERTI Library")

IF (CERTI_CERTI_LIBRARY) 
  IF (NOT CERTI_FIND_QUIETLY)
     MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for CERTI library... - found ${CERTI_CERTI_LIBRARY}")
  ENDIF(NOT CERTI_FIND_QUIETLY)
  SET(CERTI_CERTI_LIBRARY_FOUND "YES")
ELSE (CERTI_CERTI_LIBRARY)
  SET(CERTI_CERTI_LIBRARY_FOUND "NO")
  IF (NOT CERTI_FIND_QUIETLY)
      MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for CERTI library... - NOT FOUND")
  ENDIF(NOT CERTI_FIND_QUIETLY)
ENDIF (CERTI_CERTI_LIBRARY)

IF (CERTI_CERTI_LIBRARY) 
  GET_FILENAME_COMPONENT(CERTI_LIBRARY_DIRS ${CERTI_CERTI_LIBRARY} PATH) 
ENDIF (CERTI_CERTI_LIBRARY)

FIND_LIBRARY(CERTI_RTI_LIBRARY
	NAMES RTI
	PATHS ${PATH_LIBS}	
	PATH_SUFFIXES lib
	DOC "The RTI Library")

IF (CERTI_RTI_LIBRARY) 
  MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for RTI library... - found ${CERTI_RTI_LIBRARY}")
  SET(CERTI_RTI_LIBRARY_FOUND "YES")
ELSE (CERTI_RTI_LIBRARY)
  SET(CERTI_RTI_LIBRARY_FOUND "NO")
  MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for RTI library... - NOT FOUND")
ENDIF (CERTI_RTI_LIBRARY)

IF (CERTI_RTI_LIBRARY) 
  GET_FILENAME_COMPONENT(TEMP ${CERTI_CERTI_LIBRARY} PATH) 
  IF (NOT "${TEMP}" STREQUAL "${CERTI_LIBRARY_DIRS}")
    SET(CERTI_LIBRARY_DIRS "${CERTI_LIBRARY_DIRS};${TEMP}")
  ENDIF(NOT "${TEMP}" STREQUAL "${CERTI_LIBRARY_DIRS}")
ENDIF (CERTI_RTI_LIBRARY)

FIND_FILE(CERTI_INCLUDE
  NAMES RTI.hh
  PATHS ${PATH_INCLUDE}
  PATH_SUFFIXES include
  DOC "The CERTI Include Files")

IF (CERTI_INCLUDE) 
  GET_FILENAME_COMPONENT(CERTI_INCLUDE_DIRS ${CERTI_INCLUDE} PATH) 
ENDIF (CERTI_INCLUDE)

## FIXME we may use this when CMake 2.6 is out.
# handle the QUIETLY and REQUIRED arguments and set JPEG_FOUND to TRUE if
# all listed variables are TRUE
#INCLUDE(FindPackageHandleStandardArgs)
#FIND_PACKAGE_HANDLE_STANDARD_ARGS(JPEG DEFAULT_MSG JPEG_LIBRARY JPEG_INCLUDE_DIR)

IF (CERTI_RTI_LIBRARY     AND 
    CERTI_CERTI_LIBRARY AND
    CERTI_RTIA_EXECUTABLE AND
    CERTI_RTIG_EXECUTABLE AND
    CERTI_INCLUDE)

  SET(CERTI_FOUND TRUE)
  MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for CERTI... - All components FOUND")
  SET(CERTI_LIBRARIES ${CERTI_RTI_LIBRARY} ${CERTI_CERTI_LIBRARY}) 
ELSE (CERTI_RTI_LIBRARY     AND
    CERTI_CERTI_LIBRARY       AND 
    CERTI_RTIA_EXECUTABLE AND
    CERTI_RTIG_EXECUTABLE AND
    CERTI_INCLUDE)
  SET(CERTI_FOUND FALSE)
  MESSAGE_QUIETLY(CERTI_FIND_QUIETLY STATUS "Looking for CERTI... - NOT all CERTI components were FOUND")   
  IF (CERTI_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Cannot find all CERTI components, please try to set CERTI_HOME and rerun")
  ENDIF (CERTI_FIND_REQUIRED)
ENDIF(CERTI_RTI_LIBRARY AND
   CERTI_CERTI_LIBRARY AND
  CERTI_RTIA_EXECUTABLE AND
  CERTI_RTIG_EXECUTABLE AND
  CERTI_INCLUDE)

MARK_AS_ADVANCED(
    CERTI_INCLUDE_DIRS
    CERTI_LIBRARIES
    CERTI_DEFINITIONS
    CERTI_LIBRARY_DIRS
    CERTI_BINARY_DIRS
  )