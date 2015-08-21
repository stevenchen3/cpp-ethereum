function(eth_apply TARGET REQUIRED)
	eth_use(${TARGET} ${REQUIRED} EthCore)
	set(W3_DIR         "${CMAKE_CURRENT_LIST_DIR}/../webthree"         CACHE PATH "The path to the webthree directory")
	set(W3_BUILD_DIR   "${W3_DIR}/${BUILD_DIR_NAME}")
	set(CMAKE_LIBRARY_PATH ${W3_BUILD_DIR}/src;${CMAKE_LIBRARY_PATH})
	include_directories(${W3_DIR})
	find_library(ETH_WEBTHREE_LIBRARY NAMES webthree PATH_SUFFIXES "libwebthree" "webthree" "libwebthree/Release" )
	if (NOT ETH_WEBTHREE_LIBRARY)
		if (${REQUIRED} STREQUAL "REQUIRED")
			message( FATAL_ERROR "Webthree library not found" )
		endif()
		return()
	endif()
	target_link_libraries(${TARGET} ${ETH_WEBTHREE_LIBRARY})

	find_package (json_rpc_cpp 0.4 REQUIRED)

	message (" - json-rpc-cpp header: ${JSON_RPC_CPP_INCLUDE_DIRS}")
	message (" - json-rpc-cpp lib   : ${JSON_RPC_CPP_LIBRARIES}")
	add_definitions(-DETH_JSONRPC)

	find_package(MHD REQUIRED)
	message(" - microhttpd header: ${MHD_INCLUDE_DIRS}")
	message(" - microhttpd lib   : ${MHD_LIBRARIES}")
	message(" - microhttpd dll   : ${MHD_DLLS}")

	include_directories(BEFORE ${JSONCPP_INCLUDE_DIRS})
	include_directories(${JSON_RPC_CPP_INCLUDE_DIRS})
	target_link_libraries(${EXECUTABLE} ${JSON_RPC_CPP_SERVER_LIBRARIES})
	target_link_libraries(${EXECUTABLE} ${JSONCPP_LIBRARIES})
	target_link_libraries(${EXECUTABLE} ${CURL_LIBRARIES})
	target_link_libraries(${EXECUTABLE} ${MHD_LIBRARIES})
	if (DEFINED WIN32 AND NOT DEFINED CMAKE_COMPILER_IS_MINGW)
		eth_copy_dlls(${EXECUTABLE} CURL_DLLS)
	endif()
	eth_copy_dlls(${EXECUTABLE} MHD_DLLS)
endfunction()
