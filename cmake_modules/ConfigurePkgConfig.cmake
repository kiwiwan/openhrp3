#  @author Takafumi Tawara

if(PKG_CONFIG_FOUND)
  set(PACKAGE_NAME "OpenHRP3.1")
  set(OPENHRP_URL "http://www.openrtp.jp/openhrp3/")
  set(PKG_CONF_REQUIRES "")
  set(PKG_CONF_LINK_DEPEND_OPTS "''")
  if(OPENRTM_PKG_CONFIG_FOUND)
    set(PKG_CONF_REQUIRES "openrtm-aist")
  endif(OPENRTM_PKG_CONFIG_FOUND)
  set(PKG_CONF_LINK_SHARED_FILES "-lhrpCollision-${OPENHRP_LIBRARY_VERSION} " 
      "-lhrpModel-${OPENHRP_LIBRARY_VERSION} " "-lhrpPlanner-${OPENHRP_LIBRARY_VERSION} " 
      "-lhrpUtil-${OPENHRP_LIBRARY_VERSION} " "-lsDIMS")
  string(REGEX REPLACE ";" ""
     PKG_CONF_LINK_SHARED_FILES ${PKG_CONF_LINK_SHARED_FILES})

  set(PKG_CONF_LINK_STATIC_FILES "-lhrpCorbaStubSkel-${OPENHRP_LIBRARY_VERSION}" )

  set(PKG_CONF_LINK_DEPEND_DIRS)
  if(LAPACK_LIBRARY_DIRS)
    list(APPEND PKG_CONF_LINK_DEPEND_DIRS "-L${LAPACK_LIBRARY_DIRS} ")
  endif()
  if(Boost_LIBRARY_DIRS)
    list(APPEND PKG_CONF_LINK_DEPEND_DIRS "-L${Boost_LIBRARY_DIRS} ")
  endif()
  if(NOT OPENRTM_PKG_CONFIG_FOUND)
    foreach(localDir ${OPENRTM_LIBRARY_DIRS})
      list(APPEND PKG_CONF_LINK_DEPEND_DIRS "-L${localDir} ")
    endforeach()
  endif()
  string(REGEX REPLACE ";" ""
     PKG_CONF_LINK_DEPEND_DIRS ${PKG_CONF_LINK_DEPEND_DIRS})

  set(PKG_CONF_LINK_DEPEND_FILES_TEMP)
  set(PKG_CONF_LINK_DEPEND_FILES)
  foreach(libName ${LAPACK_LIBRARIES})
    list(APPEND PKG_CONF_LINK_DEPEND_FILES_TEMP ${libName})
  endforeach()
  list(APPEND PKG_CONF_LINK_DEPEND_FILES_TEMP boost_filesystem-mt boost_signals-mt boost_program_options-mt boost_regex-mt)
  if(JPEG_LIBRARY)
    list(APPEND PKG_CONF_LINK_DEPEND_FILES_TEMP ${JPEG_LIBRARY})
  endif()
  if(PNG_LIBRARY)
    list(APPEND PKG_CONF_LINK_DEPEND_FILES_TEMP ${PNG_LIBRARY})
  endif(PNG_LIBRARY)
  if(PNG_JPEG_BUILD)
    if(ZLIB_LIBRARY)
      list(APPEND PKG_CONF_LINK_DEPEND_FILES_TEMP ${ZLIB_LIBRARY})
    endif(ZLIB_LIBRARY)
  else()
    list(APPEND PKG_CONF_LINK_DEPEND_FILES_TEMP z)
  endif(PNG_JPEG_BUILD)
  foreach(name ${PKG_CONF_LINK_DEPEND_FILES_TEMP})
    GET_FILENAME_COMPONENT(localVal ${name} NAME_WE)
    string(REGEX REPLACE "^lib" "" localVal ${localVal})
    list(APPEND PKG_CONF_LINK_DEPEND_FILES "-l${localVal} ")
  endforeach()
  if(NOT OPENRTM_PKG_CONFIG_FOUND)
    set(PKG_CONF_LINK_DEPEND_OPTS "")
    foreach(localFile ${OPENRTM_LIBRARIES})
      if("${localFile}" MATCHES "^-l.+")
        list(APPEND PKG_CONF_LINK_DEPEND_FILES "${localFile} ")
      else()
        list(APPEND PKG_CONF_LINK_DEPEND_OPTS "${localFile} ")
      endif()
    endforeach()
    if("${PKG_CONF_LINK_DEPEND_OPTS}" STREQUAL "")
      set(PKG_CONF_LINK_DEPEND_OPTS "''")
    else()
      string(REGEX REPLACE ";" ""
         PKG_CONF_LINK_DEPEND_OPTS ${PKG_CONF_LINK_DEPEND_OPTS})
    endif()
  endif()
  string(REGEX REPLACE ";" ""
     PKG_CONF_LINK_DEPEND_FILES ${PKG_CONF_LINK_DEPEND_FILES})

  set(PKG_CONF_DEFS "-DTVMET_OPTIMIZE ")

  if( CMAKE_BUILD_TYPE STREQUAL MinSizeRel)
    set(PKG_CONF_CXXFLAG_OPTIONS "${CMAKE_CXX_FLAGS_MINSIZEREL}")
  elseif(CMAKE_BUILD_TYPE STREQUAL Debug)
    set(PKG_CONF_CXXFLAG_OPTIONS "${CMAKE_CXX_FLAGS_DEBUG}")
  elseif(CMAKE_BUILD_TYPE STREQUAL RelWithDebInfo)
    set(PKG_CONF_CXXFLAG_OPTIONS "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
  else()
    STRING(REGEX REPLACE " ?-DNDEBUG" "" PKG_CONF_CXXFLAG_OPTIONS "${CMAKE_CXX_FLAGS_RELEASE}")
#    set(PKG_CONF_CXXFLAG_OPTIONS "${CMAKE_CXX_FLAGS_RELEASE}")
  endif()
  if(NOT OPENRTM_PKG_CONFIG_FOUND)
    set(PKG_CONF_CXXFLAG_OPTIONS "${OPENRTM_CXX_FLAGS} ${PKG_CONF_CXXFLAG_OPTIONS}")
    string(REGEX REPLACE "\n" ""
       PKG_CONF_CXXFLAG_OPTIONS ${PKG_CONF_CXXFLAG_OPTIONS})
  endif()
  
  configure_file(openhrp3.1.pc.in openhrp3.1.pc @ONLY)
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/openhrp3.1.pc DESTINATION lib/pkgconfig)
endif(PKG_CONFIG_FOUND)
