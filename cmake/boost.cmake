INCLUDE (FindThreads)
INCLUDE (ExternalProject)

IF (NOT ASIO_SOCKETS)
	INCLUDE (CheckIncludeFiles)

	IF (WIN32)
		SET (Boost_USE_STATIC_LIBS TRUE)
	ENDIF (WIN32)

	FIND_PACKAGE (Boost ${MIN_BOOST_VERSION})

	IF (Boost_FOUND)
		SET (CMAKE_REQUIRED_INCLUDES ${Boost_INCLUDE_DIRS})

		IF (NOT WIN32)
			SET (CMAKE_REQUIRED_FLAGS "-DBOOST_ERROR_CODE_HEADER_ONLY")
		ELSE (NOT WIN32)
			SET (CMAKE_REQUIRED_FLAGS " -DBOOST_DATE_TIME_NO_LIB -DBOOST_REGEX_NO_LIB -DBOOST_SYSTEM_NO_LIB -DBOOST_ERROR_CODE_HEADER_ONLY")
		ENDIF (NOT WIN32)

		SET (CMAKE_REQUIRED_LIBRARIES "Threads::Threads")
		CHECK_INCLUDE_FILES ("boost/system/error_code.hpp;boost/asio.hpp" ASIO_SOCKETS LANGUAGE CXX)

		IF (ASIO_SOCKETS)
			SET (Boost_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} CACHE STRING "Libraries needed for linking with boost" FORCE)
			SET (BOOST_ERROR_CODE_HEADER_ONLY TRUE CACHE INTERNAL "When true, boost_system lib is not needed for linking" FORCE)
			UNSET (CMAKE_REQUIRED_INCLUDES)
			UNSET (CMAKE_REQUIRED_FLAGS)
			UNSET (CMAKE_REQUIRED_LIBRARIES)
		ELSE (ASIO_SOCKETS)
			IF (NOT DOWNLOAD_AND_BUILD_DEPS)
				MESSAGE (STATUS "No useable boost headers found. Disabling support")
				SET (ENABLE_BOOST FALSE)
			ENDIF (NOT DOWNLOAD_AND_BUILD_DEPS)
		ENDIF (ASIO_SOCKETS)
	ENDIF (Boost_FOUND)
ENDIF (NOT ASIO_SOCKETS)

IF (NOT ASIO_SOCKETS AND DOWNLOAD_AND_BUILD_DEPS)
	IF (NOT WIN32)
		SET (BOOST_PATCH_COMMAND ./bootstrap.sh)
		SET (BOOST_CONFIGURE_COMMAND ./b2 headers)
	ELSE (NOT WIN32)
		SET (BOOST_PATCH_COMMAND bootstrap.bat)
		SET (BOOST_CONFIGURE_COMMAND b2 headers)
	ENDIF (NOT WIN32)

	EXTERNALPROJECT_ADD (BOOST
		GIT_REPOSITORY https://github.com/boostorg/boost.git
		GIT_TAG boost-1.70.0
		GIT_PROGRESS TRUE
		PATCH_COMMAND ${BOOST_PATCH_COMMAND}
		CONFIGURE_COMMAND ${BOOST_CONFIGURE_COMMAND}
		BUILD_COMMAND ""
		INSTALL_COMMAND ""
		BUILD_IN_SOURCE TRUE
	)

	EXTERNALPROJECT_GET_PROPERTY (BOOST SOURCE_DIR)
	LIST (APPEND EXTERNAL_DEPS BOOST)
	SET (RECONF_COMMAND ${RECONF_COMMAND} -DBOOST_ROOT=${SOURCE_DIR})
ENDIF (NOT ASIO_SOCKETS AND DOWNLOAD_AND_BUILD_DEPS)
