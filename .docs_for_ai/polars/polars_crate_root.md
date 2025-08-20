     

[](../polars/all.html)

:::::::::::::: section

# Crate polarsCopy item path

[Settings](../settings.html)

[Help](../help.html)

Summary

[Source](../src/polars/lib.rs.html#1-434)

Expand description

## [§](#polars-dataframes-in-rust)Polars: *[DataFrames in Rust]{.small}*

Polars is a DataFrame library for Rust. It is based on [Apache
Arrow](https://arrow.apache.org/)'s memory model. Apache Arrow provides
very cache efficient columnar data structures and is becoming the
de-facto standard for columnar data.

### [§](#quickstart)Quickstart

We recommend building queries directly with
[polars-lazy](https://docs.rs/polars-lazy/0.50.0/x86_64-unknown-linux-gnu/polars_lazy/index.html).
This allows you to combine expressions into powerful aggregations and
column selections. All expressions are evaluated in parallel and queries
are optimized just in time.

    use polars::prelude::*;

    let lf1 = LazyFrame::scan_parquet("myfile_1.parquet", Default::default())?
        .group_by([col("ham")])
        .agg([
            // expressions can be combined into powerful aggregations
            col("foo")
                .sort_by([col("ham").rank(Default::default(), None)], SortMultipleOptions::default())
                .last()
                .alias("last_foo_ranked_by_ham"),
            // every expression runs in parallel
            col("foo").cum_min(false).alias("cumulative_min_per_group"),
            // every expression runs in parallel
            col("foo").reverse().implode().alias("reverse_group"),
        ]);

    let lf2 = LazyFrame::scan_parquet("myfile_2.parquet", Default::default())?
        .select([col("ham"), col("spam")]);

    let df = lf1
        .join(lf2, [col("reverse")], [col("foo")], JoinArgs::new(JoinType::Left))
        // now we finally materialize the result.
        .collect()?;

This means that Polars data structures can be shared zero copy with
processes in many different languages.

### [§](#tree-of-contents)Tree Of Contents

-   [Cookbooks](#cookbooks)
-   [Data structures](#data-structures)
    -   [DataFrame](#dataframe)
    -   [Series](#series)
    -   [ChunkedArray](#chunkedarray)
-   [SIMD](#simd)
-   [API](#api)
-   [Expressions](#expressions)
-   [Compile times](#compile-times)
-   [Performance](#performance-and-string-data)
    -   [Custom allocator](#custom-allocator)
-   [Config](#config-with-env-vars)
-   [User guide](#user-guide)

### [§](#cookbooks)Cookbooks

See examples in the cookbooks:

-   [Eager](docs/eager/index.html)
-   [Lazy](docs/lazy/index.html)

### [§](#data-structures)Data Structures

The base data structures provided by polars are
[`DataFrame`](prelude/struct.DataFrame.html),
[`Series`](prelude/struct.Series.html), and
[`ChunkedArray<T>`](prelude/struct.ChunkedArray.html). We will provide a
short, top-down view of these data structures.

#### [§](#dataframe)DataFrame

A [`DataFrame`](prelude/struct.DataFrame.html) is a two-dimensional data
structure backed by a [`Series`](prelude/struct.Series.html) and can be
seen as an abstraction on
[`Vec<Series>`](https://doc.rust-lang.org/nightly/alloc/vec/struct.Vec.html).
Operations that can be executed on a
[`DataFrame`](prelude/struct.DataFrame.html) are similar to what is done
in a `SQL` like query. You can `GROUP`, `JOIN`, `PIVOT` etc.

#### [§](#series)Series

[`Series`](prelude/struct.Series.html) are the type-agnostic columnar
data representation of Polars. The
[`Series`](prelude/struct.Series.html) struct and
[`SeriesTrait`](prelude/trait.SeriesTrait.html) trait provide many
operations out of the box. Most type-agnostic operations are provided by
[`Series`](prelude/struct.Series.html). Type-aware operations require
downcasting to the typed data structure that is wrapped by the
[`Series`](prelude/struct.Series.html). The underlying typed data
structure is a [`ChunkedArray<T>`](prelude/struct.ChunkedArray.html).

#### [§](#chunkedarray)ChunkedArray

[`ChunkedArray<T>`](prelude/struct.ChunkedArray.html) are wrappers
around an arrow array, that can contain multiples chunks, e.g.
[`Vec<dyn ArrowArray>`](https://doc.rust-lang.org/nightly/alloc/vec/struct.Vec.html).
These are the root data structures of Polars, and implement many
operations. Most operations are implemented by traits defined in
[chunked_array::ops](chunked_array/ops/index.html), or on the
[`ChunkedArray`](prelude/struct.ChunkedArray.html) struct.

### [§](#simd)SIMD

Polars / Arrow uses packed_simd to speed up kernels with SIMD
operations. SIMD is an optional `feature = "nightly"`, and requires a
nightly compiler. If you don't need SIMD, **Polars runs on stable!**

### [§](#api)API

Polars supports an eager and a lazy API. The eager API directly yields
results, but is overall more verbose and less capable of building
elegant composite queries. We recommend to use the Lazy API whenever you
can.

As neither API is async they should be wrapped in *spawn_blocking* when
used in an async context to avoid blocking the async thread pool of the
runtime.

### [§](#expressions)Expressions

Polars has a powerful concept called expressions. Polars expressions can
be used in various contexts and are a functional mapping of
`Fn(Series) -> Series`, meaning that they have
[`Series`](prelude/struct.Series.html) as input and
[`Series`](prelude/struct.Series.html) as output. By looking at this
functional definition, we can see that the output of an
[`Expr`](prelude/enum.Expr.html) also can serve as the input of an
[`Expr`](prelude/enum.Expr.html).

That may sound a bit strange, so lets give an example. The following is
an expression:

`col("foo").sort().head(2)`

The snippet above says select column `"foo"` then sort this column and
then take the first 2 values of the sorted output. The power of
expressions is that every expression produces a new expression and that
they can be piped together. You can run an expression by passing them on
one of polars execution contexts. Here we run two expressions in the
**select** context:

      df.lazy()
       .select([
           col("foo").sort(Default::default()).head(None),
           col("bar").filter(col("foo").eq(lit(1))).sum(),
       ])
       .collect()?;

All expressions are run in parallel, meaning that separate polars
expressions are embarrassingly parallel. (Note that within an expression
there may be more parallelization going on).

Understanding Polars expressions is most important when starting with
the Polars library. Read more about them in the [user
guide](https://docs.pola.rs/user-guide/expressions).

#### [§](#eager)Eager

Read more in the pages of the following data structures /traits.

-   [DataFrame struct](prelude/struct.DataFrame.html)
-   [Series struct](prelude/struct.Series.html)
-   [Series trait](prelude/trait.SeriesTrait.html)
-   [ChunkedArray struct](prelude/struct.ChunkedArray.html)
-   [ChunkedArray operations traits](chunked_array/ops/index.html)

#### [§](#lazy)Lazy

Unlock full potential with lazy computation. This allows query
optimizations and provides Polars the full query context so that the
fastest algorithm can be chosen.

**[Read more in the lazy
module.](https://docs.rs/polars-lazy/0.50.0/x86_64-unknown-linux-gnu/polars_lazy/index.html)**

### [§](#compile-times)Compile times

A DataFrame library typically consists of

-   Tons of features
-   A lot of datatypes

Both of these really put strain on compile times. To keep Polars lean,
we make both **opt-in**, meaning that you only pay the compilation cost
if you need it.

### [§](#compile-times-and-opt-in-features)Compile times and opt-in features

The opt-in features are (not including dtype features):

-   `lazy` - Lazy API
    -   `regex` - Use regexes in [column selection](prelude/fn.col.html)
    -   `dot_diagram` - Create dot diagrams from lazy logical plans.
-   `sql` - Pass SQL queries to Polars.
-   `random` - Generate arrays with randomly sampled values
-   `ndarray`- Convert from [`DataFrame`](prelude/struct.DataFrame.html)
    to [ndarray](https://docs.rs/ndarray/)
-   `temporal` - Conversions between [Chrono](https://docs.rs/chrono/)
    and Polars for temporal data types
-   `timezones` - Activate timezone support.
-   `strings` - Extra string utilities for
    [`StringChunked`](prelude/type.StringChunked.html)
    -   `string_pad` - `zfill`, `ljust`, `rjust`
    -   `string_to_integer` - `parse_int`
-   `object` - Support for generic ChunkedArrays called
    [`ObjectChunked<T>`](prelude/type.ObjectChunked.html) (generic over
    `T`). These are downcastable from Series through the
    [Any](https://doc.rust-lang.org/std/any/index.html) trait.
-   Performance related:
    -   `nightly` - Several nightly only features such as SIMD and
        specialization.
    -   `performant` - more fast paths, slower compile times.
    -   `bigidx` - Activate this feature if you expect >> 2^32 rows.
        This is rarely needed. This allows Polars to scale up beyond
        2^32 rows by using an index with a `u64` data type. Polars will
        be a bit slower with this feature activated as many data
        structures are less cache efficient.
    -   `cse` - Activate common subplan elimination optimization
-   IO related:
    -   `serde` - Support for [serde](https://crates.io/crates/serde)
        serialization and deserialization. Can be used for JSON and more
        serde supported serialization formats.
    -   `serde-lazy` - Support for
        [serde](https://crates.io/crates/serde) serialization and
        deserialization. Can be used for JSON and more serde supported
        serialization formats.
    -   `parquet` - Read Apache Parquet format
    -   `json` - JSON serialization
    -   `ipc` - Arrow's IPC format serialization
    -   `decompress` - Automatically infer compression of csvs and
        decompress them. Supported compressions:
        -   gzip
        -   zlib
        -   zstd

<!-- -->

-   [`DataFrame`](prelude/struct.DataFrame.html) operations:
    -   `dynamic_group_by` - Groupby based on a time window instead of
        predefined keys. Also activates rolling window group by
        operations.
    -   `sort_multiple` - Allow sorting a
        [`DataFrame`](prelude/struct.DataFrame.html) on multiple columns
    -   `rows` - Create [`DataFrame`](prelude/struct.DataFrame.html)
        from rows and extract rows from
        [`DataFrame`](prelude/struct.DataFrame.html)s. Also activates
        `pivot` and `transpose` operations
    -   `asof_join` - Join ASOF, to join on nearest keys instead of
        exact equality match.
    -   `cross_join` - Create the Cartesian product of two
        [`DataFrame`](prelude/struct.DataFrame.html)s.
    -   `semi_anti_join` - SEMI and ANTI joins.
    -   `row_hash` - Utility to hash
        [`DataFrame`](prelude/struct.DataFrame.html) rows to
        [`UInt64Chunked`](prelude/type.UInt64Chunked.html)
    -   `diagonal_concat` - Concat diagonally thereby combining
        different schemas.
    -   `dataframe_arithmetic` - Arithmetic on
        ([`Dataframe`](prelude/struct.DataFrame.html) and
        [`DataFrame`](prelude/struct.DataFrame.html)s) and
        ([`DataFrame`](prelude/struct.DataFrame.html) on
        [`Series`](prelude/struct.Series.html))
    -   `partition_by` - Split into multiple
        [`DataFrame`](prelude/struct.DataFrame.html)s partitioned by
        groups.
-   [`Series`](prelude/struct.Series.html)/[`Expr`](prelude/enum.Expr.html)
    operations:
    -   `is_in` - Check for membership in
        [`Series`](prelude/struct.Series.html).
    -   `zip_with` - [Zip two Series/
        ChunkedArrays](prelude/trait.ChunkZip.html).
    -   `round_series` - Round underlying float types of
        [`Series`](prelude/struct.Series.html).
    -   `repeat_by` - Repeat element in an Array N times, where N is
        given by another array.
    -   `is_first_distinct` - Check if element is first unique value.
    -   `is_last_distinct` - Check if element is last unique value.
    -   `is_between` - Check if this expression is between the given
        lower and upper bounds.
    -   `checked_arithmetic` - checked arithmetic/ returning
        [`None`](https://doc.rust-lang.org/nightly/core/option/enum.Option.html#variant.None)
        on invalid operations.
    -   `dot_product` - Dot/inner product on
        [`Series`](prelude/struct.Series.html) and
        [`Expr`](prelude/enum.Expr.html).
    -   `concat_str` - Concat string data in linear time.
    -   `reinterpret` - Utility to reinterpret bits to signed/unsigned
    -   `take_opt_iter` - Take from a
        [`Series`](prelude/struct.Series.html) with
        [`Iterator<Item=Option<usize>>`](https://doc.rust-lang.org/nightly/core/iter/traits/iterator/trait.Iterator.html).
    -   `mode` - [Return the most occurring
        value(s)](prelude/mode/index.html)
    -   `cum_agg` - [`cum_sum`](prelude/fn.cum_sum.html),
        [`cum_min`](prelude/fn.cum_min.html),
        [`cum_max`](prelude/fn.cum_max.html) aggregation.
    -   `rolling_window` - rolling window functions, like
        [`rolling_mean`](prelude/struct.Series.html#method.rolling_mean)
    -   `interpolate` - [interpolate None
        values](prelude/fn.interpolate.html)
    -   `extract_jsonpath` - [Run jsonpath queries on
        StringChunked](https://goessner.net/articles/JsonPath/)
    -   `list` - List utils.
        -   `list_gather` take sublist by multiple indices
    -   `rank` - Ranking algorithms.
    -   `moment` - Kurtosis and skew statistics
    -   `ewma` - Exponential moving average windows
    -   `abs` - Get absolute values of
        [`Series`](prelude/struct.Series.html).
    -   `arange` - Range operation on
        [`Series`](prelude/struct.Series.html).
    -   `product` - Compute the product of a
        [`Series`](prelude/struct.Series.html).
    -   `diff` - [`diff`](prelude/fn.diff.html) operation.
    -   `pct_change` - Compute change percentages.
    -   `unique_counts` - Count unique values in expressions.
    -   `log` - Logarithms for [`Series`](prelude/struct.Series.html).
    -   `list_to_struct` - Convert
        [`List`](prelude/enum.DataType.html#variant.List) to
        [`Struct`](prelude/enum.DataType.html#variant.Struct) dtypes.
    -   `list_count` - Count elements in lists.
    -   `list_eval` - Apply expressions over list elements.
    -   `list_sets` - Compute UNION, INTERSECTION, and DIFFERENCE on
        list types.
    -   `cumulative_eval` - Apply expressions over cumulatively
        increasing windows.
    -   `arg_where` - Get indices where condition holds.
    -   `search_sorted` - Find indices where elements should be inserted
        to maintain order.
    -   `offset_by` - Add an offset to dates that take months and leap
        years into account.
    -   `trigonometry` - Trigonometric functions.
    -   `sign` - Compute the element-wise sign of a
        [`Series`](prelude/struct.Series.html).
    -   `propagate_nans` - NaN propagating min/max aggregations.
    -   `extract_groups` - Extract multiple regex groups from strings.
    -   `cov` - Covariance and correlation functions.
    -   `find_many` - Find/replace multiple string patterns at once.
-   [`DataFrame`](prelude/struct.DataFrame.html) pretty printing
    -   `fmt` - Activate [`DataFrame`](prelude/struct.DataFrame.html)
        formatting

### [§](#compile-times-and-opt-in-data-types)Compile times and opt-in data types

As mentioned above, Polars [`Series`](prelude/struct.Series.html) are
wrappers around [`ChunkedArray<T>`](prelude/struct.ChunkedArray.html)
without the generic parameter `T`. To get rid of the generic parameter,
all the possible values of `T` are compiled for
[`Series`](prelude/struct.Series.html). This gets more expensive the
more types you want for a [`Series`](prelude/struct.Series.html). In
order to reduce the compile times, we have decided to default to a
minimal set of types and make more
[`Series`](prelude/struct.Series.html) types opt-in.

Note that if you get strange compile time errors, you probably need to
opt-in for that [`Series`](prelude/struct.Series.html) dtype. The opt-in
dtypes are:

  data type     feature flag
  ------------- -------------------
  Date          dtype-date
  Datetime      dtype-datetime
  Time          dtype-time
  Duration      dtype-duration
  Int8          dtype-i8
  Int16         dtype-i16
  UInt8         dtype-u8
  UInt16        dtype-u16
  Categorical   dtype-categorical
  Struct        dtype-struct

Or you can choose one of the preconfigured pre-sets.

-   `dtype-full` - all opt-in dtypes.
-   `dtype-slim` - slim preset of opt-in dtypes.

### [§](#performance)Performance

To get the best performance out of Polars we recommend compiling on a
nightly compiler with the features `simd` and `performant` activated.
The activated cpu features also influence the amount of simd
acceleration we can use.

See the features we activate for our python builds, or if you just run
locally and want to use all available features on your cpu, set
`RUSTFLAGS='-C target-cpu=native'`.

#### [§](#custom-allocator)Custom allocator

An OLAP query engine does a lot of heap allocations. It is recommended
to use a custom allocator, (we have found this to have up to ~25%
runtime influence).
[JeMalloc](https://crates.io/crates/tikv-jemallocator) and
[Mimalloc](https://crates.io/crates/mimalloc) for instance, show a
significant performance gain in runtime as well as memory usage.

##### [§](#jemalloc-usage)Jemalloc Usage

[ⓘ](#)

    use tikv_jemallocator::Jemalloc;

    #[global_allocator]
    static GLOBAL: Jemalloc = Jemalloc;

##### [§](#cargotoml)Cargo.toml

    [dependencies]
    tikv_jemallocator = { version = "*" }

##### [§](#mimalloc-usage)Mimalloc Usage

[ⓘ](#)

    use mimalloc::MiMalloc;

    #[global_allocator]
    static GLOBAL: MiMalloc = MiMalloc;

##### [§](#cargotoml-1)Cargo.toml

    [dependencies]
    mimalloc = { version = "*", default-features = false }

##### [§](#notes)Notes

[Benchmarks](https://github.com/pola-rs/polars/pull/3108) have shown
that on Linux and macOS JeMalloc outperforms Mimalloc on all tasks and
is therefore the default allocator used for the Python bindings on Unix
platforms.

### [§](#config-with-env-vars)Config with ENV vars

-   `POLARS_FMT_TABLE_FORMATTING` -> define styling of tables using any
    of the following options (default = UTF8_FULL_CONDENSED). These
    options are defined by comfy-table which provides examples for each
    at
    <https://github.com/Nukesor/comfy-table/blob/main/src/style/presets.rs>
    -   `ASCII_FULL`
    -   `ASCII_FULL_CONDENSED`
    -   `ASCII_NO_BORDERS`
    -   `ASCII_BORDERS_ONLY`
    -   `ASCII_BORDERS_ONLY_CONDENSED`
    -   `ASCII_HORIZONTAL_ONLY`
    -   `ASCII_MARKDOWN`
    -   `MARKDOWN`
    -   `UTF8_FULL`
    -   `UTF8_FULL_CONDENSED`
    -   `UTF8_NO_BORDERS`
    -   `UTF8_BORDERS_ONLY`
    -   `UTF8_HORIZONTAL_ONLY`
    -   `NOTHING`
-   `POLARS_FMT_TABLE_CELL_ALIGNMENT` -> define cell alignment using
    any of the following options (default = LEFT):
    -   `LEFT`
    -   `CENTER`
    -   `RIGHT`
-   `POLARS_FMT_TABLE_DATAFRAME_SHAPE_BELOW` -> print shape information
    below the table.
-   `POLARS_FMT_TABLE_HIDE_COLUMN_NAMES` -> hide table column names.
-   `POLARS_FMT_TABLE_HIDE_COLUMN_DATA_TYPES` -> hide data types for
    columns.
-   `POLARS_FMT_TABLE_HIDE_COLUMN_SEPARATOR` -> hide separator that
    separates column names from rows.
-   `POLARS_FMT_TABLE_HIDE_DATAFRAME_SHAPE_INFORMATION"` -> omit table
    shape information.
-   `POLARS_FMT_TABLE_INLINE_COLUMN_DATA_TYPE` -> put column data type
    on the same line as the column name.
-   `POLARS_FMT_TABLE_ROUNDED_CORNERS` -> apply rounded corners to
    UTF8-styled tables.
-   `POLARS_FMT_MAX_COLS` -> maximum number of columns shown when
    formatting DataFrames.
-   `POLARS_FMT_MAX_ROWS` -> maximum number of rows shown when
    formatting DataFrames, `-1` to show all.
-   `POLARS_FMT_STR_LEN` -> maximum number of characters printed per
    string value.
-   `POLARS_TABLE_WIDTH` -> width of the tables used during DataFrame
    formatting.
-   `POLARS_MAX_THREADS` -> maximum number of threads used to
    initialize thread pool (on startup).
-   `POLARS_VERBOSE` -> print logging info to stderr.
-   `POLARS_NO_PARTITION` -> polars may choose to partition the
    group_by operation, based on data cardinality. Setting this env var
    will turn partitioned group_by's off.
-   `POLARS_PARTITION_UNIQUE_COUNT` -> at which (estimated) key count a
    partitioned group_by should run. defaults to `1000`, any higher
    cardinality will run default group_by.
-   `POLARS_FORCE_PARTITION` -> force partitioned group_by if the keys
    and aggregations allow it.
-   `POLARS_ALLOW_EXTENSION` -> allows for
    [`ObjectChunked<T>`](prelude/type.ObjectChunked.html) to be used in
    arrow, opening up possibilities like using `T` in complex lazy
    expressions. However this does require `unsafe` code allow this.
-   `POLARS_NO_PARQUET_STATISTICS` -> if set, statistics in parquet
    files are ignored.
-   `POLARS_PANIC_ON_ERR` -> panic instead of returning an Error.
-   `POLARS_BACKTRACE_IN_ERR` -> include a Rust backtrace in Error
    messages.
-   `POLARS_NO_CHUNKED_JOIN` -> force rechunk before joins.

### [§](#user-guide)User guide

If you want to read more, check the [user guide](https://docs.pola.rs/).

## Re-exports[§](#reexports)

`pub use `[`polars_io`](https://docs.rs/polars-io/0.50.0/x86_64-unknown-linux-gnu/polars_io/index.html)` as io;``polars-io`

`pub use `[`polars_lazy`](https://docs.rs/polars-lazy/0.50.0/x86_64-unknown-linux-gnu/polars_lazy/index.html)` as lazy;``lazy`

`pub use `[`polars_time`](https://docs.rs/polars-time/0.50.0/x86_64-unknown-linux-gnu/polars_time/index.html)` as time;``temporal`

## Modules[§](#modules)

[chunked_array](chunked_array/index.html)
:   The typed heart of every Series column.

[datatypes](datatypes/index.html)
:   Data types supported by Polars.

[docs](docs/index.html)\
[error](error/index.html)\
[frame](frame/index.html)
:   DataFrame module.

[functions](functions/index.html)
:   Functions

[prelude](prelude/index.html)\
[series](series/index.html)
:   Type agnostic columnar data structure.

[testing](testing/index.html)
:   Testing utilities.

## Macros[§](#macros)

[apply_method_all_arrow_series](macro.apply_method_all_arrow_series.html)

[df](macro.df.html)

## Constants[§](#constants)

[VERSION](constant.VERSION.html)
:   Polars crate version
::::::::::::::
