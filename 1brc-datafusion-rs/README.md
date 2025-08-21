# One Billion Row Challenge - DataFusion Rust Implementation

A high-performance implementation of the One Billion Row Challenge (1BRC) using Rust and Apache DataFusion, achieving exceptional performance through systematic optimization while maintaining the safety and expressiveness of a high-level query engine.

## Overview

The One Billion Row Challenge (1BRC) tests the limits of data processing performance by reading a text file containing one billion temperature measurements from various weather stations and calculating the minimum, mean, and maximum temperature for each station. This implementation demonstrates how to achieve maximum performance while operating exclusively through DataFusion's high-level APIs.

### Key Achievement

This implementation achieves a significant improvement over a naive baseline through systematic optimization, demonstrating effective performance tuning of general-purpose query engines.

## Features

- **High-Level API Constraint**: Uses only DataFusion's public APIs (no custom memory mapping or unsafe code)
- **Systematic Optimization**: Multi-layered approach from I/O to compiler optimizations
- **Production-Ready**: Safe, maintainable code built on a robust query engine
- **Comprehensive Benchmarking**: Rigorous measurement framework with statistical validation
- **Advanced Techniques**: Profile-Guided Optimization (PGO) for maximum performance

## Implementation Status

✅ **COMPLETED**: Full implementation with all optimizations applied

- **Project Name**: `onebrc-datafusion-rs`
- **DataFusion Version**: 42.0.0 (latest compatible)
- **Dual Schema Support**: Both Float64 and Decimal128(3,1) temperature types
- **All Optimizations**: Explicit schema, compiler tuning, parallelism, PGO-ready
- **Tests**: Unit tests passing with correctness validation
- **Sample Data**: Included for immediate testing

### Available Executable

The project builds a single optimized executable:

- **`onebrc-datafusion`**: Uses Float64 for temperature values for optimal performance

## Quick Start

### Prerequisites

- Rust 1.70+ with Cargo
- LLVM tools (for PGO): `rustup component add llvm-tools-preview`
- hyperfine (for benchmarking): `cargo install hyperfine`
- cargo-flamegraph (for profiling, optional): `cargo install flamegraph`

### Basic Build and Run

```bash
# Clone and setup
git clone <repository-url>
cd 1brc-datafusion-rs

# Using the build script (recommended)
./build.sh release      # For optimized build (default)
# OR
./build.sh debug        # For fast debug build

# Run tests to verify correctness
cargo test

# Run test script (includes measurements_1k.txt testing)
./test.sh                       # Quick mode (default)
./test.sh full                  # Includes performance tests with measurements_1k.txt

# Manual build (alternative)
cargo build --release          # RUSTFLAGS configured in Cargo.toml

# Run on your dataset
./target/release/onebrc-datafusion path/to/measurements.txt results.csv

# Quick test with sample data
./target/release/onebrc-datafusion sample_measurements.txt results.csv
```

### Generate Test Data

Use the official 1BRC Java utility to generate test datasets:

```bash
# Clone official 1BRC repository
git clone https://github.com/gunnarmorling/1brc.git
cd 1brc

# Generate full 1-billion-row dataset (~13-14 GB)
./create_measurements.sh 1000000000

# Generate smaller sample for development (10M rows)
./create_measurements.sh 10000000
```

## Performance Optimization Journey

### 1. Baseline Implementation

Simple DataFrame API usage with schema inference:

```rust
let df = ctx.read_csv(file_path, CsvReadOptions::new()
    .has_header(false)
    .delimiter(b';')).await?;
```

**Problem**: Schema inference requires reading and parsing sample data, causing massive overhead.

### 2. Explicit Schema Definition

Provide exact schema to eliminate inference:

```rust
let schema = Arc::new(Schema::new(vec![
    Field::new("station", DataType::Utf8, false),
    Field::new("temperature", DataType::Float64, false),
]));

let df = ctx.read_csv(file_path, CsvReadOptions::new()
    .schema(&schema)
    .has_header(false)
    .delimiter(b';')).await?;
```

**Impact**: Single largest performance gain by providing perfect type information.

### 3. Compiler Optimizations

Aggressive Cargo.toml settings and native CPU targeting:

```toml
[profile.release]
opt-level = 3          # Maximum optimization level
lto = "fat"           # Aggressive link-time optimization
codegen-units = 1     # Single codegen unit for global optimization
panic = "abort"       # Remove unwinding overhead
strip = "symbols"     # Smaller binary size
```

```toml
[build]
rustflags = ["-C", "target-cpu=native"]
```

Now simply build with:

```bash
cargo build --release
```

**Impact**: Enables SIMD instructions and aggressive inlining across crate boundaries.

### 4. DataFusion Engine Tuning

Configure parallelism to match hardware:

```rust
let config = SessionConfig::new()
    .with_target_partitions(num_cpus::get());
let ctx = SessionContext::new_with_config(config);
```

**Impact**: Full utilization of multi-core CPU for parallel scan and aggregation.

### 5. Profile-Guided Optimization

Use runtime profiling data for final optimization:

```bash
# Build instrumented binary
RUSTFLAGS="-Cprofile-generate=/tmp/pgo-data" cargo build --release

# Generate profile data
./target/release/onebrc-datafusion-double sample_data.txt results.csv

# Merge profiles
llvm-profdata merge -o /tmp/pgo-data/merged.profdata /tmp/pgo-data

# Build PGO-optimized binary
RUSTFLAGS="-Cprofile-use=/tmp/pgo-data/merged.profdata" cargo build --release
```

**Impact**: Compiler optimizes hot paths based on actual execution patterns.

## Benchmarking

### Recommended Approach

