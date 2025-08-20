cmake_minimum_required(VERSION 3.12)
project(1brc_duckdb)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(1brc_duckdb src/main.cpp)

target_include_directories(1brc_duckdb PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib)
target_link_directories(1brc_duckdb PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib)
target_link_libraries(1brc_duckdb PRIVATE duckdb)

# Set aggressive optimization flags specifically for Release builds
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -march=native -flto")