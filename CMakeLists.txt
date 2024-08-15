cmake_minimum_required(VERSION 3.10)
project(WebAssemblyTest C)

# Ensure Emscripten is being used
if(NOT EMSCRIPTEN)
    message(FATAL_ERROR "This CMake file is designed for Emscripten. Please use emcmake.")
endif()

# Set the path to wasm tools
get_filename_component(BINARYEN_PATH "${CMAKE_C_COMPILER}" DIRECTORY)
set(BINARYEN_PATH "${BINARYEN_PATH}/../bin")

# Add the main executable
add_executable(${PROJECT_NAME} main.c)

# Copy files to build directory
add_custom_target(copyWebFiles
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/web/index.html" "${CMAKE_CURRENT_SOURCE_DIR}//bin/"
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/web/coi-serviceworker.js" "${CMAKE_CURRENT_SOURCE_DIR}//bin/")
add_dependencies(${PROJECT_NAME} copyWebFiles)

# Set Emscripten flags
set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".js")
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/bin/")
set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS
        "-sEXPORTED_RUNTIME_METHODS=['ccall','wasmExports','wasmMemory'] -sEXPORTED_FUNCTIONS=['_main'] \
        --pre-js ${CMAKE_CURRENT_SOURCE_DIR}/web/pre.js --post-js ${CMAKE_CURRENT_SOURCE_DIR}/web/post.js \
        -sALLOW_MEMORY_GROWTH=1 -sINITIAL_MEMORY=256MB -sMAXIMUM_MEMORY=4GB \
        -sMODULARIZE -sEXPORT_ES6 \
        -sASSERTIONS -sERROR_ON_UNDEFINED_SYMBOLS=0"
)

# Post-build commands
set(BIN_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bin)
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        # Convert memory.wat to memory.wasm
        COMMAND ${BINARYEN_PATH}/wasm-as -all ${CMAKE_CURRENT_SOURCE_DIR}/memory.wat -o ${CMAKE_CURRENT_BINARY_DIR}/memory.wasm

        # Convert external.wat to external.wasm
        COMMAND ${BINARYEN_PATH}/wasm-as -all ${CMAKE_CURRENT_SOURCE_DIR}/external.wat -o ${BIN_DIR}/external.wasm

        # Merge WebAssembly files
        COMMAND ${BINARYEN_PATH}/wasm-merge --rename-export-conflicts -all ${BIN_DIR}/${PROJECT_NAME}.wasm mod ${CMAKE_CURRENT_BINARY_DIR}/memory.wasm env -o ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_merged.wasm

        # (Optional) Convert merged WebAssembly to WAT for inspection
        COMMAND ${BINARYEN_PATH}/wasm-dis -all ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_merged.wasm -o ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_merged.wat

        # Move the merged file to the bin directory
        COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_merged.wasm ${BIN_DIR}/${PROJECT_NAME}.wasm

        # Optimize WebAssembly file
        COMMAND ${BINARYEN_PATH}/wasm-opt -O3 -all ${BIN_DIR}/${PROJECT_NAME}.wasm -o ${BIN_DIR}/${PROJECT_NAME}.wasm

        # (Optional) Convert optimized WebAssembly to WAT for inspection
        COMMAND ${BINARYEN_PATH}/wasm-dis -all ${BIN_DIR}/${PROJECT_NAME}.wasm -o ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_optimized.wat

        COMMENT "Processing and merging WebAssembly files"
)