Use a two-tiered benchmarking strategy:

1. **Development**: 10M row samples for rapid iteration
2. **Validation**: Full 1B row dataset for official measurements

```bash
# Comprehensive benchmark with the included script (recommended)
./benchmark.sh

# Generate flamegraphs for performance profiling
./benchmark.sh --flamegraph

# Quick development benchmark
hyperfine --warmup 3 './target/release/onebrc-datafusion sample_10M.txt sample_results.csv'

# Official benchmark (manual)
hyperfine --warmup 3 './target/release/onebrc-datafusion ../test_data/measurements_1b.txt results.csv'

# Test with included sample
hyperfine --warmup 3 './target/release/onebrc-datafusion sample_measurements.txt results.csv'
```

### Performance Results

**Latest Benchmark Results (with PGO)**:
- **Mean Time**: 4.902 seconds ± 0.097s
- **Range**: 4.794s - 5.055s (10 runs)
- **Throughput**: 2.61 GB/s
- **Processing Rate**: 204,004,146 rows/s

See the [main README.md](../../README.md) for consolidated performance benchmarks.


## Project Structure

```
1brc-datafusion-rs/
├── src/
│   └── main.rs                                    # Main implementation with tests
├── Cargo.toml                                     # Dependencies and release profile
├── sample_measurements.txt                        # Sample test data
├── README.md                                      # This file
├── CLAUDE.md                                      # Claude Code guidance
├── datafusion_1brc_rs_implementation_guide.txt    # Detailed implementation guide
```

## Implementation Details

### Core Dependencies

```toml
[dependencies]
datafusion = "42.0.0"                   # Query engine
tokio = { version = "1", features = ["rt-multi-thread", "macros"] }
num_cpus = "1.16.0"                     # CPU detection

[dev-dependencies]
tempfile = "3.8.0"                      # For testing
```

### Data Processing Flow

1. **SessionContext Configuration**: Set optimal parallelism
2. **Schema Definition**: Explicit types (station: Utf8, temperature: Float64)
3. **CSV Reading**: Configured for semicolon delimiter, no header
4. **Aggregation**: GROUP BY station with MIN, AVG, MAX temperature
5. **Sorting**: Alphabetical order by station name
6. **Collection**: Materialize results

### Testing Strategy

```rust
#[tokio::test]
async fn test_1brc_logic() -> Result<()> {
    let test_data = "Hamburg;12.0\nBulawayo;8.9\nPalembang;38.8";
    // ... test implementation validates correctness on small dataset
}
```

Run tests with: `cargo test`

## Advanced Usage

### Profile-Guided Optimization (PGO)

For maximum performance, use PGO with representative workload:

```bash
# Complete PGO workflow
mkdir -p /tmp/pgo-data
RUSTFLAGS="-Cprofile-generate=/tmp/pgo-data" cargo build --release
./target/release/onebrc-datafusion-double sample_measurements.txt results.csv
LLVM_PROFDATA_PATH=$(find ~/.rustup -name "llvm-profdata" | head -n 1)
$LLVM_PROFDATA_PATH merge -o /tmp/pgo-data/merged.profdata /tmp/pgo-data
RUSTFLAGS="-Cprofile-use=/tmp/pgo-data/merged.profdata" cargo build --release
```

### Custom Configuration

Tune DataFusion settings for your hardware:

```rust
let config = SessionConfig::new()
    .with_target_partitions(num_cpus::get_physical())  // Use physical cores
    .with_batch_size(8192)                             // Default is optimal
    .with_coalesce_batches(true);                      // Enable batch merging
```

## Performance Analysis

### Flamegraph Profiling

Generate interactive flamegraphs to visualize CPU time distribution:

```bash
# Generate flamegraphs for both executables
./benchmark.sh --flamegraph

# Manual flamegraph generation
cargo install flamegraph
CARGO_PROFILE_RELEASE_DEBUG=true cargo flamegraph \
    --bin=onebrc-datafusion \
    --release \
    --output=flamegraph.svg \
    -- path/to/measurements.txt results.csv
```

**Prerequisites for flamegraphs:**
- Install flamegraph: `cargo install flamegraph`
- On Linux: May require `echo -1 | sudo tee /proc/sys/kernel/perf_event_paranoid`
- Debug symbols: Set `CARGO_PROFILE_RELEASE_DEBUG=true` or use release profile with `debug = true`

Open generated `.svg` files in a browser for interactive exploration of performance hotspots.

### Why This Approach Works

1. **Schema Elimination**: Removing type inference eliminates the largest overhead
2. **Compiler Optimization**: Modern LLVM can generate highly efficient SIMD code
3. **Parallelism**: Multi-core scaling transforms the problem from CPU-bound to memory-bandwidth-bound
4. **Runtime Optimization**: PGO provides final tuning based on actual execution patterns

### Limitations

- **API Constraint**: Limited by DataFusion's generic CSV parser
- **Memory Usage**: Higher memory footprint than specialized parsers
- **Compilation Time**: Aggressive optimizations increase build time

### Future Improvements

- **Custom TableProvider**: Implement specialized parser within DataFusion framework
- **User-Defined Functions**: Optimize specific operations with custom UDFs
- **Memory Management**: Tune Arrow memory pools for this workload

## Contributing

1. **Performance Improvements**: Always benchmark against current best
2. **Testing**: Maintain correctness tests for any changes
3. **Documentation**: Update performance analysis for new optimizations

## Acknowledgments

- [One Billion Row Challenge](https://github.com/gunnarmorling/1brc) by Gunnar Morling
- [Apache DataFusion](https://github.com/apache/arrow-datafusion) team
- Rust community for excellent tooling and optimization capabilities

