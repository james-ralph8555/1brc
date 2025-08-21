# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository implements a high-performance C++ solution for the One Billion Row Challenge (1BRC) using the DuckDB API. The solution leverages DuckDB's analytical database capabilities to process one billion rows of weather station temperature measurements efficiently.

## Architecture

The project uses a strategic approach where DuckDB serves as the core analytical engine rather than implementing custom parsing and aggregation logic. The C++ application acts as a high-performance driver that:

1. Configures DuckDB for optimal resource utilization
2. Executes a single SQL query that handles file reading, parsing, aggregation, and sorting
3. Processes and formats the results for output

## Development Commands

Based on the implementation guide, the project uses CMake for building:

### Build Commands
```bash
# Create build directory
mkdir -p build
cd build

# Generate build files
cmake ..

# Compile the project
make

# For optimized release build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
```

### Performance Testing
```bash
# Benchmark with hyperfine (if available)
hyperfine --warmup 3 './1brc_duckdb'
```

## Project Structure

The recommended project structure from the implementation guide:
```
1brc_duckdb/
├── build/          # Directory for compiled files
├── data/           # Location for measurements.txt
├── lib/            # Location for duckdb.hpp and libduckdb.so
├── src/            # C++ source code (main.cpp)
└── CMakeLists.txt  # Build script
```

## Dependencies

- **DuckDB C++ Library**: Download from official DuckDB installation page
  - `duckdb.hpp` - C++ header file
  - `libduckdb.so` (Linux) or `libduckdb.dylib` (macOS) - shared library
- **C++17 compliant compiler** (GCC or Clang)
- **CMake** (minimum version 3.12)

## Key Implementation Details

### DuckDB Configuration
The solution optimizes DuckDB performance through:
- Explicit thread configuration using `std::thread::hardware_concurrency()`
- Memory limit settings (16GB+ recommended)
- Insertion order preservation settings for aggregation optimization

### SQL Query Strategy
Uses DuckDB's `READ_CSV` function with explicit parameters:
- `header=false`
- `delim=';'`
- `columns={'station_name':'VARCHAR','measurement':'DECIMAL(3,1)'}`

### Compiler Optimizations
For maximum performance, use aggressive compiler flags:
- `-O3` for optimization
- `-march=native` for CPU-specific optimizations
- `-flto` for link-time optimization

## Input/Output Format

- **Input**: Text file with format `<station_name>;<temperature>` per line
- **Output**: `<station_name>=<min>/<mean>/<max>` sorted alphabetically
- Temperature range: -99.9 to 99.9 with one decimal place
- Maximum 10,000 unique stations

## Performance Considerations

The implementation guide emphasizes a layered optimization approach:
1. DuckDB engine configuration
2. Efficient API usage for data ingestion and result retrieval
3. Compiler optimizations for native code generation

The solution is designed to handle the full one billion row dataset (12-16 GB) efficiently by keeping operations in-memory and leveraging DuckDB's parallel processing capabilities.