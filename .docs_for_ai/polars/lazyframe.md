-   [](../../index.html)
-   [Python API reference](../index.html)
-   LazyFrame

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: section
# LazyFrame[#](#lazyframe)

This page gives an overview of all public LazyFrame methods.

*class *polars.LazyFrame(

*data: FrameInitTypes |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*schema: SchemaDefinition |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*\**,

*schema_overrides: SchemaDict |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*strict: [bool](https://docs.python.org/3/library/functions.html#bool) =
True*,

*orient: Orientation |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*infer_schema_length:
[int](https://docs.python.org/3/library/functions.html#int) |
[None](https://docs.python.org/3/library/constants.html#None) = 100*,

*nan_to_null:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

)[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L238-L8241)

Representation of a Lazy computation graph/query against a DataFrame.

This allows for whole-query optimisation in addition to parallelism, and
is the preferred (and highest-performance) mode of operation for polars.

Parameters:

:   

    **data**dict, Sequence, ndarray, Series, or pandas.DataFrame

    :   Two-dimensional data in various forms; dict input must contain
        Sequences, Generators, or a `range`. Sequence may contain Series
        or other Sequences.

    **schema**Sequence of str, (str,DataType) pairs, or a {str:DataType,} dict

    :   The LazyFrame schema may be declared in several ways:

        -   As a dict of {name:type} pairs; if type is None, it will be
            auto-inferred.

        -   As a list of column names; in this case types are
            automatically inferred.

        -   As a list of (name,type) pairs; this is equivalent to the
            dictionary form.

        If you supply a list of column names that does not match the
        names in the underlying data, the names given here will
        overwrite them. The number of names given in the schema should
        match the underlying data dimensions.

    **schema_overrides**dict, default None

    :   Support type specification or override of one or more columns;
        note that any dtypes inferred from the schema param will be
        overridden.

        The number of entries in the schema should match the underlying
        data dimensions, unless a sequence of dictionaries is being
        passed, in which case a *partial* schema can be declared to
        prevent specific fields from being loaded.

    **strict**bool, default True

    :   Throw an error if any `data` value does not exactly match the
        given or inferred data type for that column. If set to `False`,
        values that do not match the data type are cast to that data
        type or, if casting is not possible, set to null instead.

    **orient**{'col', 'row'}, default None

    :   Whether to interpret two-dimensional data as columns or as rows.
        If None, the orientation is inferred by matching the columns and
        data dimensions. If this does not yield conclusive results,
        column orientation is used.

    **infer_schema_length**int or None

    :   The maximum number of rows to scan for schema inference. If set
        to `None`, the full data may be scanned *(this can be slow)*.
        This parameter only applies if the input data is a sequence or
        generator of rows; other input is read as-is.

    **nan_to_null**bool, default False

    :   If the data comes from one or more numpy arrays, can optionally
        convert input data np.nan values to null instead. This is a
        no-op for all other input data.

Notes

Initialising `LazyFrame(...)` directly is equivalent to
`DataFrame(...).lazy()`.

**Methods:**

  ---------------------------------------------------------------------------------------------------- ----------------------------------------------------------------------------------
  [`approx_n_unique`](api/polars.LazyFrame.approx_n_unique.html#polars.LazyFrame.approx_n_unique)      Approximate count of unique values.
  [`bottom_k`](api/polars.LazyFrame.bottom_k.html#polars.LazyFrame.bottom_k)                           Return the `k` smallest rows.
  [`cache`](api/polars.LazyFrame.cache.html#polars.LazyFrame.cache)                                    Cache the result once the execution of the physical plan hits this node.
  [`cast`](api/polars.LazyFrame.cast.html#polars.LazyFrame.cast)                                       Cast LazyFrame column(s) to the specified dtype(s).
  [`clear`](api/polars.LazyFrame.clear.html#polars.LazyFrame.clear)                                    Create an empty copy of the current LazyFrame, with zero to \'n\' rows.
  [`clone`](api/polars.LazyFrame.clone.html#polars.LazyFrame.clone)                                    Create a copy of this LazyFrame.
  [`collect`](api/polars.LazyFrame.collect.html#polars.LazyFrame.collect)                              Materialize this LazyFrame into a DataFrame.
  [`collect_async`](api/polars.LazyFrame.collect_async.html#polars.LazyFrame.collect_async)            Collect DataFrame asynchronously in thread pool.
  [`collect_schema`](api/polars.LazyFrame.collect_schema.html#polars.LazyFrame.collect_schema)         Resolve the schema of this LazyFrame.
  [`count`](api/polars.LazyFrame.count.html#polars.LazyFrame.count)                                    Return the number of non-null elements for each column.
  [`describe`](api/polars.LazyFrame.describe.html#polars.LazyFrame.describe)                           Creates a summary of statistics for a LazyFrame, returning a DataFrame.
  [`deserialize`](api/polars.LazyFrame.deserialize.html#polars.LazyFrame.deserialize)                  Read a logical plan from a file to construct a LazyFrame.
  [`drop`](api/polars.LazyFrame.drop.html#polars.LazyFrame.drop)                                       Remove columns from the DataFrame.
  [`drop_nans`](api/polars.LazyFrame.drop_nans.html#polars.LazyFrame.drop_nans)                        Drop all rows that contain one or more NaN values.
  [`drop_nulls`](api/polars.LazyFrame.drop_nulls.html#polars.LazyFrame.drop_nulls)                     Drop all rows that contain one or more null values.
  [`explain`](api/polars.LazyFrame.explain.html#polars.LazyFrame.explain)                              Create a string representation of the query plan.
  [`explode`](api/polars.LazyFrame.explode.html#polars.LazyFrame.explode)                              Explode the DataFrame to long format by exploding the given columns.
  `fetch`                                                                                              Collect a small number of rows for debugging purposes.
  [`fill_nan`](api/polars.LazyFrame.fill_nan.html#polars.LazyFrame.fill_nan)                           Fill floating point NaN values.
  [`fill_null`](api/polars.LazyFrame.fill_null.html#polars.LazyFrame.fill_null)                        Fill null values using the specified value or strategy.
  [`filter`](api/polars.LazyFrame.filter.html#polars.LazyFrame.filter)                                 Filter rows in the LazyFrame based on a predicate expression.
  [`first`](api/polars.LazyFrame.first.html#polars.LazyFrame.first)                                    Get the first row of the DataFrame.
  [`gather_every`](api/polars.LazyFrame.gather_every.html#polars.LazyFrame.gather_every)               Take every nth row in the LazyFrame and return as a new LazyFrame.
  [`group_by`](api/polars.LazyFrame.group_by.html#polars.LazyFrame.group_by)                           Start a group by operation.
  [`group_by_dynamic`](api/polars.LazyFrame.group_by_dynamic.html#polars.LazyFrame.group_by_dynamic)   Group based on a time value (or index value of type Int32, Int64).
  [`head`](api/polars.LazyFrame.head.html#polars.LazyFrame.head)                                       Get the first `n` rows.
  [`inspect`](api/polars.LazyFrame.inspect.html#polars.LazyFrame.inspect)                              Inspect a node in the computation graph.
  [`interpolate`](api/polars.LazyFrame.interpolate.html#polars.LazyFrame.interpolate)                  Interpolate intermediate values.
  [`join`](api/polars.LazyFrame.join.html#polars.LazyFrame.join)                                       Add a join operation to the Logical Plan.
  [`join_asof`](api/polars.LazyFrame.join_asof.html#polars.LazyFrame.join_asof)                        Perform an asof join.
  [`join_where`](api/polars.LazyFrame.join_where.html#polars.LazyFrame.join_where)                     Perform a join based on one or multiple (in)equality predicates.
  [`last`](api/polars.LazyFrame.last.html#polars.LazyFrame.last)                                       Get the last row of the DataFrame.
  [`lazy`](api/polars.LazyFrame.lazy.html#polars.LazyFrame.lazy)                                       Return lazy representation, i.e. itself.
  [`limit`](api/polars.LazyFrame.limit.html#polars.LazyFrame.limit)                                    Get the first `n` rows.
  [`map_batches`](api/polars.LazyFrame.map_batches.html#polars.LazyFrame.map_batches)                  Apply a custom function.
  [`match_to_schema`](api/polars.LazyFrame.match_to_schema.html#polars.LazyFrame.match_to_schema)      Match or evolve the schema of a LazyFrame into a specific schema.
  [`max`](api/polars.LazyFrame.max.html#polars.LazyFrame.max)                                          Aggregate the columns in the LazyFrame to their maximum value.
  [`mean`](api/polars.LazyFrame.mean.html#polars.LazyFrame.mean)                                       Aggregate the columns in the LazyFrame to their mean value.
  [`median`](api/polars.LazyFrame.median.html#polars.LazyFrame.median)                                 Aggregate the columns in the LazyFrame to their median value.
  [`melt`](api/polars.LazyFrame.melt.html#polars.LazyFrame.melt)                                       Unpivot a DataFrame from wide to long format.
  [`merge_sorted`](api/polars.LazyFrame.merge_sorted.html#polars.LazyFrame.merge_sorted)               Take two sorted DataFrames and merge them by the sorted key.
  [`min`](api/polars.LazyFrame.min.html#polars.LazyFrame.min)                                          Aggregate the columns in the LazyFrame to their minimum value.
  [`null_count`](api/polars.LazyFrame.null_count.html#polars.LazyFrame.null_count)                     Aggregate the columns in the LazyFrame as the sum of their null value count.
  [`pipe`](api/polars.LazyFrame.pipe.html#polars.LazyFrame.pipe)                                       Offers a structured way to apply a sequence of user-defined functions (UDFs).
  [`profile`](api/polars.LazyFrame.profile.html#polars.LazyFrame.profile)                              Profile a LazyFrame.
  [`quantile`](api/polars.LazyFrame.quantile.html#polars.LazyFrame.quantile)                           Aggregate the columns in the LazyFrame to their quantile value.
  [`remote`](api/polars.LazyFrame.remote.html#polars.LazyFrame.remote)                                 Run a query remotely on Polars Cloud.
  [`remove`](api/polars.LazyFrame.remove.html#polars.LazyFrame.remove)                                 Remove rows, dropping those that match the given predicate expression(s).
  [`rename`](api/polars.LazyFrame.rename.html#polars.LazyFrame.rename)                                 Rename column names.
  [`reverse`](api/polars.LazyFrame.reverse.html#polars.LazyFrame.reverse)                              Reverse the DataFrame.
  [`rolling`](api/polars.LazyFrame.rolling.html#polars.LazyFrame.rolling)                              Create rolling groups based on a temporal or integer column.
  [`select`](api/polars.LazyFrame.select.html#polars.LazyFrame.select)                                 Select columns from this LazyFrame.
  [`select_seq`](api/polars.LazyFrame.select_seq.html#polars.LazyFrame.select_seq)                     Select columns from this LazyFrame.
  [`serialize`](api/polars.LazyFrame.serialize.html#polars.LazyFrame.serialize)                        Serialize the logical plan of this LazyFrame to a file or string in JSON format.
  [`set_sorted`](api/polars.LazyFrame.set_sorted.html#polars.LazyFrame.set_sorted)                     Flag a column as sorted.
  [`shift`](api/polars.LazyFrame.shift.html#polars.LazyFrame.shift)                                    Shift values by the given number of indices.
  [`show_graph`](api/polars.LazyFrame.show_graph.html#polars.LazyFrame.show_graph)                     Show a plot of the query plan.
  [`sink_csv`](../api/polars.LazyFrame.sink_csv.html#polars.LazyFrame.sink_csv)                        Evaluate the query in streaming mode and write to a CSV file.
  [`sink_ipc`](../api/polars.LazyFrame.sink_ipc.html#polars.LazyFrame.sink_ipc)                        Evaluate the query in streaming mode and write to an IPC file.
  [`sink_ndjson`](../api/polars.LazyFrame.sink_ndjson.html#polars.LazyFrame.sink_ndjson)               Evaluate the query in streaming mode and write to an NDJSON file.
  [`sink_parquet`](../api/polars.LazyFrame.sink_parquet.html#polars.LazyFrame.sink_parquet)            Evaluate the query in streaming mode and write to a Parquet file.
  [`slice`](api/polars.LazyFrame.slice.html#polars.LazyFrame.slice)                                    Get a slice of this DataFrame.
  [`sort`](api/polars.LazyFrame.sort.html#polars.LazyFrame.sort)                                       Sort the LazyFrame by the given columns.
  [`sql`](api/polars.LazyFrame.sql.html#polars.LazyFrame.sql)                                          Execute a SQL query against the LazyFrame.
  [`std`](api/polars.LazyFrame.std.html#polars.LazyFrame.std)                                          Aggregate the columns in the LazyFrame to their standard deviation value.
  [`sum`](api/polars.LazyFrame.sum.html#polars.LazyFrame.sum)                                          Aggregate the columns in the LazyFrame to their sum value.
  [`tail`](api/polars.LazyFrame.tail.html#polars.LazyFrame.tail)                                       Get the last `n` rows.
  [`top_k`](api/polars.LazyFrame.top_k.html#polars.LazyFrame.top_k)                                    Return the `k` largest rows.
  [`unique`](api/polars.LazyFrame.unique.html#polars.LazyFrame.unique)                                 Drop duplicate rows from this DataFrame.
  [`unnest`](api/polars.LazyFrame.unnest.html#polars.LazyFrame.unnest)                                 Decompose struct columns into separate columns for each of their fields.
  [`unpivot`](api/polars.LazyFrame.unpivot.html#polars.LazyFrame.unpivot)                              Unpivot a DataFrame from wide to long format.
  [`update`](api/polars.LazyFrame.update.html#polars.LazyFrame.update)                                 Update the values in this `LazyFrame` with the values in `other`.
  [`var`](api/polars.LazyFrame.var.html#polars.LazyFrame.var)                                          Aggregate the columns in the LazyFrame to their variance value.
  [`with_columns`](api/polars.LazyFrame.with_columns.html#polars.LazyFrame.with_columns)               Add columns to this LazyFrame.
  [`with_columns_seq`](api/polars.LazyFrame.with_columns_seq.html#polars.LazyFrame.with_columns_seq)   Add columns to this LazyFrame.
  [`with_context`](api/polars.LazyFrame.with_context.html#polars.LazyFrame.with_context)               Add an external context to the computation graph.
  [`with_row_count`](api/polars.LazyFrame.with_row_count.html#polars.LazyFrame.with_row_count)         Add a column at index 0 that counts the rows.
  [`with_row_index`](api/polars.LazyFrame.with_row_index.html#polars.LazyFrame.with_row_index)         Add a row index as the first column in the LazyFrame.
  ---------------------------------------------------------------------------------------------------- ----------------------------------------------------------------------------------

**Attributes:**

  ------------------------------------------------------------------------- ------------------------------------------------------------
  [`columns`](api/polars.LazyFrame.columns.html#polars.LazyFrame.columns)   Get the column names.
  [`dtypes`](api/polars.LazyFrame.dtypes.html#polars.LazyFrame.dtypes)      Get the column data types.
  [`schema`](api/polars.LazyFrame.schema.html#polars.LazyFrame.schema)      Get an ordered mapping of column names to their data type.
  [`width`](api/polars.LazyFrame.width.html#polars.LazyFrame.width)         Get the number of columns.
  ------------------------------------------------------------------------- ------------------------------------------------------------

approx_n_unique() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6322-L6353)

:   Approximate count of unique values.

    Deprecated since version 0.20.11: Use
    `select(pl.all().approx_n_unique())` instead.

    This is done using the HyperLogLog++ algorithm for cardinality
    estimation.

bottom_k(

*k: [int](https://docs.python.org/3/library/functions.html#int)*,

*\**,

*by: IntoExpr | Iterable\[IntoExpr\]*,

*reverse: [bool](https://docs.python.org/3/library/functions.html#bool)
|
Sequence\[[bool](https://docs.python.org/3/library/functions.html#bool)\]
= False*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L1772-L1848)

Return the `k` smallest rows.

Non-null elements are always preferred over null elements, regardless of
the value of `reverse`. The output is not guaranteed to be in any
particular order, call
[`sort()`](api/polars.LazyFrame.sort.html#polars.LazyFrame.sort) after
this function if you wish the output to be sorted.

Changed in version 1.0.0: The `descending` parameter was renamed
`reverse`.

Parameters:

:   

    **k**

    :   Number of rows to return.

    **by**

    :   Column(s) used to determine the bottom rows. Accepts expression
        input. Strings are parsed as column names.

    **reverse**

    :   Consider the `k` largest elements of the `by` column(s) (instead
        of the `k` smallest). This can be specified per column by
        passing a sequence of booleans.

See also

[`top_k`](api/polars.LazyFrame.top_k.html#polars.LazyFrame.top_k)

:   

cache() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L3553-L3559)

:   Cache the result once the execution of the physical plan hits this
    node.

    It is not recommended using this as the optimizer likely can do a
    better job.

cast(

*dtypes: Mapping\[ColumnNameOrSelector | PolarsDataType, PolarsDataType
| PythonDataType\] | PolarsDataType | DataTypeExpr*,

*\**,

*strict: [bool](https://docs.python.org/3/library/functions.html#bool) =
True*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L3561-L3664)

Cast LazyFrame column(s) to the specified dtype(s).

Parameters:

:   

    **dtypes**

    :   Mapping of column names (or selector) to dtypes, or a single
        dtype to which all columns will be cast.

    **strict**

    :   Throw an error if a cast could not be done (for instance, due to
        an overflow).

clear(*n: [int](https://docs.python.org/3/library/functions.html#int) = 0*) → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L3666-L3710)

:   Create an empty copy of the current LazyFrame, with zero to 'n'
    rows.

    Returns a copy with an identical schema but no data.

    Parameters:

    :   

        **n**

        :   Number of (empty) rows to return in the cleared frame.

    See also

    [`clone`](api/polars.LazyFrame.clone.html#polars.LazyFrame.clone)

    :   Cheap deepcopy/clone.

<!-- -->

clone() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L3712-L3735)

:   Create a copy of this LazyFrame.

    This is a cheap operation that does not copy data.

    See also

    [`clear`](api/polars.LazyFrame.clear.html#polars.LazyFrame.clear)

    :   Create an empty copy of the current LazyFrame, with identical
        schema but no data.

collect(

*\**,

*type_coercion:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*predicate_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*projection_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*simplify_expression:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*slice_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*comm_subplan_elim:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*comm_subexpr_elim:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*cluster_with_columns:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*collapse_joins:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*no_optimization:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*engine: EngineType = \'auto\'*,

*background:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*optimizations:
[QueryOptFlags](api/polars.QueryOptFlags.html#polars.QueryOptFlags) =
()*,

*\*\*\_kwargs: Any*,

) → DataFrame |
InProcessQuery[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L2104-L2335)

Materialize this LazyFrame into a DataFrame.

By default, all query optimizations are enabled. Individual
optimizations may be disabled by setting the corresponding parameter to
`False`.

Parameters:

:   

    **type_coercion**

    :   Do type coercion optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **predicate_pushdown**

    :   Do predicate pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **projection_pushdown**

    :   Do projection pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **simplify_expression**

    :   Run simplify expressions optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **slice_pushdown**

    :   Slice pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **comm_subplan_elim**

    :   Will try to cache branching subplans that occur on self-joins or
        unions.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **comm_subexpr_elim**

    :   Common subexpressions will be cached and reused.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **cluster_with_columns**

    :   Combine sequential independent calls to with_columns

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **collapse_joins**

    :   Collapse a join and filters into a faster join

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **no_optimization**

    :   Turn off (certain) optimizations.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **engine**

    :   Select the engine used to process the query, optional. At the
        moment, if set to `"auto"` (default), the query is run using the
        polars in-memory engine. Polars will also attempt to use the
        engine set by the `POLARS_ENGINE_AFFINITY` environment variable.
        If it cannot run the query using the selected engine, the query
        is run using the polars in-memory engine. If set to `"gpu"`, the
        GPU engine is used. Fine-grained control over the GPU engine,
        for example which device to use on a system with multiple
        devices, is possible by providing a
        [`GPUEngine`](api/polars.lazyframe.engine_config.GPUEngine.html#polars.lazyframe.engine_config.GPUEngine)
        object with configuration options.

        Note

        GPU mode is considered **unstable**. Not all queries will run
        successfully on the GPU, however, they should fall back
        transparently to the default engine if execution is not
        supported.

        Running with `POLARS_VERBOSE=1` will provide information if a
        query falls back (and why).

        Note

        The GPU engine does not support streaming, or running in the
        background. If either are enabled, then GPU execution is
        switched off.

    **background**

    :   Run the query in the background and get a handle to the query.
        This handle can be used to fetch the result or cancel the query.

        Warning

        Background mode is considered **unstable**. It may be changed at
        any point without it being considered a breaking change.

    **optimizations**

    :   The optimization passes done during query optimization.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

Returns:

:   

    DataFrame

    :   

See also

[`explain`](api/polars.LazyFrame.explain.html#polars.LazyFrame.explain)

:   Print the query plan that is evaluated with collect.

[`profile`](api/polars.LazyFrame.profile.html#polars.LazyFrame.profile)

:   Collect the LazyFrame and time each node in the computation graph.

[`polars.collect_all`](../api/polars.collect_all.html#polars.collect_all)

:   Collect multiple LazyFrames at the same time.

[`polars.Config.set_streaming_chunk_size`](../api/polars.Config.set_streaming_chunk_size.html#polars.Config.set_streaming_chunk_size)

:   Set the size of streaming batches.

collect_async(

*\**,

*gevent: [bool](https://docs.python.org/3/library/functions.html#bool) =
False*,

*engine: EngineType = \'auto\'*,

*optimizations:
[QueryOptFlags](api/polars.QueryOptFlags.html#polars.QueryOptFlags) =
()*,

) → Awaitable\[DataFrame\] |
\_GeventDataFrameResult\[DataFrame\][\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L2355-L2456)

Collect DataFrame asynchronously in thread pool.

Warning

This functionality is considered **unstable**. It may be changed at any
point without it being considered a breaking change.

Collects into a DataFrame (like
[`collect()`](api/polars.LazyFrame.collect.html#polars.LazyFrame.collect))
but, instead of returning a DataFrame directly, it is scheduled to be
collected inside a thread pool, while this method returns almost
instantly.

This can be useful if you use `gevent` or `asyncio` and want to release
control to other greenlets/tasks while LazyFrames are being collected.

Parameters:

:   

    **gevent**

    :   Return wrapper to `gevent.event.AsyncResult` instead of
        Awaitable

    **engine**

    :   Select the engine used to process the query, optional. At the
        moment, if set to `"auto"` (default), the query is run using the
        polars in-memory engine. Polars will also attempt to use the
        engine set by the `POLARS_ENGINE_AFFINITY` environment variable.
        If it cannot run the query using the selected engine, the query
        is run using the polars in-memory engine.

        Note

        The GPU engine does not support async, or running in the
        background. If either are enabled, then GPU execution is
        switched off.

    **optimizations**

    :   The optimization passes done during query optimization.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

Returns:

:   

    If `gevent=False` (default) then returns an awaitable.

    :   

    If `gevent=True` then returns wrapper that has a

    :   

    `.get(block=True,`` ``timeout=None)` method.

    :   

See also

[`polars.collect_all`](../api/polars.collect_all.html#polars.collect_all)

:   Collect multiple LazyFrames at the same time.

[`polars.collect_all_async`](../api/polars.collect_all_async.html#polars.collect_all_async)

:   Collect multiple LazyFrames at the same time lazily.

Notes

In case of error `set_exception` is used on
`asyncio.Future`/`gevent.event.AsyncResult` and will be reraised by
them.

collect_schema() → Schema[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L2458-L2488)

:   Resolve the schema of this LazyFrame.

    Examples

    Determine the schema.

        >>> lf = pl.LazyFrame(
        ...     {
        ...         "foo": [1, 2, 3],
        ...         "bar": [6.0, 7.0, 8.0],
        ...         "ham": ["a", "b", "c"],
        ...     }
        ... )
        >>> lf.collect_schema()
        Schema({'foo': Int64, 'bar': Float64, 'ham': String})

    Access various properties of the schema.

        >>> schema = lf.collect_schema()
        >>> schema["bar"]
        Float64
        >>> schema.names()
        ['foo', 'bar', 'ham']
        >>> schema.dtypes()
        [Int64, Float64, String]
        >>> schema.len()
        3

<!-- -->

*property *columns*: [list](https://docs.python.org/3/library/stdtypes.html#list)\[[str](https://docs.python.org/3/library/stdtypes.html#str)\]*[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L524-L564)

:   Get the column names.

    Returns:

    :   

        list of str

        :   A list containing the name of each column in order.

    Warning

    Determining the column names of a LazyFrame requires resolving its
    schema, which is a potentially expensive operation. Using
    [`collect_schema()`](api/polars.LazyFrame.collect_schema.html#polars.LazyFrame.collect_schema)
    is the idiomatic way of resolving the schema. This property exists
    only for symmetry with the DataFrame class.

    See also

    [`collect_schema`](api/polars.LazyFrame.collect_schema.html#polars.LazyFrame.collect_schema)

    :   

    `Schema.names`

    :   

count() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7896-L7915)

:   Return the number of non-null elements for each column.

describe(

*percentiles:
Sequence\[[float](https://docs.python.org/3/library/functions.html#float)\]
| [float](https://docs.python.org/3/library/functions.html#float) |
[None](https://docs.python.org/3/library/constants.html#None) = (0.25,
0.5, 0.75)*,

*\**,

*interpolation: QuantileMethod = \'nearest\'*,

) →
DataFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L944-L1148)

Creates a summary of statistics for a LazyFrame, returning a DataFrame.

Parameters:

:   

    **percentiles**

    :   One or more percentiles to include in the summary statistics.
        All values must be in the range `[0,`` ``1]`.

    **interpolation**{'nearest', 'higher', 'lower', 'midpoint', 'linear', 'equiprobable'}

    :   Interpolation method used when calculating percentiles.

Returns:

:   

    DataFrame

    :   

Warning

-   This method does *not* maintain the laziness of the frame, and will
    `collect` the final result. This could potentially be an expensive
    operation.

-   We do not guarantee the output of `describe` to be stable. It will
    show statistics that we deem informative, and may be updated in the
    future. Using `describe` programmatically (versus interactive
    exploration) is not recommended for this reason.

Notes

The median is included by default as the 50% percentile.

*classmethod *deserialize(

*source: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Path | IOBase*,

*\**,

*format: SerializationFormat = \'binary\'*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L460-L522)

Read a logical plan from a file to construct a LazyFrame.

Parameters:

:   

    **source**

    :   Path to a file or a file-like object (by file-like object, we
        refer to objects that have a `read()` method, such as a file
        handler (e.g. via builtin `open` function) or `BytesIO`).

    **format**

    :   The format with which the LazyFrame was serialized. Options:

        -   `"binary"`: Deserialize from binary format (bytes). This is
            the default.

        -   `"json"`: Deserialize from JSON format (string).

Warning

This function uses
[`pickle`](https://docs.python.org/3/library/pickle.html#module-pickle)
if the logical plan contains Python UDFs, and as such inherits the
security implications. Deserializing can execute arbitrary code, so it
should only be attempted on trusted data.

See also

[`LazyFrame.serialize`](api/polars.LazyFrame.serialize.html#polars.LazyFrame.serialize)

:   

Notes

Serialization is not stable across Polars versions: a LazyFrame
serialized in one Polars version may not be deserializable in another
Polars version.

drop(

*\*columns: ColumnNameOrSelector | Iterable\[ColumnNameOrSelector\]*,

*strict: [bool](https://docs.python.org/3/library/functions.html#bool) =
True*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L5861-L5938)

Remove columns from the DataFrame.

Parameters:

:   

    **\*columns**

    :   Names of the columns that should be removed from the dataframe.
        Accepts column selector input.

    **strict**

    :   Validate that all column names exist in the current schema, and
        throw an exception if any do not.

drop_nans(

*subset: ColumnNameOrSelector | Collection\[ColumnNameOrSelector\] |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7100-L7187)

Drop all rows that contain one or more NaN values.

The original order of the remaining rows is preserved.

Parameters:

:   

    **subset**

    :   Column name(s) for which NaN values are considered; if set to
        `None` (default), use all columns (note that only floating-point
        columns can contain NaNs).

See also

[`drop_nulls`](api/polars.LazyFrame.drop_nulls.html#polars.LazyFrame.drop_nulls)

:   

Notes

A NaN value is not the same as a null value. To drop null values, use
[`drop_nulls()`](api/polars.LazyFrame.drop_nulls.html#polars.LazyFrame.drop_nulls).

drop_nulls(

*subset: ColumnNameOrSelector | Collection\[ColumnNameOrSelector\] |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7189-L7271)

Drop all rows that contain one or more null values.

The original order of the remaining rows is preserved.

See also

[`drop_nans`](api/polars.LazyFrame.drop_nans.html#polars.LazyFrame.drop_nans)

:   

Notes

A null value is not the same as a NaN value. To drop NaN values, use
[`drop_nans()`](api/polars.LazyFrame.drop_nans.html#polars.LazyFrame.drop_nans).

*property *dtypes*: [list](https://docs.python.org/3/library/stdtypes.html#list)\[[DataType](../api/polars.datatypes.DataType.html#polars.datatypes.DataType)\]*[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L566-L606)

:   Get the column data types.

    Returns:

    :   

        list of DataType

        :   A list containing the data type of each column in order.

    Warning

    Determining the data types of a LazyFrame requires resolving its
    schema, which is a potentially expensive operation. Using
    [`collect_schema()`](api/polars.LazyFrame.collect_schema.html#polars.LazyFrame.collect_schema)
    is the idiomatic way to resolve the schema. This property exists
    only for symmetry with the DataFrame class.

    See also

    [`collect_schema`](api/polars.LazyFrame.collect_schema.html#polars.LazyFrame.collect_schema)

    :   

    `Schema.dtypes`

    :   

explain(

*\**,

*format: ExplainFormat = \'plain\'*,

*optimized:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*type_coercion:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*predicate_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*projection_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*simplify_expression:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*slice_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*comm_subplan_elim:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*comm_subexpr_elim:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*cluster_with_columns:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*collapse_joins:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*streaming:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*engine: EngineType = \'auto\'*,

*tree_format:
[bool](https://docs.python.org/3/library/functions.html#bool) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*optimizations:
[QueryOptFlags](api/polars.QueryOptFlags.html#polars.QueryOptFlags) =
()*,

) →
[str](https://docs.python.org/3/library/stdtypes.html#str)[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L1150-L1304)

Create a string representation of the query plan.

Different optimizations can be turned on or off.

Parameters:

:   

    **format**{'plain', 'tree'}

    :   The format to use for displaying the logical plan.

    **optimized**

    :   Return an optimized query plan. Defaults to `True`. If this is
        set to `True` the subsequent optimization flags control which
        optimizations run.

    **type_coercion**

    :   Do type coercion optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **predicate_pushdown**

    :   Do predicate pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **projection_pushdown**

    :   Do projection pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **simplify_expression**

    :   Run simplify expressions optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **slice_pushdown**

    :   Slice pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **comm_subplan_elim**

    :   Will try to cache branching subplans that occur on self-joins or
        unions.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **comm_subexpr_elim**

    :   Common subexpressions will be cached and reused.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **cluster_with_columns**

    :   Combine sequential independent calls to with_columns

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **collapse_joins**

    :   Collapse a join and filters into a faster join

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **engine**

    :   Select the engine used to process the query, optional. At the
        moment, if set to `"auto"` (default), the query is run using the
        polars in-memory engine. Polars will also attempt to use the
        engine set by the `POLARS_ENGINE_AFFINITY` environment variable.
        If it cannot run the query using the selected engine, the query
        is run using the polars in-memory engine. If set to `"gpu"`, the
        GPU engine is used. Fine-grained control over the GPU engine,
        for example which device to use on a system with multiple
        devices, is possible by providing a
        [`GPUEngine`](api/polars.lazyframe.engine_config.GPUEngine.html#polars.lazyframe.engine_config.GPUEngine)
        object with configuration options.

        Note

        GPU mode is considered **unstable**. Not all queries will run
        successfully on the GPU, however, they should fall back
        transparently to the default engine if execution is not
        supported.

        Running with `POLARS_VERBOSE=1` will provide information if a
        query falls back (and why).

        Note

        The GPU engine does not support streaming, if streaming is
        enabled then GPU execution is switched off.

    **optimizations**

    :   The optimization passes done during query optimization.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **tree_format**

    :   Format the output as a tree.

        Deprecated since version 0.20.30: Use `format="tree"` instead.

explode(

*columns: ColumnNameOrSelector | Iterable\[ColumnNameOrSelector\]*,

*\*more_columns: ColumnNameOrSelector*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6964-L7008)

Explode the DataFrame to long format by exploding the given columns.

Parameters:

:   

    **columns**

    :   Column names, expressions, or a selector defining them. The
        underlying columns being exploded must be of the `List` or
        `Array` data type.

    **\*more_columns**

    :   Additional names of columns to explode, specified as positional
        arguments.

fetch(*n_rows: [int](https://docs.python.org/3/library/functions.html#int) = 500*, *\*\*kwargs: Any*) → DataFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L3497-L3526)

:   Collect a small number of rows for debugging purposes.

    Deprecated since version 1.0: Use
    [`collect()`](api/polars.LazyFrame.collect.html#polars.LazyFrame.collect)
    instead, in conjunction with a call to
    [`head()`](../expressions/api/polars.head.html#polars.head).\`

    Warning

    This is strictly a utility function that can help to debug queries
    using a smaller number of rows, and should *not* be used in
    production code.

    Notes

    This is similar to a
    [`collect()`](api/polars.LazyFrame.collect.html#polars.LazyFrame.collect)
    operation, but it overwrites the number of rows read by *every* scan
    operation. Be aware that `fetch` does not guarantee the final number
    of rows in the DataFrame. Filters, join operations and fewer rows
    being available in the scanned data will all influence the final
    number of rows (joins are especially susceptible to this, and may
    return no data at all if `n_rows` is too small as the join keys may
    not be present).

<!-- -->

fill_nan(*value: [int](https://docs.python.org/3/library/functions.html#int) | [float](https://docs.python.org/3/library/functions.html#float) | Expr | [None](https://docs.python.org/3/library/constants.html#None)*) → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6660-L6701)

:   Fill floating point NaN values.

    Parameters:

    :   

        **value**

        :   Value used to fill NaN values.

    See also

    [`fill_null`](api/polars.LazyFrame.fill_null.html#polars.LazyFrame.fill_null)

    :   

    Notes

    A NaN value is not the same as a null value. To fill null values,
    use
    [`fill_null()`](api/polars.LazyFrame.fill_null.html#polars.LazyFrame.fill_null).

fill_null(

*value: Any | Expr |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*strategy: FillNullStrategy |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*limit: [int](https://docs.python.org/3/library/functions.html#int) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*\**,

*matches_supertype:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6520-L6658)

Fill null values using the specified value or strategy.

Parameters:

:   

    **value**

    :   Value used to fill null values.

    **strategy**{None, 'forward', 'backward', 'min', 'max', 'mean', 'zero', 'one'}

    :   Strategy used to fill null values.

    **limit**

    :   Number of consecutive null values to fill when using the
        'forward' or 'backward' strategy.

    **matches_supertype**

    :   Fill all matching supertypes of the fill `value` literal.

See also

[`fill_nan`](api/polars.LazyFrame.fill_nan.html#polars.LazyFrame.fill_nan)

:   

Notes

A null value is not the same as a NaN value. To fill NaN values, use
[`fill_nan()`](api/polars.LazyFrame.fill_nan.html#polars.LazyFrame.fill_nan).

filter(

*\*predicates: IntoExprColumn | Iterable\[IntoExprColumn\] |
[bool](https://docs.python.org/3/library/functions.html#bool) |
[list](https://docs.python.org/3/library/stdtypes.html#list)\[[bool](https://docs.python.org/3/library/functions.html#bool)\]
| np.ndarray\[Any, Any\]*,

*\*\*constraints: Any*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L3822-L3998)

Filter rows in the LazyFrame based on a predicate expression.

The original order of the remaining rows is preserved.

Rows where the filter predicate does not evaluate to True are discarded
(this includes rows where the predicate evaluates as `null`).

Parameters:

:   

    **predicates**

    :   Expression that evaluates to a boolean Series.

    **constraints**

    :   Column filters; use `name`` ``=`` ``value` to filter columns
        using the supplied value. Each constraint behaves the same as
        `pl.col(name).eq(value)`, and is implicitly joined with the
        other filter conditions using `&`.

See also

[`remove`](api/polars.LazyFrame.remove.html#polars.LazyFrame.remove)

:   

Notes

If you are transitioning from Pandas, and performing filter operations
based on the comparison of two or more columns, please note that in
Polars any comparison involving `null` values will result in a `null`
result, *not* boolean True or False. As a result, these rows will not be
retained. Ensure that null values are handled appropriately to avoid
unexpected behaviour (see examples below).

first() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6298-L6320)

:   Get the first row of the DataFrame.

<!-- -->

gather_every(*n: [int](https://docs.python.org/3/library/functions.html#int)*, *offset: [int](https://docs.python.org/3/library/functions.html#int) = 0*) → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6478-L6518)

:   Take every nth row in the LazyFrame and return as a new LazyFrame.

    Parameters:

    :   

        **n**

        :   Gather every *n*-th row.

        **offset**

        :   Starting index.

group_by(

*\*by: IntoExpr | Iterable\[IntoExpr\]*,

*maintain_order:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*\*\*named_by: IntoExpr*,

) →
LazyGroupBy[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L4275-L4381)

Start a group by operation.

Parameters:

:   

    **\*by**

    :   Column(s) to group by. Accepts expression input. Strings are
        parsed as column names.

    **maintain_order**

    :   Ensure that the order of the groups is consistent with the input
        data. This is slower than a default group by. Setting this to
        `True` blocks the possibility to run on the streaming engine.

    **\*\*named_by**

    :   Additional columns to group by, specified as keyword arguments.
        The columns will be renamed to the keyword used.

group_by_dynamic(

*index_column: IntoExpr*,

*\**,

*every: [str](https://docs.python.org/3/library/stdtypes.html#str) |
timedelta*,

*period: [str](https://docs.python.org/3/library/stdtypes.html#str) |
timedelta |
[None](https://docs.python.org/3/3/library/constants.html#None) = None*,

*offset: [str](https://docs.python.org/3/library/stdtypes.html#str) |
timedelta |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*include_boundaries:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*closed: ClosedInterval = \'left\'*,

*label: Label = \'left\'*,

*group_by: IntoExpr | Iterable\[IntoExpr\] |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*start_by: StartBy = \'window\'*,

) →
LazyGroupBy[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L4522-L4858)

Group based on a time value (or index value of type Int32, Int64).

Time windows are calculated and rows are assigned to windows. Different
from a normal group by is that a row can be member of multiple groups.
By default, the windows look like:

-   [start, start + period)

-   [start + every, start + every + period)

-   [start + 2*every, start + 2*every + period)

-   ...

where `start` is determined by `start_by`, `offset`, `every`, and the
earliest datapoint. See the `start_by` argument description for details.

Warning

The index column must be sorted in ascending order. If `group_by` is
passed, then the index column must be sorted in ascending order within
each group.

Changed in version 0.20.14: The `by` parameter was renamed `group_by`.

Parameters:

:   

    **index_column**

    :   Column used to group based on the time window. Often of type
        Date/Datetime. This column must be sorted in ascending order
        (or, if `group_by` is specified, then it must be sorted in
        ascending order within each group).

        In case of a dynamic group by on indices, dtype needs to be one
        of {Int32, Int64}. Note that Int32 gets temporarily cast to
        Int64, so if performance matters use an Int64 column.

    **every**

    :   interval of the window

    **period**

    :   length of the window, if None it will equal 'every'

    **offset**

    :   offset of the window, does not take effect if `start_by` is
        'datapoint'. Defaults to zero.

    **include_boundaries**

    :   Add the lower and upper bound of the window to the
        "\_lower_boundary" and "\_upper_boundary" columns. This will
        impact performance because it's harder to parallelize

    **closed**{'left', 'right', 'both', 'none'}

    :   Define which sides of the temporal interval are closed
        (inclusive).

    **label**{'left', 'right', 'datapoint'}

    :   Define which label to use for the window:

        -   'left': lower boundary of the window

        -   'right': upper boundary of the window

        -   'datapoint': the first value of the index column in the
            given window. If you don't need the label to be at one of
            the boundaries, choose this option for maximum performance

    **group_by**

    :   Also group by this column/these columns

    **start_by**{'window', 'datapoint', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'}

    :   The strategy to determine the start of the first window by.

        -   'window': Start by taking the earliest timestamp, truncating
            it with `every`, and then adding `offset`. Note that weekly
            windows start on Monday.

        -   'datapoint': Start from the first encountered data point.

        -   a day of the week (only takes effect if `every` contains
            `'w'`):

            -   'monday': Start the window on the Monday before the
                first data point.

            -   'tuesday': Start the window on the Tuesday before the
                first data point.

            -   ...

            -   'sunday': Start the window on the Sunday before the
                first data point.

            The resulting window is then shifted back until the earliest
            datapoint is in or in front of it.

Returns:

:   

    LazyGroupBy

    :   Object you can call `.agg` on to aggregate by groups, the result
        of which will be sorted by `index_column` (but note that if
        `group_by` columns are passed, it will only be sorted within
        each group).

See also

[`rolling`](api/polars.LazyFrame.rolling.html#polars.LazyFrame.rolling)

:   

Notes

1.  If you're coming from pandas, then

        # polars
        df.group_by_dynamic("ts", every="1d").agg(pl.col("value").sum())

    is equivalent to

        # pandas
        df.set_index("ts").resample("D")["value"].sum().reset_index()

    though note that, unlike pandas, polars doesn't add extra rows for
    empty windows. If you need `index_column` to be evenly spaced, then
    please combine with
    [`DataFrame.upsample()`](../dataframe/api/polars.DataFrame.upsample.html#polars.DataFrame.upsample).

2.  The `every`, `period` and `offset` arguments are created with the
    following string language:

    -   1ns (1 nanosecond)

    -   1us (1 microsecond)

    -   1ms (1 millisecond)

    -   1s (1 second)

    -   1m (1 minute)

    -   1h (1 hour)

    -   1d (1 calendar day)

    -   1w (1 calendar week)

    -   1mo (1 calendar month)

    -   1q (1 calendar quarter)

    -   1y (1 calendar year)

    -   1i (1 index count)

    Or combine them (except in `every`): "3d12h4m25s" # 3 days, 12
    hours, 4 minutes, and 25 seconds

    By "calendar day", we mean the corresponding time on the next day
    (which may not be 24 hours, due to daylight savings). Similarly for
    "calendar week", "calendar month", "calendar quarter", and "calendar
    year".

    In case of a group_by_dynamic on an integer column, the windows are
    defined by:

    -   "1i" # length 1

    -   "10i" # length 10

head(*n: [int](https://docs.python.org/3/library/functions.html#int) = 5*) → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6188-L6229)

:   Get the first `n` rows.

    Parameters:

    :   

        **n**

        :   Number of rows to return.

<!-- -->

inspect(*fmt: [str](https://docs.python.org/3/library/stdtypes.html#str) = \'{}\'*) → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L1464-L1488)

:   Inspect a node in the computation graph.

    Print the value that this node in the computation graph evaluates to
    and pass on the value.

interpolate() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7463-L7491)

:   Interpolate intermediate values. The interpolation method is linear.

    Nulls at the beginning and end of the series remain null.

join(

*other: LazyFrame*,

*on: [str](https://docs.python.org/3/library/stdtypes.html#str) | Expr
| Sequence\[[str](https://docs.python.org/3/library/stdtypes.html#str)
| Expr\] |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*how: JoinStrategy = \'inner\'*,

*\**,

*left_on: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Expr |
Sequence\[[str](https://docs.python.org/3/library/stdtypes.html#str) |
Expr\] | [None](https://docs.python.org/3/library/constants.html#None)
= None*,

*right_on: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Expr |
Sequence\[[str](https://docs.python.org/3/library/stdtypes.html#str) |
Expr\] | [None](https://docs.python.org/3/library/constants.html#None)
= None*,

*suffix: [str](https://docs.python.org/3/library/stdtypes.html#str) =
\'\_right\'*,

*validate: JoinValidation = \'m:m\'*,

*nulls_equal:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*coalesce: [bool](https://docs.python.org/3/library/functions.html#bool)
| [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*maintain_order: MaintainOrderJoin |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*allow_parallel:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*force_parallel:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L5231-L5518)

Add a join operation to the Logical Plan.

Changed in version 1.24: The `join_nulls` parameter was renamed
`nulls_equal`.

Parameters:

:   

    **other**

    :   Lazy DataFrame to join with.

    **on**

    :   Name(s) of the join columns in both DataFrames. If set,
        `left_on` and `right_on` should be None. This should not be
        specified if `how='cross'`.

    **how**{'inner','left', 'right', 'full', 'semi', 'anti', 'cross'}

    :   Join strategy.

          ----------- ----------------------------------------------------------------------------------
          **inner**   *(Default)* Returns rows that have matching values in both tables.
          **left**    Returns all rows from the left table, and the matched rows from the right table.
          **full**    Returns all rows when there is a match in either left or right.
          **cross**   Returns the Cartesian product of rows from both tables
          **semi**    Returns rows from the left table that have a match in the right table.
          **anti**    Returns rows from the left table that have no match in the right table.
          ----------- ----------------------------------------------------------------------------------

    **left_on**

    :   Join column of the left DataFrame.

    **right_on**

    :   Join column of the right DataFrame.

    **suffix**

    :   Suffix to append to columns with a duplicate name.

    **validate: {'m:m', 'm:1', '1:m', '1:1'}**

    :   Checks if join is of specified type.

          --------- -----------------------------------------------------------------------------
          **m:m**   *(Default)* Many-to-many. Does not result in checks.
          **1:1**   One-to-one. Checks if join keys are unique in both left and right datasets.
          **1:m**   One-to-many. Checks if join keys are unique in left dataset.
          **m:1**   Many-to-one. Check if join keys are unique in right dataset.
          --------- -----------------------------------------------------------------------------

        Note

        This is currently not supported by the streaming engine.

    **nulls_equal**

    :   Join on null values. By default null values will never produce
        matches.

    **coalesce**

    :   Coalescing behavior (merging of join columns).

          ----------- --------------------------------------------------------
          **None**    *(Default)* Coalesce unless `how='full'` is specified.
          **True**    Always coalesce join columns.
          **False**   Never coalesce join columns.
          ----------- --------------------------------------------------------

        Note

        Joining on any other expressions than `col` will turn off
        coalescing.

    **maintain_order**{'none', 'left', 'right', 'left_right', 'right_left'}

    :   Which DataFrame row order to preserve, if any. Do not rely on
        any observed ordering without explicitly setting this parameter,
        as your code may break in a future release. Not specifying any
        ordering can improve performance. Supported for inner, left,
        right and full joins

          ---------------- -------------------------------------------------------------------------------------------------------------------------------
          **none**         *(Default)* No specific ordering is desired. The ordering might differ across Polars versions or even between different runs.
          **left**         Preserves the order of the left DataFrame.
          **right**        Preserves the order of the right DataFrame.
          **left_right**   First preserves the order of the left DataFrame, then the right.
          **right_left**   First preserves the order of the right DataFrame, then the left.
          ---------------- -------------------------------------------------------------------------------------------------------------------------------

    **allow_parallel**

    :   Allow the physical plan to optionally evaluate the computation
        of both DataFrames up to the join in parallel.

    **force_parallel**

    :   Force the physical plan to evaluate the computation of both
        DataFrames up to the join in parallel.

See also

[`join_asof`](api/polars.LazyFrame.join_asof.html#polars.LazyFrame.join_asof)

:   

join_asof(

*other: LazyFrame*,

*\**,

*left_on: [str](https://docs.python.org/3/library/stdtypes.html#str) |
[None](https://docs.python.org/3/library/constants.html#None) | Expr =
None*,

*right_on: [str](https://docs.python.org/3/library/stdtypes.html#str) |
[None](https://docs.python.org/3/library/constants.html#None) | Expr =
None*,

*on: [str](https://docs.python.org/3/library/stdtypes.html#str) |
[None](https://docs.python.org/3/library/constants.html#None) | Expr =
None*,

*by_left: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Sequence\[[str](https://docs.python.org/3/library/stdtypes.html#str)\]
| [None](https://docs.python.org/3/library/constants.html#None) = None*,

*by_right: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Sequence\[[str](https://docs.python.org/3/library/stdtypes.html#str)\]
| [None](https://docs.python.org/3/library/constants.html#None) = None*,

*by: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Sequence\[[str](https://docs.python.org/3/library/stdtypes.html#str)\]
| [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*strategy: AsofJoinStrategy = \'backward\'*,

*suffix: [str](https://docs.python.org/3/library/stdtypes.html#str) =
\'\_right\'*,

*tolerance: [str](https://docs.python.org/3/library/functions.html#str)
| [int](https://docs.python.org/3/library/functions.html#int) |
[float](https://docs.python.org/3/library/functions.html#float) |
timedelta |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*allow_parallel:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*force_parallel:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*coalesce: [bool](https://docs.python.org/3/library/functions.html#bool)
= True*,

*allow_exact_matches:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*check_sortedness:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L4860-L5229)

Perform an asof join.

This is similar to a left-join except that we match on nearest key
rather than equal keys.

Both DataFrames must be sorted by the `on` key (within each `by` group,
if specified).

For each row in the left DataFrame:

>      
>
> -   A "backward" search selects the last row in the right DataFrame
>     whose 'on' key is less than or equal to the left's key.
>
> -   A "forward" search selects the first row in the right DataFrame
>     whose 'on' key is greater than or equal to the left's key.
>
>     A "nearest" search selects the last row in the right DataFrame
>     whose value is nearest to the left's key. String keys are not
>     currently supported for a nearest search.
>
>       

The default is "backward".

Parameters:

:   

    **other**

    :   Lazy DataFrame to join with.

    **left_on**

    :   Join column of the left DataFrame.

    **right_on**

    :   Join column of the right DataFrame.

    **on**

    :   Join column of both DataFrames. If set, `left_on` and `right_on`
        should be None.

    **by**

    :   Join on these columns before doing asof join.

    **by_left**

    :   Join on these columns before doing asof join.

    **by_right**

    :   Join on these columns before doing asof join.

    **strategy**{'backward', 'forward', 'nearest'}

    :   Join strategy.

    **suffix**

    :   Suffix to append to columns with a duplicate name.

    **tolerance**

    :   Numeric tolerance. By setting this the join will only be done if
        the near keys are within this distance. If an asof join is done
        on columns of dtype "Date", "Datetime", "Duration" or "Time",
        use either a datetime.timedelta object or the following string
        language:

        >      
        >
        > -   1ns (1 nanosecond)
        >
        > -   1us (1 microsecond)
        >
        > -   1ms (1 millisecond)
        >
        > -   1s (1 second)
        >
        > -   1m (1 minute)
        >
        > -   1h (1 hour)
        >
        > -   1d (1 calendar day)
        >
        > -   1w (1 calendar week)
        >
        > -   1mo (1 calendar month)
        >
        > -   1q (1 calendar quarter)
        >
        > -   1y (1 calendar year)
        >
        > Or combine them: "3d12h4m25s" # 3 days, 12 hours, 4 minutes,
        > and 25 seconds
        >
        > By "calendar day", we mean the corresponding time on the next
        > day (which may not be 24 hours, due to daylight savings).
        > Similarly for "calendar week", "calendar month", "calendar
        > quarter", and "calendar year".
        >
        >       

    **allow_parallel**

    :   Allow the physical plan to optionally evaluate the computation
        of both DataFrames up to the join in parallel.

    **force_parallel**

    :   Force the physical plan to evaluate the computation of both
        DataFrames up to the join in parallel.

    **coalesce**

    :   Coalescing behavior (merging of `on` / `left_on` / `right_on`
        columns):

        -   True: -> Always coalesce join columns.

        -   False: -> Never coalesce join columns.

        Note that joining on any other expressions than `col` will turn
        off coalescing.

    **allow_exact_matches**

    :   Whether exact matches are valid join predicates.

        -   

            If True, allow matching with the same `on` value

            :   (i.e. less-than-or-equal-to / greater-than-or-equal-to)

        -   

            If False, don't match the same `on` value

            :   (i.e., strictly less-than / strictly greater-than).

    **check_sortedness**

    :   Check the sortedness of the asof keys. If the keys are not
        sorted Polars will error. Currently, sortedness cannot be
        checked if 'by' groups are provided.

join_where(

*other: LazyFrame*,

*\*predicates: Expr | Iterable\[Expr\]*,

*suffix: [str](https://docs.python.org/3/library/stdtypes.html#str) =
\'\_right\'*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L5520-L5620)

Perform a join based on one or multiple (in)equality predicates.

This performs an inner join, so only rows where all predicates are true
are included in the result, and a row from either DataFrame may be
included multiple times in the result.

Note

The row order of the input DataFrames is not preserved.

Warning

This functionality is experimental. It may be changed at any point
without it being considered a breaking change.

Parameters:

:   

    **other**

    :   DataFrame to join with.

    **\*predicates**

    :   (In)Equality condition to join the two tables on. When a column
        name occurs in both tables, the proper suffix must be applied in
        the predicate.

    **suffix**

    :   Suffix to append to columns with a duplicate name.

last() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6274-L6296)

:   Get the last row of the DataFrame.

<!-- -->

lazy() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L3528-L3551)

:   Return lazy representation, i.e. itself.

    Useful for writing code that expects either a `DataFrame` or
    `LazyFrame`. On LazyFrame this is a no-op, and returns the same
    object.

    Returns:

    :   

        LazyFrame

        :   

<!-- -->

limit(*n: [int](https://docs.python.org/3/library/functions.html#int) = 5*) → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6143-L6186)

:   Get the first `n` rows.

    Alias for
    [`LazyFrame.head()`](api/polars.LazyFrame.head.html#polars.LazyFrame.head).

    Parameters:

    :   

        **n**

        :   Number of rows to return.

map_batches(

*function: Callable\[\[DataFrame\], DataFrame\]*,

*\**,

*predicate_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*projection_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*slice_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*no_optimizations:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*schema: [None](https://docs.python.org/3/library/constants.html#None)
| SchemaDict = None*,

*validate_output_schema:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*streamable:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7360-L7461)

Apply a custom function.

It is important that the function returns a Polars DataFrame.

Parameters:

:   

    **function**

    :   Lambda/ function to apply.

    **predicate_pushdown**

    :   Allow predicate pushdown optimization to pass this node.

    **projection_pushdown**

    :   Allow projection pushdown optimization to pass this node.

    **slice_pushdown**

    :   Allow slice pushdown optimization to pass this node.

    **no_optimizations**

    :   Turn off all optimizations past this point.

    **schema**

    :   Output schema of the function, if set to `None` we assume that
        the schema will remain unchanged by the applied function.

    **validate_output_schema**

    :   It is paramount that polars' schema is correct. This flag will
        ensure that the output schema of this function will be checked
        with the expected schema. Setting this to `False` will not do
        this check, but may lead to hard to debug bugs.

    **streamable**

    :   Whether the function that is given is eligible to be running
        with the streaming engine. That means that the function must
        produce the same result when it is executed in batches or when
        it is be executed on the full dataset.

Warning

The `schema` of a `LazyFrame` must always be correct. It is up to the
caller of this function to ensure that this invariant is upheld.

It is important that the optimization flags are correct. If the custom
function for instance does an aggregation of a column,
`predicate_pushdown` should not be allowed, as this prunes rows and will
influence your aggregation results.

Notes

A UDF passed to `map_batches` must be pure, meaning that it cannot
modify or depend on state other than its arguments.

match_to_schema(

*schema: SchemaDict | Schema*,

*\**,

*missing_columns: Literal\[\'insert\', \'raise\'\] |
Mapping\[[str](https://docs.python.org/3/library/stdtypes.html#str),
Literal\[\'insert\', \'raise\'\] | Expr\] = \'raise\'*,

*missing_struct_fields: Literal\[\'insert\', \'raise\'\] |
Mapping\[[str](https://docs.python.org/3/library/stdtypes.html#str),
Literal\[\'insert\', \'raise\'\]\] = \'raise\'*,

*extra_columns: Literal\[\'ignore\', \'raise\'\] = \'raise\'*,

*extra_struct_fields: Literal\[\'ignore\', \'raise\'\] |
Mapping\[[str](https://docs.python.org/3/library/stdtypes.html#str),
Literal\[\'ignore\', \'raise\'\]\] = \'raise\'*,

*integer_cast: Literal\[\'upcast\', \'forbid\'\] |
Mapping\[[str](https://docs.python.org/3/library/stdtypes.html#str),
Literal\[\'upcast\', \'forbid\'\]\] = \'forbid\'*,

*float_cast: Literal\[\'upcast\', \'forbid\'\] |
Mapping\[[str](https://docs.python.org/3/library/stdtypes.html#str),
Literal\[\'upcast\', \'forbid\'\]\] = \'forbid\'*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L8027-L8221)

Match or evolve the schema of a LazyFrame into a specific schema.

By default, match_to_schema returns an error if the input schema does
not exactly match the target schema. It also allows columns to be freely
reordered, with additional coercion rules available through optional
parameters.

Warning

This functionality is considered **unstable**. It may be changed at any
point without it being considered a breaking change.

Parameters:

:   

    **schema**

    :   Target schema to match or evolve to.

    **missing_columns**

    :   Raise of insert missing columns from the input with respect to
        the `schema`.

        This can also be an expression per column with what to insert if
        it is missing.

    **missing_struct_fields**

    :   Raise of insert missing struct fields from the input with
        respect to the `schema`.

    **extra_columns**

    :   Raise of ignore extra columns from the input with respect to the
        `schema`.

    **extra_struct_fields**

    :   Raise of ignore extra struct fields from the input with respect
        to the `schema`.

    **integer_cast**

    :   Forbid of upcast for integer columns from the input to the
        respective column in `schema`.

    **float_cast**

    :   Forbid of upcast for float columns from the input to the
        respective column in `schema`.

max() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6783-L6805)

:   Aggregate the columns in the LazyFrame to their maximum value.

<!-- -->

mean() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6855-L6877)

:   Aggregate the columns in the LazyFrame to their mean value.

<!-- -->

median() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6879-L6901)

:   Aggregate the columns in the LazyFrame to their median value.

melt(

*id_vars: ColumnNameOrSelector | Sequence\[ColumnNameOrSelector\] |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*value_vars: ColumnNameOrSelector | Sequence\[ColumnNameOrSelector\] |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*variable_name:
[str](https://docs.python.org/3/library/stdtypes.html#str) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*value_name: [str](https://docs.python.org/3/library/stdtypes.html#str)
| [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*\**,

*streamable:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7917-L7965)

Unpivot a DataFrame from wide to long format.

Optionally leaves identifiers set.

This function is useful to massage a DataFrame into a format where one
or more columns are identifier variables (id_vars) while all other
columns, considered measured variables (value_vars), are "unpivoted" to
the row axis leaving just two non-identifier columns, 'variable' and
'value'.

Deprecated since version 1.0.0: Use the
[`unpivot()`](api/polars.LazyFrame.unpivot.html#polars.LazyFrame.unpivot)
method instead.

Parameters:

:   

    **id_vars**

    :   Column(s) or selector(s) to use as identifier variables.

    **value_vars**

    :   Column(s) or selector(s) to use as values variables; if
        `value_vars` is empty all columns that are not in `id_vars` will
        be used.

    **variable_name**

    :   Name to give to the `variable` column. Defaults to "variable"

    **value_name**

    :   Name to give to the `value` column. Defaults to "value"

    **streamable**

    :   Allow this node to run in the streaming engine. If this runs in
        streaming, the output of the unpivot operation will not have a
        stable ordering.

merge_sorted(

*other: LazyFrame*,

*key: [str](https://docs.python.org/3/library/stdtypes.html#str)*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7549-L7622)

Take two sorted DataFrames and merge them by the sorted key.

The output of this operation will also be sorted. It is the callers
responsibility that the frames are sorted in ascending order by that key
otherwise the output will not make sense.

The schemas of both LazyFrames must be equal.

Parameters:

:   

    **other**

    :   Other DataFrame that must be merged

    **key**

    :   Key that is sorted.

Notes

No guarantee is given over the output row order when the key is equal
between the both dataframes.

The key must be sorted in ascending order.

min() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6807-L6829)

:   Aggregate the columns in the LazyFrame to their minimum value.

<!-- -->

null_count() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6903-L6926)

:   Aggregate the columns in the LazyFrame as the sum of their null
    value count.

pipe(

*function: Callable\[Concatenate\[LazyFrame, P\], T\]*,

*\*args: P.args*,

*\*\*kwargs: P.kwargs*,

) →
T[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L873-L942)

Offers a structured way to apply a sequence of user-defined functions
(UDFs).

Parameters:

:   

    **function**

    :   Callable; will receive the frame as the first parameter,
        followed by any given args/kwargs.

    **\*args**

    :   Arguments to pass to the UDF.

    **\*\*kwargs**

    :   Keyword arguments to pass to the UDF.

profile(

*\**,

*type_coercion:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*predicate_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*projection_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*simplify_expression:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*no_optimization:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*slice_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*comm_subplan_elim:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*comm_subexpr_elim:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*cluster_with_columns:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*collapse_joins:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*show_plot:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*truncate_nodes:
[int](https://docs.python.org/3/library/functions.html#int) = 0*,

*figsize:
[tuple](https://docs.python.org/3/library/stdtypes.html#tuple)\[[int](https://docs.python.org/3/library/functions.html#int),
[int](https://docs.python.org/3/library/functions.html#int)\] = (18,
8)*,

*engine: EngineType = \'auto\'*,

*optimizations:
[QueryOptFlags](api/polars.QueryOptFlags.html#polars.QueryOptFlags) =
()*,

*\*\*\_kwargs: Any*,

) →
[tuple](https://docs.python.org/3/library/stdtypes.html#tuple)\[DataFrame,
DataFrame\][\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L1850-L2064)

Profile a LazyFrame.

This will run the query and return a tuple containing the materialized
DataFrame and a DataFrame that contains profiling information of each
node that is executed.

The units of the timings are microseconds.

Parameters:

:   

    **type_coercion**

    :   Do type coercion optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **predicate_pushdown**

    :   Do predicate pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **projection_pushdown**

    :   Do projection pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **simplify_expression**

    :   Run simplify expressions optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **no_optimization**

    :   Turn off (certain) optimizations.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **slice_pushdown**

    :   Slice pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **comm_subplan_elim**

    :   Will try to cache branching subplans that occur on self-joins or
        unions.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **comm_subexpr_elim**

    :   Common subexpressions will be cached and reused.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **cluster_with_columns**

    :   Combine sequential independent calls to with_columns

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **collapse_joins**

    :   Collapse a join and filters into a faster join

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **show_plot**

    :   Show a gantt chart of the profiling result

    **truncate_nodes**

    :   Truncate the label lengths in the gantt chart to this number of
        characters.

    **figsize**

    :   matplotlib figsize of the profiling plot

    **engine**

    :   Select the engine used to process the query, optional. At the
        moment, if set to `"auto"` (default), the query is run using the
        polars in-memory engine. Polars will also attempt to use the
        engine set by the `POLARS_ENGINE_AFFINITY` environment variable.
        If it cannot run the query using the selected engine, the query
        is run using the polars in-memory engine. If set to `"gpu"`, the
        GPU engine is used. Fine-grained control over the GPU engine,
        for example which device to use on a system with multiple
        devices, is possible by providing a
        [`GPUEngine`](api/polars.lazyframe.engine_config.GPUEngine.html#polars.lazyframe.engine_config.GPUEngine)
        object with configuration options.

        Note

        GPU mode is considered **unstable**. Not all queries will run
        successfully on the GPU, however, they should fall back
        transparently to the default engine if execution is not
        supported.

        Running with `POLARS_VERBOSE=1` will provide information if a
        query falls back (and why).

        Note

        The GPU engine does not support streaming, if streaming is
        enabled then GPU execution is switched off.

    **optimizations**

    :   The optimization passes done during query optimization.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

quantile(

*quantile:
[float](https://docs.python.org/3/library/functions.html#float) |
Expr*,

*interpolation: QuantileMethod = \'nearest\'*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6928-L6962)

Aggregate the columns in the LazyFrame to their quantile value.

Parameters:

:   

    **quantile**

    :   Quantile between 0.0 and 1.0.

    **interpolation**{'nearest', 'higher', 'lower', 'midpoint', 'linear', 'equiprobable'}

    :   Interpolation method.

remote(

*context: pc.ComputeContext |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*plan_type: pc.\_typing.PlanTypePreference = \'dot\'*,

) →
pc.LazyFrameRemote[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7967-L8025)

Run a query remotely on Polars Cloud.

This allows you to run Polars remotely on one or more workers via
several strategies for distributed compute.

Read more in the [Announcement
post](https://pola.rs/posts/polars-cloud-what-we-are-building/)

Parameters:

:   

    **context**

    :   Compute context in which queries are executed. If none given, it
        will take the default context.

    **plan_type: {'plain', 'dot'}**

    :   Whether to give a dot diagram of a plain text version of logical
        plan.

remove(

*\*predicates: IntoExprColumn | Iterable\[IntoExprColumn\] |
[bool](https://docs.python.org/3/library/functions.html#bool) |
[list](https://docs.python.org/3/library/stdtypes.html#list)\[[bool](https://docs.python.org/3/library/functions.html#bool)\]
| np.ndarray\[Any, Any\]*,

*\*\*constraints: Any*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L4000-L4152)

Remove rows, dropping those that match the given predicate
expression(s).

The original order of the remaining rows is preserved.

Rows where the filter predicate does not evaluate to True are retained
(this includes rows where the predicate evaluates as `null`).

Parameters:

:   

    **predicates**

    :   Expression that evaluates to a boolean Series.

    **constraints**

    :   Column filters; use `name`` ``=`` ``value` to filter columns
        using the supplied value. Each constraint behaves the same as
        `pl.col(name).eq(value)`, and is implicitly joined with the
        other filter conditions using `&`.

See also

[`filter`](api/polars.LazyFrame.filter.html#polars.LazyFrame.filter)

:   

Notes

If you are transitioning from Pandas, and performing filter operations
based on the comparison of two or more columns, please note that in
Polars any comparison involving `null` values will result in a `null`
result, *not* boolean True or False. As a result, these rows will not be
removed. Ensure that null values are handled appropriately to avoid
unexpected behaviour (see examples below).

rename(

*mapping:
[Mapping](https://docs.python.org/3/library/collections.abc.html#collections.abc.Mapping)\[[str](https://docs.python.org/3/library/stdtypes.html#str),
[str](https://docs.python.org/3/library/stdtypes.html#str)\] |
[Callable](https://docs.python.org/3/library/typing.html#typing.Callable)\[\[[str](https://docs.python.org/3/library/stdtypes.html#str)\],
[str](https://docs.python.org/3/library/stdtypes.html#str)\]*,

*\**,

*strict: [bool](https://docs.python.org/3/library/functions.html#bool) =
True*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L5940-L5998)

Rename column names.

Parameters:

:   

    **mapping**

    :   Key value pairs that map from old name to new name, or a
        function that takes the old name as input and returns the new
        name.

    **strict**

    :   Validate that all column names exist in the current schema, and
        throw an exception if any do not. (Note that this parameter is a
        no-op when passing a function to `mapping`).

Notes

If existing names are swapped (e.g. 'A' points to 'B' and 'B' points to
'A'), polars will block projection and predicate pushdowns at this node.

reverse() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6000-L6024)

:   Reverse the DataFrame.

rolling(

*index_column: IntoExpr*,

*\**,

*period: [str](https://docs.python.org/3/library/stdtypes.html#str) |
timedelta*,

*offset: [str](https://docs.python.org/3/library/stdtypes.html#str) |
timedelta |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*closed: ClosedInterval = \'right\'*,

*group_by: IntoExpr | Iterable\[IntoExpr\] |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

) →
LazyGroupBy[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L4383-L4520)

Create rolling groups based on a temporal or integer column.

Different from a `group_by_dynamic` the windows are now determined by
the individual values and are not of constant intervals. For constant
intervals use
[`LazyFrame.group_by_dynamic()`](api/polars.LazyFrame.group_by_dynamic.html#polars.LazyFrame.group_by_dynamic).

If you have a time series `<t_0,`` ``t_1,`` ``...,`` ``t_n>`, then by
default the windows created will be

>      
>
> -   (t_0 - period, t_0\]
>
> -   (t_1 - period, t_1\]
>
> -   ...
>
> -   (t_n - period, t_n\]
>
>       

whereas if you pass a non-default `offset`, then the windows will be

>      
>
> -   (t_0 + offset, t_0 + offset + period\]
>
> -   (t_1 + offset, t_1 + offset + period\]
>
> -   ...
>
> -   (t_n + offset, t_n + offset + period\]
>
>       

The `period` and `offset` arguments are created either from a timedelta,
or by using the following string language:

-   1ns (1 nanosecond)

-   1us (1 microsecond)

-   1ms (1 millisecond)

-   1s (1 second)

-   1m (1 minute)

-   1h (1 hour)

-   1d (1 calendar day)

-   1w (1 calendar week)

-   1mo (1 calendar month)

-   1q (1 calendar quarter)

-   1y (1 calendar year)

-   1i (1 index count)

Or combine them: "3d12h4m25s" # 3 days, 12 hours, 4 minutes, and 25
seconds

By "calendar day", we mean the corresponding time on the next day (which
may not be 24 hours, due to daylight savings). Similarly for "calendar
week", "calendar month", "calendar quarter", and "calendar year".

Changed in version 0.20.14: The `by` parameter was renamed `group_by`.

Parameters:

:   

    **index_column**

    :   Column used to group based on the time window. Often of type
        Date/Datetime. This column must be sorted in ascending order
        (or, if `group_by` is specified, then it must be sorted in
        ascending order within each group).

        In case of a rolling group by on indices, dtype needs to be one
        of {UInt32, UInt64, Int32, Int64}. Note that the first three get
        temporarily cast to Int64, so if performance matters use an
        Int64 column.

    **period**

    :   Length of the window - must be non-negative.

    **offset**

    :   Offset of the window. Default is `-period`.

    **closed**{'right', 'left', 'both', 'none'}

    :   Define which sides of the temporal interval are closed
        (inclusive).

    **group_by**

    :   Also group by this column/these columns

Returns:

:   

    LazyGroupBy

    :   Object you can call `.agg` on to aggregate by groups, the result
        of which will be sorted by `index_column` (but note that if
        `group_by` columns are passed, it will only be sorted within
        each group).

See also

[`group_by_dynamic`](api/polars.LazyFrame.group_by_dynamic.html#polars.LazyFrame.group_by_dynamic)

:   

*property *schema*: Schema*[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L608-L641)

:   Get an ordered mapping of column names to their data type.

    Warning

    Resolving the schema of a LazyFrame is a potentially expensive
    operation. Using
    [`collect_schema()`](api/polars.LazyFrame.collect_schema.html#polars.LazyFrame.collect_schema)
    is the idiomatic way to resolve the schema. This property exists
    only for symmetry with the DataFrame class.

    See also

    [`collect_schema`](api/polars.LazyFrame.collect_schema.html#polars.LazyFrame.collect_schema)

    :   

    `Schema`

    :   

select(

*\*exprs: IntoExpr | Iterable\[IntoExpr\]*,

*\*\*named_exprs: IntoExpr*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L4154-L4243)

Select columns from this LazyFrame.

Parameters:

:   

    **\*exprs**

    :   Column(s) to select, specified as positional arguments. Accepts
        expression input. Strings are parsed as column names, other
        non-expression inputs are parsed as literals.

    **\*\*named_exprs**

    :   Additional columns to select, specified as keyword arguments.
        The columns will be renamed to the keyword used.

select_seq(

*\*exprs: IntoExpr | Iterable\[IntoExpr\]*,

*\*\*named_exprs: IntoExpr*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L4245-L4273)

Select columns from this LazyFrame.

This will run all expression sequentially instead of in parallel. Use
this when the work per expression is cheap.

Parameters:

:   

    **\*exprs**

    :   Column(s) to select, specified as positional arguments. Accepts
        expression input. Strings are parsed as column names, other
        non-expression inputs are parsed as literals.

    **\*\*named_exprs**

    :   Additional columns to select, specified as keyword arguments.
        The columns will be renamed to the keyword used.

See also

[`select`](../expressions/api/polars.select.html#polars.select)

:   

serialize(

*file: IOBase |
[str](https://docs.python.org/3/library/stdtypes.html#str) | Path |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*\**,

*format: SerializationFormat = \'binary\'*,

) → [bytes](https://docs.python.org/3/library/stdtypes.html#bytes) |
[str](https://docs.python.org/3/library/stdtypes.html#str) |
[None](https://docs.python.org/3/library/constants.html#None)[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L809-L871)

Serialize the logical plan of this LazyFrame to a file or string in JSON
format.

Parameters:

:   

    **file**

    :   File path to which the result should be written. If set to
        `None` (default), the output is returned as a string instead.

    **format**

    :   The format in which to serialize. Options:

        -   `"binary"`: Serialize to binary format (bytes). This is the
            default.

        -   `"json"`: Serialize to JSON format (string) (deprecated).

See also

[`LazyFrame.deserialize`](api/polars.LazyFrame.deserialize.html#polars.LazyFrame.deserialize)

:   

Notes

Serialization is not stable across Polars versions: a LazyFrame
serialized in one Polars version may not be deserializable in another
Polars version.

set_sorted(

*column: [str](https://docs.python.org/3/library/stdtypes.html#str)*,

*\**,

*descending:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7624-L7653)

Flag a column as sorted.

This can speed up future operations.

Parameters:

:   

    **column**

    :   Column that is sorted

    **descending**

    :   Whether the column is sorted in descending order.

Warning

This can lead to incorrect results if the data is NOT sorted!! Use with
care!

shift(

*n: [int](https://docs.python.org/3/library/functions.html#int) |
IntoExprColumn = 1*,

*\**,

*fill_value: IntoExpr |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6026-L6104)

Shift values by the given number of indices.

Parameters:

:   

    **n**

    :   Number of indices to shift forward. If a negative value is
        passed, values are shifted in the opposite direction instead.

    **fill_value**

    :   Fill the resulting null values with this value. Accepts scalar
        expression input. Non-expression inputs are parsed as literals.

Notes

This method is similar to the `LAG` operation in SQL when the value for
`n` is positive. With a negative value for `n`, it is similar to `LEAD`.

show_graph(

*\**,

*optimized:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*show: [bool](https://docs.python.org/3/library/functions.html#bool) =
True*,

*output_path: [str](https://docs.python.org/3/library/stdtypes.html#str)
| Path | [None](https://docs.python.org/3/library/constants.html#None)
= None*,

*raw_output:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*figsize:
[tuple](https://docs.python.org/3/library/stdtypes.html#tuple)\[[float](https://docs.python.org/3/library/functions.html#float),
[float](https://docs.python.org/3/library/functions.html#float)\] =
(16.0, 12.0)*,

*type_coercion:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*\_type_check:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*predicate_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*projection_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*simplify_expression:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*slice_pushdown:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*comm_subplan_elim:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*comm_subexpr_elim:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*cluster_with_columns:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*collapse_joins:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*engine: EngineType = \'auto\'*,

*plan_stage: PlanStage = \'ir\'*,

*\_check_order:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*optimizations:
[QueryOptFlags](api/polars.QueryOptFlags.html#polars.QueryOptFlags) =
()*,

) → [str](https://docs.python.org/3/library/stdtypes.html#str) |
[None](https://docs.python.org/3/library/constants.html#None)[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L1306-L1462)

Show a plot of the query plan.

Note that Graphviz must be installed to render the visualization (if not
already present, you can download it here:
<https://graphviz.org/download>).

Parameters:

:   

    **optimized**

    :   Optimize the query plan.

    **show**

    :   Show the figure.

    **output_path**

    :   Write the figure to disk.

    **raw_output**

    :   Return dot syntax. This cannot be combined with `show` and/or
        `output_path`.

    **figsize**

    :   Passed to matplotlib if `show`` ``==`` ``True`.

    **type_coercion**

    :   Do type coercion optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **predicate_pushdown**

    :   Do predicate pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **projection_pushdown**

    :   Do projection pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **simplify_expression**

    :   Run simplify expressions optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **slice_pushdown**

    :   Slice pushdown optimization.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **comm_subplan_elim**

    :   Will try to cache branching subplans that occur on self-joins or
        unions.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **comm_subexpr_elim**

    :   Common subexpressions will be cached and reused.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **cluster_with_columns**

    :   Combine sequential independent calls to with_columns.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **collapse_joins**

    :   Collapse a join and filters into a faster join.

        Deprecated since version 1.30.0: Use the `optimizations`
        parameters.

    **engine**

    :   Select the engine used to process the query, optional. At the
        moment, if set to `"auto"` (default), the query is run using the
        polars in-memory engine. Polars will also attempt to use the
        engine set by the `POLARS_ENGINE_AFFINITY` environment variable.
        If it cannot run the query using the selected engine, the query
        is run using the polars in-memory engine. If set to `"gpu"`, the
        GPU engine is used. Fine-grained control over the GPU engine,
        for example which device to use on a system with multiple
        devices, is possible by providing a
        [`GPUEngine`](api/polars.lazyframe.engine_config.GPUEngine.html#polars.lazyframe.engine_config.GPUEngine)
        object with configuration options.

        Note

        GPU mode is considered **unstable**. Not all queries will run
        successfully on the GPU, however, they should fall back
        transparently to the default engine if execution is not
        supported.

        Running with `POLARS_VERBOSE=1` will provide information if a
        query falls back (and why).

        Note

        The GPU engine does not support streaming, if streaming is
        enabled then GPU execution is switched off.

    **plan_stage**{'ir', 'physical'}

    :   Select the stage to display. Currently only the streaming engine
        has a separate physical stage, for the other engines both IR and
        physical are the same.

sink_csv(

*path: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Path |
IO\[[bytes](https://docs.python.org/3/library/stdtypes.html#bytes)\] |
IO\[[str](https://docs.python.org/3/library/stdtypes.html#str)\] |
PartitioningScheme*,

*\**,

*include_bom:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*include_header:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*separator: [str](https://docs.python.org/3/library/stdtypes.html#str) =
\',\'*,

*line_terminator:
[str](https://docs.python.org/3/library/stdtypes.html#str) = \'\\n\'*,

*quote_char: [str](https://docs.python.org/3/library/stdtypes.html#str)
= \'\"\'*,

*batch_size: [int](https://docs.python.org/3/library/functions.html#int)
= 1024*,

*datetime_format:
[str](https://docs.python.org/3/library/stdtypes.html#str) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*date_format: [str](https://docs.python.org/3/library/stdtypes.html#str)
| [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*time_format: [str](https://docs.python.org/3/library/stdtypes.html#str)
| [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*float_scientific:
[bool](https://docs.python.org/3/library/functions.html#bool) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*float_precision:
[int](https://docs.python.org/3/library/functions.html#int) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*decimal_comma:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*null_value: [str](https://docs.python.org/3/library/stdtypes.html#str)
| [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*quote_style: CsvQuoteStyle |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*maintain_order:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*storage_options:
[dict](https://docs.python.org/3/library/stdtypes.html#dict)\[[str](https://docs.python.org/3/library/stdtypes.html#str),
Any\] | [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*credential_provider: CredentialProviderFunction | Literal\[\'auto\'\]
| [None](https://docs.python.org/3/library/constants.html#None) =
\'auto\'*,

*retries: [int](https://docs.python.org/3/library/functions.html#int) =
2*,

*sync_on_close: SyncOnCloseMethod |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*mkdir: [bool](https://docs.python.org/3/library/functions.html#bool) =
False*,

*lazy: [bool](https://docs.python.org/3/library/functions.html#bool) =
False*,

*engine: EngineType = \'auto\'*,

*optimizations:
[QueryOptFlags](api/polars.QueryOptFlags.html#polars.QueryOptFlags) =
()*,

) → LazyFrame |
[None](https://docs.python.org/3/library/constants.html#None)[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L3087-L3316)

Evaluate the query in streaming mode and write to a CSV file.

This allows streaming results that are larger than RAM to be written to
disk.

Parameters:

:   

    **path**

    :   File path to which the file should be written.

    **include_bom**

    :   Whether to include UTF-8 BOM in the CSV output.

    **include_header**

    :   Whether to include header in the CSV output.

    **separator**

    :   Separate CSV fields with this symbol.

    **line_terminator**

    :   String used to end each row.

    **quote_char**

    :   Byte to use as quoting character.

    **batch_size**

    :   Number of rows that will be processed per thread.

    **datetime_format**

    :   A format string, with the specifiers defined by the
        [chrono](https://docs.rs/chrono/latest/chrono/format/strftime/index.html)
        Rust crate. If no format specified, the default
        fractional-second precision is inferred from the maximum
        timeunit found in the frame's Datetime cols (if any).

    **date_format**

    :   A format string, with the specifiers defined by the
        [chrono](https://docs.rs/chrono/latest/chrono/format/strftime/index.html)
        Rust crate.

    **time_format**

    :   A format string, with the specifiers defined by the
        [chrono](https://docs.rs/chrono/latest/chrono/format/strftime/index.html)
        Rust crate.

    **float_scientific**

    :   Whether to use scientific form always (true), never (false), or
        automatically (None) for `Float32` and `Float64` datatypes.

    **float_precision**

    :   Number of decimal places to write, applied to both `Float32` and
        `Float64` datatypes.

    **decimal_comma**

    :   Use a comma as the decimal separator instead of a point. Floats
        will be encapsulated in quotes if necessary; set the field
        separator to override.

    **null_value**

    :   A string representing null values (defaulting to the empty
        string).

    **quote_style**{'necessary', 'always', 'non_numeric', 'never'}

    :   Determines the quoting strategy used.

        -   necessary (default): This puts quotes around fields only
            when necessary. They are necessary when fields contain a
            quote, delimiter or record terminator. Quotes are also
            necessary when writing an empty record (which is
            indistinguishable from a record with one empty field). This
            is the default.

        -   always: This puts quotes around every field. Always.

        -   never: This never puts quotes around fields, even if that
            results in invalid CSV data (e.g.: by not quoting strings
            containing the separator).

        -   non_numeric: This puts quotes around all fields that are
            non-numeric. Namely, when writing a field that does not
            parse as a valid float or integer, then quotes will be used
            even if they aren\`t strictly necessary.

    **maintain_order**

    :   Maintain the order in which data is processed. Setting this to
        `False` will be slightly faster.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **storage_options**

    :   Options that indicate how to connect to a cloud provider.

        The cloud providers currently supported are AWS, GCP, and Azure.
        See supported keys here:

        -   [aws](https://docs.rs/object_store/latest/object_store/aws/enum.AmazonS3ConfigKey.html)

        -   [gcp](https://docs.rs/object_store/latest/object_store/gcp/enum.GoogleConfigKey.html)

        -   [azure](https://docs.rs/object_store/latest/object_store/azure/enum.AzureConfigKey.html)

        -   Hugging Face (`hf://`): Accepts an API key under the `token`
            parameter: `{'token':`` ``'...'}`, or by setting the
            `HF_TOKEN` environment variable.

        If `storage_options` is not provided, Polars will try to infer
        the information from environment variables.

    **credential_provider**

    :   Provide a function that can be called to provide cloud storage
        credentials. The function is expected to return a dictionary of
        credential keys along with an optional credential expiry time.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **retries**

    :   Number of retries if accessing a cloud instance fails.

    **sync_on_close: { None, 'data', 'all' }**

    :   Sync to disk when before closing a file.

        -   `None` does not sync.

        -   `data` syncs the file contents.

        -   `all` syncs the file contents and metadata.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **mkdir: bool**

    :   Recursively create all the directories in the path.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **lazy: bool**

    :   Wait to start execution until `collect` is called.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **engine**

    :   Select the engine used to process the query, optional. At the
        moment, if set to `"auto"` (default), the query is run using the
        polars streaming engine. Polars will also attempt to use the
        engine set by the `POLARS_ENGINE_AFFINITY` environment variable.
        If it cannot run the query using the selected engine, the query
        is run using the polars streaming engine.

    **optimizations**

    :   The optimization passes done during query optimization.

        This has no effect if `lazy` is set to `True`.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

Returns:

:   

    DataFrame

    :   

sink_ipc(

*path: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Path |
IO\[[bytes](https://docs.python.org/3/library/stdtypes.html#bytes)\] |
PartitioningScheme*,

*\**,

*compression: IpcCompression |
[None](https://docs.python.org/3/library/constants.html#None) =
\'uncompressed\'*,

*compat_level: CompatLevel |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*maintain_order:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*storage_options:
[dict](https://docs.python.org/3/library/stdtypes.html#dict)\[[str](https://docs.python.org/3/library/stdtypes.html#str),
Any\] | [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*credential_provider: CredentialProviderFunction | Literal\[\'auto\'\]
| [None](https://docs.python.org/3/library/constants.html#None) =
\'auto\'*,

*retries: [int](https://docs.python.org/3/library/functions.html#int) =
2*,

*sync_on_close: SyncOnCloseMethod |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*mkdir: [bool](https://docs.python.org/3/library/functions.html#bool) =
False*,

*lazy: [bool](https://docs.python.org/3/library/functions.html#bool) =
False*,

*engine: EngineType = \'auto\'*,

*optimizations:
[QueryOptFlags](api/polars.QueryOptFlags.html#polars.QueryOptFlags) =
()*,

) → LazyFrame |
[None](https://docs.python.org/3/library/constants.html#None)[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L2855-L3021)

Evaluate the query in streaming mode and write to an IPC file.

This allows streaming results that are larger than RAM to be written to
disk.

Parameters:

:   

    **path**

    :   File path to which the file should be written.

    **compression**{'uncompressed', 'lz4', 'zstd'}

    :   Choose "zstd" for good compression performance. Choose "lz4" for
        fast compression/decompression.

    **compat_level**

    :   Use a specific compatibility level when exporting Polars'
        internal data structures.

    **maintain_order**

    :   Maintain the order in which data is processed. Setting this to
        `False` will be slightly faster.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **storage_options**

    :   Options that indicate how to connect to a cloud provider.

        The cloud providers currently supported are AWS, GCP, and Azure.
        See supported keys here:

        -   [aws](https://docs.rs/object_store/latest/object_store/aws/enum.AmazonS3ConfigKey.html)

        -   [gcp](https://docs.rs/object_store/latest/object_store/gcp/enum.GoogleConfigKey.html)

        -   [azure](https://docs.rs/object_store/latest/object_store/azure/enum.AzureConfigKey.html)

        -   Hugging Face (`hf://`): Accepts an API key under the `token`
            parameter: `{'token':`` ``'...'}`, or by setting the
            `HF_TOKEN` environment variable.

        If `storage_options` is not provided, Polars will try to infer
        the information from environment variables.

    **credential_provider**

    :   Provide a function that can be called to provide cloud storage
        credentials. The function is expected to return a dictionary of
        credential keys along with an optional credential expiry time.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **retries**

    :   Number of retries if accessing a cloud instance fails.

    **sync_on_close: { None, 'data', 'all' }**

    :   Sync to disk when before closing a file.

        -   `None` does not sync.

        -   `data` syncs the file contents.

        -   `all` syncs the file contents and metadata.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **mkdir: bool**

    :   Recursively create all the directories in the path.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **lazy: bool**

    :   Wait to start execution until `collect` is called.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **engine**

    :   Select the engine used to process the query, optional. At the
        moment, if set to `"auto"` (default), the query is run using the
        polars streaming engine. Polars will also attempt to use the
        engine set by the `POLARS_ENGINE_AFFINITY` environment variable.
        If it cannot run the query using the selected engine, the query
        is run using the polars streaming engine.

        Note

        The GPU engine is currently not supported.

    **optimizations**

    :   The optimization passes done during query optimization.

        This has no effect if `lazy` is set to `True`.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

Returns:

:   

    DataFrame

    :   

sink_ndjson(

*path: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Path |
IO\[[bytes](https://docs.python.org/3/library/stdtypes.html#bytes)\] |
IO\[[str](https://docs.python.org/3/library/stdtypes.html#str)\] |
PartitioningScheme*,

*\**,

*maintain_order:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*storage_options:
[dict](https://docs.python.org/3/library/stdtypes.html#dict)\[[str](https://docs.python.org/3/library/stdtypes.html#str),
Any\] | [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*credential_provider: CredentialProviderFunction | Literal\[\'auto\'\]
| [None](https://docs.python.org/3/library/constants.html#None) =
\'auto\'*,

*retries: [int](https://docs.python.org/3/library/functions.html#int) =
2*,

*sync_on_close: SyncOnCloseMethod |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*mkdir: [bool](https://docs.python.org/3/library/functions.html#bool) =
False*,

*lazy: [bool](https://docs.python.org/3/library/functions.html#bool) =
False*,

*engine: EngineType = \'auto\'*,

*optimizations:
[QueryOptFlags](api/polars.QueryOptFlags.html#polars.QueryOptFlags) =
()*,

) → LazyFrame |
[None](https://docs.python.org/3/library/constants.html#None)[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L3354-L3495)

Evaluate the query in streaming mode and write to an NDJSON file.

This allows streaming results that are larger than RAM to be written to
disk.

Parameters:

:   

    **path**

    :   File path to which the file should be written.

    **maintain_order**

    :   Maintain the order in which data is processed. Setting this to
        `False` will be slightly faster.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **storage_options**

    :   Options that indicate how to connect to a cloud provider.

        The cloud providers currently supported are AWS, GCP, and Azure.
        See supported keys here:

        -   [aws](https://docs.rs/object_store/latest/object_store/aws/enum.AmazonS3ConfigKey.html)

        -   [gcp](https://docs.rs/object_store/latest/object_store/gcp/enum.GoogleConfigKey.html)

        -   [azure](https://docs.rs/object_store/latest/object_store/azure/enum.AzureConfigKey.html)

        -   Hugging Face (`hf://`): Accepts an API key under the `token`
            parameter: `{'token':`` ``'...'}`, or by setting the
            `HF_TOKEN` environment variable.

        If `storage_options` is not provided, Polars will try to infer
        the information from environment variables.

    **credential_provider**

    :   Provide a function that can be called to provide cloud storage
        credentials. The function is expected to return a dictionary of
        credential keys along with an optional credential expiry time.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **retries**

    :   Number of retries if accessing a cloud instance fails.

    **sync_on_close: { None, 'data', 'all' }**

    :   Sync to disk when before closing a file.

        -   `None` does not sync.

        -   `data` syncs the file contents.

        -   `all` syncs the file contents and metadata.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **mkdir: bool**

    :   Recursively create all the directories in the path.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **lazy: bool**

    :   Wait to start execution until `collect` is called.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **engine**

    :   Select the engine used to process the query, optional. At the
        moment, if set to `"auto"` (default), the query is run using the
        polars streaming engine. Polars will also attempt to use the
        engine set by the `POLARS_ENGINE_AFFINITY` environment variable.
        If it cannot run the query using the selected engine, the query
        is run using the polars streaming engine.

    **optimizations**

    :   The optimization passes done during query optimization.

        This has no effect if `lazy` is set to `True`.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

Returns:

:   

    DataFrame

    :   

sink_parquet(

*path: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Path |
IO\[[bytes](https://docs.python.org/3/library/stdtypes.html#bytes)\] |
PartitioningScheme*,

*\**,

*compression: [str](https://docs.python.org/3/library/stdtypes.html#str)
= \'zstd\'*,

*compression_level:
[int](https://docs.python.org/3/library/functions.html#int) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*statistics:
[bool](https://docs.python.org/3/library/functions.html#bool) |
[str](https://docs.python.org/3/library/stdtypes.html#str) |
[dict](https://docs.python.org/3/library/stdtypes.html#dict)\[[str](https://docs.python.org/3/library/stdtypes.html#str),
[bool](https://docs.python.org/3/library/functions.html#bool)\] = True*,

*row_group_size:
[int](https://docs.python.org/3/library/functions.html#int) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*data_page_size:
[int](https://docs.python.org/3/library/functions.html#int) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*maintain_order:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

*storage_options:
[dict](https://docs.python.org/3/library/stdtypes.html#dict)\[[str](https://docs.python.org/3/library/stdtypes.html#str),
Any\] | [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*credential_provider: CredentialProviderFunction | Literal\[\'auto\'\]
| [None](https://docs.python.org/3/library/constants.html#None) =
\'auto\'*,

*retries: [int](https://docs.python.org/3/library/functions.html#int) =
2*,

*sync_on_close: SyncOnCloseMethod |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*metadata: ParquetMetadata |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*mkdir: [bool](https://docs.python.org/3/library/functions.html#bool) =
False*,

*lazy: [bool](https://docs.python.org/3/library/functions.html#bool) =
False*,

*field_overwrites:
[ParquetFieldOverwrites](../api/polars.io.parquet.ParquetFieldOverwrites.html#polars.io.parquet.ParquetFieldOverwrites)
|
Sequence\[[ParquetFieldOverwrites](../api/polars.io.parquet.ParquetFieldOverwrites.html#polars.io.parquet.ParquetFieldOverwrites)\]
| Mapping\[[str](https://docs.python.org/3/library/stdtypes.html#str),
[ParquetFieldOverwrites](../api/polars.io.parquet.ParquetFieldOverwrites.html#polars.io.parquet.ParquetFieldOverwrites)\]
| [None](https://docs.python.org/3/library/constants.html#None) = None*,

*engine: EngineType = \'auto\'*,

*optimizations:
[QueryOptFlags](api/polars.QueryOptFlags.html#polars.QueryOptFlags) =
()*,

) → LazyFrame |
[None](https://docs.python.org/3/library/constants.html#None)[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L2546-L2813)

Evaluate the query in streaming mode and write to a Parquet file.

This allows streaming results that are larger than RAM to be written to
disk.

Parameters:

:   

    **path**

    :   File path to which the file should be written.

    **compression**{'lz4', 'uncompressed', 'snappy', 'gzip', 'lzo', 'brotli', 'zstd'}

    :   Choose "zstd" for good compression performance. Choose "lz4" for
        fast compression/decompression. Choose "snappy" for more
        backwards compatibility guarantees when you deal with older
        parquet readers.

    **compression_level**

    :   The level of compression to use. Higher compression means
        smaller files on disk.

        -   "gzip" : min-level: 0, max-level: 9.

        -   "brotli" : min-level: 0, max-level: 11.

        -   "zstd" : min-level: 1, max-level: 22.

    **statistics**

    :   Write statistics to the parquet headers. This is the default
        behavior.

        Possible values:

        -   `True`: enable default set of statistics (default). Some
            statistics may be disabled.

        -   `False`: disable all statistics

        -   "full": calculate and write all available statistics. Cannot
            be combined with `use_pyarrow`.

        -   `{`` ``"statistic-key":`` ``True`` ``/`` ``False,`` ``...`` ``}`.
            Cannot be combined with `use_pyarrow`. Available keys:

            -   "min": column minimum value (default: `True`)

            -   "max": column maximum value (default: `True`)

            -   "distinct_count": number of unique column values
                (default: `False`)

            -   "null_count": number of null values in column (default:
                `True`)

    **row_group_size**

    :   Size of the row groups in number of rows. If None (default), the
        chunks of the `DataFrame` are used. Writing in smaller chunks
        may reduce memory pressure and improve writing speeds.

    **data_page_size**

    :   Size limit of individual data pages. If not set defaults to 1024
        \* 1024 bytes

    **maintain_order**

    :   Maintain the order in which data is processed. Setting this to
        `False` will be slightly faster.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **storage_options**

    :   Options that indicate how to connect to a cloud provider.

        The cloud providers currently supported are AWS, GCP, and Azure.
        See supported keys here:

        -   [aws](https://docs.rs/object_store/latest/object_store/aws/enum.AmazonS3ConfigKey.html)

        -   [gcp](https://docs.rs/object_store/latest/object_store/gcp/enum.GoogleConfigKey.html)

        -   [azure](https://docs.rs/object_store/latest/object_store/azure/enum.AzureConfigKey.html)

        -   Hugging Face (`hf://`): Accepts an API key under the `token`
            parameter: `{'token':`` ``'...'}`, or by setting the
            `HF_TOKEN` environment variable.

        If `storage_options` is not provided, Polars will try to infer
        the information from environment variables.

    **credential_provider**

    :   Provide a function that can be called to provide cloud storage
        credentials. The function is expected to return a dictionary of
        credential keys along with an optional credential expiry time.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **retries**

    :   Number of retries if accessing a cloud instance fails.

    **sync_on_close: { None, 'data', 'all' }**

    :   Sync to disk when before closing a file.

        -   `None` does not sync.

        -   `data` syncs the file contents.

        -   `all` syncs the file contents and metadata.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **metadata**

    :   A dictionary or callback to add key-values to the file-level
        Parquet metadata.

        Warning

        This functionality is considered **experimental**. It may be
        removed or changed at any point without it being considered a
        breaking change.

    **mkdir: bool**

    :   Recursively create all the directories in the path.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **lazy: bool**

    :   Wait to start execution until `collect` is called.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **field_overwrites**

    :   Property overwrites for individual Parquet fields.

        This allows more control over the writing process to the
        granularity of a Parquet field.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

    **engine**

    :   Select the engine used to process the query, optional. At the
        moment, if set to `"auto"` (default), the query is run using the
        polars streaming engine. Polars will also attempt to use the
        engine set by the `POLARS_ENGINE_AFFINITY` environment variable.
        If it cannot run the query using the selected engine, the query
        is run using the polars streaming engine.

    **optimizations**

    :   The optimization passes done during query optimization.

        This has no effect if `lazy` is set to `True`.

        Warning

        This functionality is considered **unstable**. It may be changed
        at any point without it being considered a breaking change.

Returns:

:   

    DataFrame

    :   

slice(

*offset: [int](https://docs.python.org/3/library/functions.html#int)*,

*length: [int](https://docs.python.org/3/library/functions.html#int) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6106-L6141)

Get a slice of this DataFrame.

Parameters:

:   

    **offset**

    :   Start index. Negative indexing is supported.

    **length**

    :   Length of the slice. If set to `None`, all rows starting at the
        offset will be selected.

sort(

*by: IntoExpr | Iterable\[IntoExpr\]*,

*\*more_by: IntoExpr*,

*descending:
[bool](https://docs.python.org/3/library/functions.html#bool) |
Sequence\[[bool](https://docs.python.org/3/library/functions.html#bool)\]
= False*,

*nulls_last:
[bool](https://docs.python.org/3/library/functions.html#bool) |
Sequence\[[bool](https://docs.python.org/3/library/functions.html#bool)\]
= False*,

*maintain_order:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*multithreaded:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L1490-L1608)

Sort the LazyFrame by the given columns.

Parameters:

:   

    **by**

    :   Column(s) to sort by. Accepts expression input, including
        selectors. Strings are parsed as column names.

    **\*more_by**

    :   Additional columns to sort by, specified as positional
        arguments.

    **descending**

    :   Sort in descending order. When sorting by multiple columns, can
        be specified per column by passing a sequence of booleans.

    **nulls_last**

    :   Place null values last; can specify a single boolean applying to
        all columns or a sequence of booleans for per-column control.

    **maintain_order**

    :   Whether the order should be maintained if elements are equal.
        Note that if `true` streaming is not possible and performance
        might be worse since this requires a stable search.

    **multithreaded**

    :   Sort using multiple threads.

sql(

*query: [str](https://docs.python.org/3/library/stdtypes.html#str)*,

*\**,

*table_name: [str](https://docs.python.org/3/library/stdtypes.html#str)
= \'self\'*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L1610-L1692)

Execute a SQL query against the LazyFrame.

Added in version 0.20.23.

Warning

This functionality is considered **unstable**, although it is close to
being considered stable. It may be changed at any point without it being
considered a breaking change.

Parameters:

:   

    **query**

    :   SQL query to execute.

    **table_name**

    :   Optionally provide an explicit name for the table that
        represents the calling frame (defaults to "self").

See also

[`SQLContext`](../sql/python_api.html#polars.SQLContext)

:   

Notes

-   The calling frame is automatically registered as a table in the SQL
    context under the name "self". If you want access to the DataFrames
    and LazyFrames found in the current globals, use the top-level
    [`pl.sql`](../expressions/api/polars.sql.html#polars.sql).

-   More control over registration and execution behaviour is available
    by using the
    [`SQLContext`](../sql/python_api.html#polars.SQLContext) object.

std(*ddof: [int](https://docs.python.org/3/library/functions.html#int) = 1*) → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6703-L6741)

:   Aggregate the columns in the LazyFrame to their standard deviation
    value.

    Parameters:

    :   

        **ddof**

        :   "Delta Degrees of Freedom": the divisor used in the
            calculation is N - ddof, where N represents the number of
            elements. By default ddof is 1.

<!-- -->

sum() → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6831-L6853)

:   Aggregate the columns in the LazyFrame to their sum value.

<!-- -->

tail(*n: [int](https://docs.python.org/3/library/functions.html#int) = 5*) → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6231-L6272)

:   Get the last `n` rows.

    Parameters:

    :   

        **n**

        :   Number of rows to return.

top_k(

*k: [int](https://docs.python.org/3/library/functions.html#int)*,

*\**,

*by: IntoExpr | Iterable\[IntoExpr\]*,

*reverse: [bool](https://docs.python.org/3/library/functions.html#bool)
|
Sequence\[[bool](https://docs.python.org/3/library/functions.html#bool)\]
= False*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L1694-L1770)

Return the `k` largest rows.

Non-null elements are always preferred over null elements, regardless of
the value of `reverse`. The output is not guaranteed to be in any
particular order, call
[`sort()`](api/polars.LazyFrame.sort.html#polars.LazyFrame.sort) after
this function if you wish the output to be sorted.

Changed in version 1.0.0: The `descending` parameter was renamed
`reverse`.

Parameters:

:   

    **k**

    :   Number of rows to return.

    **by**

    :   Column(s) used to determine the top rows. Accepts expression
        input. Strings are parsed as column names.

    **reverse**

    :   Consider the `k` smallest elements of the `by` column(s)
        (instead of the `k` largest). This can be specified per column
        by passing a sequence of booleans.

See also

[`bottom_k`](api/polars.LazyFrame.bottom_k.html#polars.LazyFrame.bottom_k)

:   

unique(

*subset: ColumnNameOrSelector | Collection\[ColumnNameOrSelector\] |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*\**,

*keep: UniqueKeepStrategy = \'any\'*,

*maintain_order:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7010-L7098)

Drop duplicate rows from this DataFrame.

Parameters:

:   

    **subset**

    :   Column name(s) or selector(s), to consider when identifying
        duplicate rows. If set to `None` (default), use all columns.

    **keep**{'first', 'last', 'any', 'none'}

    :   Which of the duplicate rows to keep.

        -   

            'any': Does not give any guarantee of which row is kept.

            :   This allows more optimizations.

        -   'none': Don't keep duplicate rows.

        -   'first': Keep first unique row.

        -   'last': Keep last unique row.

    **maintain_order**

    :   Keep the same order as the original DataFrame. This is more
        expensive to compute. Settings this to `True` blocks the
        possibility to run on the streaming engine.

Returns:

:   

    LazyFrame

    :   LazyFrame with unique rows.

Warning

This method will fail if there is a column of type `List` in the
DataFrame or subset.

Notes

If you're coming from pandas, this is similar to
`pandas.DataFrame.drop_duplicates`.

unnest(

*columns: ColumnNameOrSelector | Collection\[ColumnNameOrSelector\]*,

*\*more_columns: ColumnNameOrSelector*,

) →
LazyFrame[\[source\]](https://github.pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7493-L7547)

Decompose struct columns into separate columns for each of their fields.

The new columns will be inserted into the DataFrame at the location of
the struct column.

Parameters:

:   

    **columns**

    :   Name of the struct column(s) that should be unnested.

    **\*more_columns**

    :   Additional columns to unnest, specified as positional arguments.

unpivot(

*on: ColumnNameOrSelector | Sequence\[ColumnNameOrSelector\] |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*\**,

*index: ColumnNameOrSelector | Sequence\[ColumnNameOrSelector\] |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*variable_name:
[str](https://docs.python.org/3/library/stdtypes.html#str) |
[None](https://docs.python.org/3/library/constants.html#None) = None*,

*value_name: [str](https://docs.python.org/3/library/stdtypes.html#str)
| [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*streamable:
[bool](https://docs.python.org/3/library/functions.html#bool) = True*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7273-L7358)

Unpivot a DataFrame from wide to long format.

Optionally leaves identifiers set.

This function is useful to massage a DataFrame into a format where one
or more columns are identifier variables (index) while all other
columns, considered measured variables (on), are "unpivoted" to the row
axis leaving just two non-identifier columns, 'variable' and 'value'.

Parameters:

:   

    **on**

    :   Column(s) or selector(s) to use as values variables; if `on` is
        empty all columns that are not in `index` will be used.

    **index**

    :   Column(s) or selector(s) to use as identifier variables.

    **variable_name**

    :   Name to give to the `variable` column. Defaults to "variable"

    **value_name**

    :   Name to give to the `value` column. Defaults to "value"

    **streamable**

    :   deprecated

Notes

If you're coming from pandas, this is similar to
`pandas.DataFrame.melt`, but with `index` replacing `id_vars` and `on`
replacing `value_vars`. In other frameworks, you might know this
operation as `pivot_longer`.

update(

*other: LazyFrame*,

*on: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Sequence\[[str](https://docs.python.org/3/library/stdtypes.html#str)\]
| [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*how: Literal\[\'left\', \'inner\', \'full\'\] = \'left\'*,

*\**,

*left_on: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Sequence\[[str](https://docs.python.org/3/library/stdtypes.html#str)\]
| [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*right_on: [str](https://docs.python.org/3/library/stdtypes.html#str) |
Sequence\[[str](https://docs.python.org/3/library/stdtypes.html#str)\]
| [None](https://docs.python.org/3/library/constants.html#None) =
None*,

*include_nulls:
[bool](https://docs.python.org/3/library/functions.html#bool) = False*,

*maintain_order: MaintainOrderJoin |
[None](https://docs.python.org/3/library/constants.html#None) =
\'left\'*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L7655-L7894)

Update the values in this `LazyFrame` with the values in `other`.

Warning

This functionality is considered **unstable**. It may be changed at any
point without it being considered a breaking change.

Parameters:

:   

    **other**

    :   LazyFrame that will be used to update the values

    **on**

    :   Column names that will be joined on. If set to `None` (default),
        the implicit row index of each frame is used as a join key.

    **how**{'left', 'inner', 'full'}

    :   -   'left' will keep all rows from the left table; rows may be
            duplicated if multiple rows in the right frame match the
            left row's key.

        -   'inner' keeps only those rows where the key exists in both
            frames.

        -   'full' will update existing rows where the key matches while
            also adding any new rows contained in the given frame.

    **left_on**

    :   Join column(s) of the left DataFrame.

    **right_on**

    :   Join column(s) of the right DataFrame.

    **include_nulls**

    :   Overwrite values in the left frame with null values from the
        right frame. If set to `False` (default), null values in the
        right frame are ignored.

    **maintain_order**{'none', 'left', 'right', 'left_right', 'right_left'}

    :   Which order of rows from the inputs to preserve. See
        [`join()`](api/polars.LazyFrame.join.html#polars.LazyFrame.join)
        for details. Unlike `join` this function preserves the left
        order by default.

Notes

This is syntactic sugar for a left/inner join that preserves the order
of the left `DataFrame` by default, with an optional coalesce when
`include_nulls`` ``=`` ``False`.

var(*ddof: [int](https://docs.python.org/3/library/functions.html#int) = 1*) → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6743-L6781)

:   Aggregate the columns in the LazyFrame to their variance value.

    Parameters:

    :   

        **ddof**

        :   "Delta Degrees of Freedom": the divisor used in the
            calculation is N - ddof, where N represents the number of
            elements. By default ddof is 1.

<!-- -->

*property *width*: [int](https://docs.python.org/3/library/functions.html#int)*[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L643-L681)

:   Get the number of columns.

    Returns:

    :   

        int

        :   

    Warning

    Determining the width of a LazyFrame requires resolving its schema,
    which is a potentially expensive operation. Using
    [`collect_schema()`](api/polars.LazyFrame.collect_schema.html#polars.LazyFrame.collect_schema)
    is the idiomatic way to resolve the schema. This property exists
    only for symmetry with the DataFrame class.

    See also

    [`collect_schema`](api/polars.LazyFrame.collect_schema.html#polars.LazyFrame.collect_schema)

    :   

    `Schema.len`

    :   

with_columns(

*\*exprs: IntoExpr | Iterable\[IntoExpr\]*,

*\*\*named_exprs: IntoExpr*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L5622-L5754)

Add columns to this LazyFrame.

Added columns will replace existing columns with the same name.

Parameters:

:   

    **\*exprs**

    :   Column(s) to add, specified as positional arguments. Accepts
        expression input. Strings are parsed as column names, other
        non-expression inputs are parsed as literals.

    **\*\*named_exprs**

    :   Additional columns to add, specified as keyword arguments. The
        columns will be renamed to the keyword used.

Returns:

:   

    LazyFrame

    :   A new LazyFrame with the columns added.

Notes

Creating a new LazyFrame using this method does not create a new copy of
existing data.

with_columns_seq(

*\*exprs: IntoExpr | Iterable\[IntoExpr\]*,

*\*\*named_exprs: IntoExpr*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L5756-L5793)

Add columns to this LazyFrame.

Added columns will replace existing columns with the same name.

This will run all expression sequentially instead of in parallel. Use
this when the work per expression is cheap.

Parameters:

:   

    **\*exprs**

    :   Column(s) to add, specified as positional arguments. Accepts
        expression input. Strings are parsed as column names, other
        non-expression inputs are parsed as literals.

    **\*\*named_exprs**

    :   Additional columns to add, specified as keyword arguments. The
        columns will be renamed to the keyword used.

Returns:

:   

    LazyFrame

    :   A new LazyFrame with the columns added.

See also

[`with_columns`](api/polars.LazyFrame.with_columns.html#polars.LazyFrame.with_columns)

:   

with_context(*other: Self | [list](https://docs.python.org/3/library/stdtypes.html#list)\[Self\]*) → LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L5795-L5859)

:   Add an external context to the computation graph.

    Deprecated since version 1.0.0: Use
    [`concat()`](../api/polars.concat.html#polars.concat) instead, with
    `how='horizontal'`

    This allows expressions to also access columns from DataFrames that
    are not part of this one.

    Parameters:

    :   

        **other**

        :   Lazy DataFrame to join with.

with_row_count(

*name: [str](https://docs.python.org/3/library/stdtypes.html#str) =
\'row_nr\'*,

*offset: [int](https://docs.python.org/3/library/functions.html#int) =
0*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6432-L6476)

Add a column at index 0 that counts the rows.

Deprecated since version 0.20.4: Use the
[`with_row_index()`](api/polars.LazyFrame.with_row_index.html#polars.LazyFrame.with_row_index)
method instead. Note that the default column name has changed from
'row_nr' to 'index'.

Parameters:

:   

    **name**

    :   Name of the column to add.

    **offset**

    :   Start the row count at this offset.

Warning

This can have a negative effect on query performance. This may, for
instance, block predicate pushdown optimization.

with_row_index(

*name: [str](https://docs.python.org/3/library/stdtypes.html#str) =
\'index\'*,

*offset: [int](https://docs.python.org/3/library/functions.html#int) =
0*,

) →
LazyFrame[\[source\]](https://github.com/pola-rs/polars/blob/py-1.32.3/py-polars/polars/lazyframe/frame.py#L6355-L6430)

Add a row index as the first column in the LazyFrame.

Parameters:

:   

    **name**

    :   Name of the index column.

    **offset**

    :   Start the index at this offset. Cannot be negative.

Warning

Using this function can have a negative effect on query performance.
This may, for instance, block predicate pushdown optimization.

Notes

The resulting column does not have any special properties. It is a
regular column of type `UInt32` (or `UInt64` in `polars-u64-idx`).

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

[](../dataframe/style.html)

previous

Style

[](aggregation.html)

next

Aggregation
