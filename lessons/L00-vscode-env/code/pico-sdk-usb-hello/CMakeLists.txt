cmake_minimum_required(VERSION 3.13)

# Generate compile_commands.json for VS Code IntelliSense.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT PICO_SDK_PATH)
    if(DEFINED ENV{PICO_SDK_PATH} AND NOT "$ENV{PICO_SDK_PATH}" STREQUAL "")
        set(PICO_SDK_PATH "$ENV{PICO_SDK_PATH}" CACHE PATH "Path to the Pico SDK")
    elseif(DEFINED ENV{HOME} AND EXISTS "$ENV{HOME}/opt/pico-sdk/external/pico_sdk_import.cmake")
        set(PICO_SDK_PATH "$ENV{HOME}/opt/pico-sdk" CACHE PATH "Path to the Pico SDK")
        message(STATUS "PICO_SDK_PATH not set; using default ${PICO_SDK_PATH}")
    else()
        message(FATAL_ERROR
            "PICO_SDK_PATH is not set. Export PICO_SDK_PATH or pass "
            "-DPICO_SDK_PATH=/path/to/pico-sdk."
        )
    endif()
endif()

if(NOT EXISTS "${PICO_SDK_PATH}/external/pico_sdk_import.cmake")
    message(FATAL_ERROR
        "Invalid PICO_SDK_PATH='${PICO_SDK_PATH}'. Expected file: "
        "${PICO_SDK_PATH}/external/pico_sdk_import.cmake"
    )
endif()

include("${PICO_SDK_PATH}/external/pico_sdk_import.cmake")

project(l00_usb_hello C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()

add_executable(l00_usb_hello
    main.c
)

target_link_libraries(l00_usb_hello pico_stdlib)

# USB serial on, hardware UART off for beginner-friendly console output.
pico_enable_stdio_usb(l00_usb_hello 1)
pico_enable_stdio_uart(l00_usb_hello 0)

pico_add_extra_outputs(l00_usb_hello)
