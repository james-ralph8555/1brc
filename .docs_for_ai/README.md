# AI Coding Agent Documentation Library

This directory, `.docs_for_ai/`, serves as a local documentation library for AI coding agents working on the One Billion Row Challenge (1BRC) implementations.

## Purpose

The primary purpose of this directory is to store documentation pages that are fetched for reference by AI agents. This allows agents to have quick, local access to relevant documentation, improving their performance and accuracy when making code changes to the 1BRC implementations.

## Project Context

This documentation library supports the 1BRC project, which contains multiple implementations:
- **1brc-duckdb-cpp/**: C++ implementation using DuckDB analytical database
- **1brc-datafusion-rs/**: Rust implementation using Apache DataFusion query engine

Both implementations use a **query engine approach** with SQL-based processing rather than custom data parsing.

## Available Documentation

### Core Technologies
- **`datafusion/`**: Apache DataFusion query engine documentation
  - `building-logical-plans.md`: Creating custom logical plans
  - `dataframe.md`: DataFrame API usage
  - `data_types.md`: Supported data types and schemas
  - `profiling.md`: Performance profiling and optimization
  - `using-the-dataframe-api.md`: API reference

- **`duckdb/`**: DuckDB analytical database documentation
  - `clients/cpp.md`: C++ client library usage
  - `csv-export.md`: CSV export functionality
  - `csv-overview.md`: CSV reading and processing

- **`arrow/`**: Apache Arrow format documentation
  - `cpp/`: C++ Arrow library docs
  - `python/`: Python Arrow bindings

- **`polars/`**: Polars DataFrame library documentation
  - Complete API reference for potential alternative implementations

## Key Implementation Guidance

### For DataFusion (Rust) Changes
- Reference `datafusion/data_types.md` for schema definitions
- Use `datafusion/profiling.md` for performance optimization
- Check `datafusion/dataframe.md` for API patterns

### For DuckDB (C++) Changes  
- Reference `duckdb/clients/cpp.md` for C++ integration
- Use `duckdb/csv-overview.md` for CSV processing optimization
- Check `duckdb/csv-export.md` for output formatting

### Performance Considerations
- Both implementations target **sub-10 second** processing of 1 billion rows
- Focus on query engine configuration rather than custom parsing code
- Leverage multi-core parallelization and vectorized operations

## Versioning and Maintenance

- **Single Version:** Only one version of the documentation for a specific tool should be present at any given time.
- **Keep Current:** Documentation should match the versions used in the project implementations.
- **Project Alignment:** When updating implementations, refresh corresponding documentation to match.

By following these guidelines, AI agents can efficiently navigate the available documentation to make informed decisions about the 1BRC implementations.
