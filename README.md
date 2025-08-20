# One Billion Row Challenge Implementations

This repository contains high-performance implementations of the [One Billion Row Challenge](https://github.com/gunnarmorling/1brc) using different technologies and optimization strategies.

## 🏆 Performance Results

Both implementations achieve exceptional sub-10-second performance on the full 1-billion-row dataset:

| Implementation | Technology | Best Time | Mean Time | Strategy |
|---|---|---|---|---|
| **1brc-datafusion-rs** | Rust + DataFusion | **~6.26s** | 6.26s ± 0.19s | Query engine + systematic optimization |
| **1brc-duckdb-cpp** | C++ + DuckDB | **7.416s** | 9.64s ± 3.17s | Analytical database + aggressive compiler flags |

*Benchmarks performed on AMD Ryzen 9 5900X (24 cores) @ 4.95 GHz, 32GB RAM*

## Implementations

### [1brc-datafusion-rs](./1brc-datafusion-rs/) - Rust Implementation
- **Technology**: Apache DataFusion query engine
- **Performance**: 6.26 seconds (±0.19s) for 1 billion rows
- **Strategy**: Systematic optimization with explicit schema, compiler tuning, and Profile-Guided Optimization
- **Key Features**: High-level API constraint, production-ready safety

### [1brc-duckdb-cpp](./1brc-duckdb-cpp/) - C++ Implementation  
- **Technology**: DuckDB analytical database
- **Performance**: 7.416 seconds best time (9.64s ±3.17s mean) for 1 billion rows
- **Strategy**: Single SQL query with aggressive compiler optimizations
- **Key Features**: Minimal code complexity, maximum CPU utilization (1650%)

## Generating Test Data

The official 1BRC data generator is included in this repository. Use it to create the measurements dataset:

```bash
# Compile the data generator (requires Java and javac)
javac dev/morling/onebrc/CreateMeasurements.java

# Generate the full 1 billion row dataset (takes 5-10 minutes)
time java -cp . dev.morling.onebrc.CreateMeasurements 1000000000

# Or generate a smaller test dataset for development
java -cp . dev.morling.onebrc.CreateMeasurements 100000
```

The generator creates realistic weather station data with:
- 413 authentic weather stations from around the world
- Gaussian-distributed temperatures around each station's mean
- Temperature range: -99.9°C to +99.9°C
- Output file: `measurements.txt` (approximately 12-16 GB for 1 billion rows)

## Quick Start

### Prerequisites
- **Java**: For data generation
- **C++**: GCC/Clang with CMake for C++ implementation
- **Rust**: Latest stable version for Rust implementation
- **hyperfine**: `cargo install hyperfine` (recommended for benchmarking)

### Build and Run
```bash
# 1. Generate test data
javac dev/morling/onebrc/CreateMeasurements.java
java -cp . dev.morling.onebrc.CreateMeasurements 1000000000

# 2a. Run Rust implementation (fastest)
cd 1brc-datafusion-rs
cargo build --release
time ./target/release/onebrc-datafusion-rs ../measurements.txt

# 2b. Run C++ implementation
cd 1brc-duckdb-cpp
mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && make
time ./1brc_duckdb ../measurements.txt
```

## Architecture Strategy

Both implementations use a **query engine approach** rather than custom data processing:

- **Core Philosophy**: Leverage purpose-built analytical engines instead of implementing custom parsing/aggregation
- **Single Query Strategy**: Delegate entire data pipeline (reading, parsing, grouping, sorting) to declarative SQL
- **Engine Optimization**: Configure database engines for maximum CPU/memory utilization
- **Minimal Host Code**: Focus only on configuration and result formatting

This approach avoids the complexity of building custom high-performance parsers, instead relying on heavily optimized, parallel, and vectorized analytical database engines.

### Output Format
Both implementations process input format `<station_name>;<temperature>` and produce:
```
<station_name>=<min>/<mean>/<max>
```
Results are sorted alphabetically by station name with temperatures rounded to one decimal place.

## Repository Structure

```
1brc/
├── dev/morling/onebrc/          # Java data generator (shared)
├── measurements.txt             # Generated dataset (shared)
├── 1brc-duckdb-cpp/            # C++ implementation using DuckDB
│   ├── README.md               # Detailed C++ implementation guide
│   ├── CLAUDE.md               # Claude Code guidance
│   ├── src/main.cpp            # Main implementation
│   └── build/                  # Compiled binaries
├── 1brc-datafusion-rs/         # Rust implementation using DataFusion  
│   ├── README.md               # Detailed Rust implementation guide
│   ├── CLAUDE.md               # Claude Code guidance
│   ├── src/main.rs             # Main implementation
│   └── target/release/         # Compiled binaries
└── README.md                   # This overview file
```

### Key Insights
- **DataFusion (Rust)**: Achieves consistent ~6.26s through systematic optimization
- **DuckDB (C++)**: Achieves 7.416s best time with excellent parallelization (1650% CPU usage)
- Both approaches prioritize **declarative simplicity** over custom implementation complexity

## References

- [One Billion Row Challenge](https://github.com/gunnarmorling/1brc) by Gunnar Morling
- [Apache DataFusion](https://github.com/apache/arrow-datafusion) - Rust query engine
- [DuckDB](https://duckdb.org/) - Analytical database for C++
