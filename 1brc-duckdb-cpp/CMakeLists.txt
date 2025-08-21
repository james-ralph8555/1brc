cmake_minimum_required(VERSION 3.12)
project(1brc_duckdb)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)
FetchContent_Declare(
  duckdb
  GIT_REPOSITORY https://github.com/duckdb/duckdb.git
  GIT_TAG v1.0.0
)
FetchContent_MakeAvailable(duckdb)

add_executable(1brc_duckdb_double src/main_double.cpp)
add_executable(1brc_duckdb_decimal src/main_decimal.cpp)

target_link_libraries(1brc_duckdb_double PRIVATE duckdb)
target_link_libraries(1brc_duckdb_decimal PRIVATE duckdb)

# Set aggressive optimization flags specifically for Release builds
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -march=native -flto")

# Set debug flags with proper AddressSanitizer configuration
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -fsanitize=address -fsanitize-address-use-after-scope")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "-fsanitize=address")

# Ensure AddressSanitizer runtime comes first in library list
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_link_options(1brc_duckdb_double PRIVATE -fsanitize=address)
    target_link_options(1brc_duckdb_decimal PRIVATE -fsanitize=address)
endif()

# Add test executable
add_executable(test_runner tests/test_main.cpp)

# Test target doesn't need DuckDB, just file I/O
target_compile_features(test_runner PRIVATE cxx_std_17)