# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rust implementation of the One Billion Row Challenge (1BRC) using Apache DataFusion. The project aims to achieve maximum performance while operating exclusively through DataFusion's high-level APIs, demonstrating how to optimize a general-purpose query engine for a specific data processing task.

## Build and Development Commands

### Basic Commands
```bash
# Create new Rust project (if starting from scratch)
cargo new 1brc-datafusion
cd 1brc-datafusion

# Build for development
cargo build

# Build optimized release binary
cargo build --release

# Run tests
cargo test

# Build with maximum performance optimizations
RUSTFLAGS='-C target-cpu=native' cargo build --release
```

### Performance Benchmarking
```bash
# Install benchmarking tool
cargo install hyperfine

# Run performance benchmark (requires release build)
hyperfine --warmup 3 './target/release/onebrc-datafusion path/to/measurements.txt results.csv'
```

### Profile-Guided Optimization (PGO) - Advanced
```bash
# Install LLVM tools
rustup component add llvm-tools-preview

# Create PGO data directory
mkdir -p /tmp/pgo-data

# Build instrumented binary
RUSTFLAGS="-Cprofile-generate=/tmp/pgo-data" cargo build --release

# Run instrumented binary to generate profile
./target/release/onebrc-datafusion path/to/sample_data.txt results.csv

# Merge profile data
LLVM_PROFDATA_PATH=$(find ~/.rustup -name "llvm-profdata" | head -n 1)
$LLVM_PROFDATA_PATH merge -o /tmp/pgo-data/merged.profdata /tmp/pgo-data

# Build final PGO-optimized binary
RUSTFLAGS="-Cprofile-use=/tmp/pgo-data/merged.profdata" cargo build --release
```

## Key Dependencies

- **datafusion**: Apache DataFusion query engine for CSV processing and aggregation
- **tokio**: Async runtime required by DataFusion (multi-threaded features enabled)
- **num_cpus**: For detecting available CPU cores to optimize parallelism

## Architecture and Performance Strategy

### Core Approach
The implementation follows a systematic optimization approach:

1. **Explicit Schema Definition**: Eliminates costly schema inference by providing exact column types (string for station, Float64 for temperature)
2. **Compiler Optimizations**: Aggressive release profile settings with LTO and native CPU targeting
3. **Parallelism Tuning**: Configure DataFusion's `target_partitions` to match hardware cores
4. **Profile-Guided Optimization**: Use runtime profiling data for final performance gains

### Critical Performance Settings

#### Cargo.toml Release Profile
```toml
[profile.release]
opt-level = 3
lto = "fat"
codegen-units = 1
panic = "abort"
strip = "symbols"
```

#### DataFusion Configuration
- Set `target_partitions` to `num_cpus::get()` for optimal parallelism
- Use explicit Arrow schema to avoid inference overhead
- Configure CSV options: no header, semicolon delimiter, .txt extension

### Data Processing Flow
1. SessionContext with optimized parallelism settings
2. CSV reading with explicit schema (station: Utf8, temperature: Float64)
3. GroupBy aggregation (min, mean, max per station)
4. Alphabetical sorting by station name
5. Result collection

## File Structure

- `src/main.rs`: Main implementation following the optimization guide
- `datafusion_1brc_rs_implementation_guide.txt`: Comprehensive implementation guide with performance analysis
- `Cargo.toml`: Project configuration with performance-optimized release profile

## Testing Strategy

- Unit tests with small sample data to verify correctness
- Development testing on 10M row samples for rapid iteration
- Full benchmarking on 1B row dataset for official measurements
- Two-tiered approach prevents premature optimization based on small datasets

## Performance Expectations

The systematic optimization approach can achieve ~90x performance improvement over naive implementation:
- Baseline (with schema inference): ~215s
- Explicit schema: ~48s (4.5x improvement)
- Compiler optimized: ~16s (13.4x total)
- Engine tuned: ~2.8s (76.9x total)
- PGO optimized: ~2.4s (89.7x total)