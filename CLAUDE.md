# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a central repository for One Billion Row Challenge (1BRC) implementations, containing multiple language/technology approaches to processing 1 billion weather station temperature measurements.

## Repository Structure

```
1brc/
├── dev/morling/onebrc/          # Java data generator (shared)
├── measurements.txt             # Generated dataset (shared)
├── test_data/                   # Test datasets
│   ├── measurements_1k.txt     # 1,000 row test dataset
│   └── measurements_1b.txt     # 1 billion row dataset
├── 1brc-duckdb-cpp/            # C++ implementation using DuckDB
├── 1brc-datafusion-rs/         # Rust implementation using DataFusion
└── README.md                    # Dataset generation instructions
```

## Shared Components

### Data Generator
- **Location**: `./dev/morling/onebrc/CreateMeasurements.java`
- **Usage**: `java -cp . dev.morling.onebrc.CreateMeasurements <num_rows>`
- **Output**: `measurements.txt` with format `<station_name>;<temperature>`
- **Compile**: `javac dev/morling/onebrc/CreateMeasurements.java`

### Dataset
- **File**: `measurements.txt` (shared by all implementations)
- **Format**: Semi-colon separated values, one per line
- **Size**: ~14GB for 1 billion rows
- **Stations**: Up to 413 unique weather stations
- **Temperature Range**: -99.9°C to +99.9°C

## Architecture Strategy

Both implementations use a **query engine approach** rather than custom data processing code:

- **Core Philosophy**: Leverage purpose-built analytical engines instead of implementing custom parsing/aggregation
- **Single Query Strategy**: Delegate entire data pipeline (reading, parsing, grouping, sorting) to a declarative SQL query
- **Engine Configuration**: Optimize database engines for maximum CPU/memory utilization
- **Minimal Host Code**: Keep C++/Rust code minimal - focus only on configuration and result formatting

This approach avoids the complexity of building custom high-performance parsers, instead relying on heavily optimized, parallel, and vectorized analytical database engines.

## Implementation Approaches

### 1brc-duckdb-cpp
- **Technology**: C++ with DuckDB analytical database
- **Strategy**: Single SQL query leveraging DuckDB's READ_CSV function with explicit schema
- **Performance**: **7.416 seconds best time** for 1 billion rows (9.638s mean ±3.169s)
- **Build**: CMake with aggressive optimization flags (`-O3 -march=native -flto`)
- **Key Optimizations**: All-core parallelization, 16GB memory limit. Supports both `DOUBLE` and `DECIMAL(3,1)` temperature types.

### 1brc-datafusion-rs  
- **Technology**: Rust with Apache DataFusion query engine
- **Strategy**: SQL-based approach with systematic optimization (schema elimination, compiler tuning, parallelism)
- **Performance**: **~6.26 seconds** for 1 billion rows
- **Build**: Cargo with aggressive release profile and Profile-Guided Optimization (PGO)
- **Key Optimizations**: Explicit schema definition, native CPU targeting, multi-core target partitions. Supports both `Float64` and `Decimal128(3,1)` types.

## Development Commands

### Generate Data
```bash
# Compile generator
javac dev/morling/onebrc/CreateMeasurements.java

# Generate full dataset (1B rows)
java -cp . dev.morling.onebrc.CreateMeasurements 1000000000

# Generate test dataset
java -cp . dev.morling.onebrc.CreateMeasurements 100000
```

### Build Implementations
```bash
# C++ DuckDB version (builds both double and decimal executables)
cd 1brc-duckdb-cpp
./build_updated.sh release        # Optimized build (default)
./build_updated.sh debug          # Fast debug build

# Rust DataFusion version (builds both double and decimal executables)
cd 1brc-datafusion-rs
./build_updated.sh release        # Optimized build (default)  
./build_updated.sh debug          # Fast debug build
```

### Run Implementations
```bash
# C++ DuckDB (run from 1brc-duckdb-cpp directory)
# Double schema
./build/1brc_duckdb_double ../measurements.txt results_double.csv
# Decimal schema
./build/1brc_duckdb_decimal ../measurements.txt results_decimal.csv

# Rust DataFusion (run from 1brc-datafusion-rs directory)
# Float64 schema
./target/release/onebrc-datafusion-double ../measurements.txt results_double.csv
# Decimal128 schema
./target/release/onebrc-datafusion-decimal ../measurements.txt results_decimal.csv
```

### Performance Benchmarking
```bash
# Install hyperfine for accurate benchmarking
cargo install hyperfine

# Benchmark C++ implementation
cd 1brc-duckdb-cpp/build
hyperfine --warmup 3 './1brc_duckdb ../measurements.txt'

# Benchmark Rust implementation  
cd 1brc-datafusion-rs
hyperfine --warmup 3 './target/release/onebrc-datafusion-rs measurements.txt'
```

### Testing Implementation Correctness
```bash
# C++ implementation tests
cd 1brc-duckdb-cpp
./test.sh                       # Uses measurements_1k.txt for testing

# Rust implementation tests
cd 1brc-datafusion-rs
./test.sh                       # Uses measurements_1k.txt for performance tests
```

## Expected Output Format

All implementations process the input format `<station_name>;<temperature>` and produce a CSV file with the format:
```csv
station_name,min_measurement,mean_measurement,max_measurement
```

Results are sorted alphabetically by station name, with temperatures rounded to one decimal place.

## Key Files
- Each implementation has its own README.md with specific instructions:
  - `1brc-duckdb-cpp/README.md` - C++ DuckDB implementation guide with 7.416s benchmark results
  - `1brc-datafusion-rs/README.md` - Rust DataFusion implementation guide with 6.26s performance  
- Each implementation has its own CLAUDE.md with detailed implementation context
- Shared dataset generation is documented in main README.md
- Both implementations include test scripts and sample data for validation

## System-Specific Information

### Shell Interpreter
- **Correct Path**: `/run/current-system/sw/bin/bash` (verified working path for this NixOS system)
- All build scripts use this interpreter path for compatibility

### Build Script Standards
- **Debug Mode**: `./build_updated.sh debug` - Fast build with debug symbols
- **Release Mode**: `./build_updated.sh release` - Fully optimized build (default)
- Scripts include argument validation and detailed build status reporting

### Test Script Standards
- **C++**: `1brc-duckdb-cpp/test.sh` for validation
- **Rust**: `1brc-datafusion-rs/test.sh` for validation
- Scripts auto-detect and test available executables (`double` and `decimal` versions)
- Scripts use `../test_data/measurements_1k.txt` for performance testing when available
- Scripts validate the generated CSV output
