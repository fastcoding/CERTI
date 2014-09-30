
# FIXME I do not remember why this should be static?
# on non WINDOWS platform
IF (WIN32 AND MINGW)
    ADD_LIBRARY(graph graph_c.cc)
ELSE(WIN32 AND MINGW)
    IF (APPLE)
        find_library(TK Tk)        
        message("TK found : ${TK}")
        ADD_LIBRARY(graph SHARED graph_c.cc)
        target_include_directories(graph PUBLIC /opt/X11/include )
        target_link_libraries(graph TK /opt/X11/lib/libX11.dylib)
    ELSE()
    ADD_LIBRARY(graph STATIC graph_c.cc)
    ENDIF()
ENDIF(WIN32 AND MINGW)

INSTALL(TARGETS graph
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)
