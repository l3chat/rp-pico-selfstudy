cmake_minimum_required(VERSION 3.13)

if(NOT DEFINED ENV{PICO_SDK_PATH})
    message(FATAL_ERROR "PICO_SDK_PATH is not set. Export it before running CMake.")
endif()

include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)

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
