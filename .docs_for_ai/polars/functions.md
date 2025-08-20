     

-   [](../index.html)
-   [Python API reference](index.html)
-   Functions

::::::::::::: section
# Functions[\#](#functions)

:::: section
## Conversion[\#](#conversion)

  ----------------------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------------
  [`from_arrow`](api/polars.from_arrow.html#polars.from_arrow)(data\[, schema, schema_overrides, \...\])      Create a DataFrame or Series from an Arrow Table or Array.
  [`from_dataframe`](api/polars.from_dataframe.html#polars.from_dataframe)(df, \*\[, allow_copy, rechunk\])   Build a Polars DataFrame from any dataframe supporting the PyCapsule Interface.
  [`from_dict`](api/polars.from_dict.html#polars.from_dict)(data\[, schema, schema_overrides, \...\])         Construct a DataFrame from a dictionary of sequences.
  [`from_dicts`](api/polars.from_dicts.html#polars.from_dicts)(data\[, schema, schema_overrides, \...\])      Construct a DataFrame from a sequence of dictionaries.
  [`from_numpy`](api/polars.from_numpy.html#polars.from_numpy)(data\[, schema, schema_overrides, \...\])      Construct a DataFrame from a NumPy ndarray.
  [`from_pandas`](api/polars.from_pandas.html#polars.from_pandas)(data, \*\[, schema_overrides, \...\])       Construct a Polars DataFrame or Series from a pandas DataFrame, Series, or Index.
  [`from_records`](api/polars.from_records.html#polars.from_records)(data\[, schema, \...\])                  Construct a DataFrame from a sequence of sequences.
  [`from_repr`](api/polars.from_repr.html#polars.from_repr)(data)                                             Construct a Polars DataFrame or Series from its string representation.
  [`json_normalize`](api/polars.json_normalize.html#polars.json_normalize)(data, \*\[, separator, \...\])     Normalize semi-structured deserialized JSON data into a flat table.
  ----------------------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------------

::::

:::: section
## Miscellaneous[\#](#miscellaneous)

  --------------------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------------
  [`align_frames`](api/polars.align_frames.html#polars.align_frames)(\*frames, on\[, how, select, \...\])   Align a sequence of frames using common values from one or more columns as a key.
  [`concat`](api/polars.concat.html#polars.concat)(items, \*\[, how, rechunk, parallel\])                   Combine multiple DataFrames, LazyFrames, or Series into a single object.
  [`defer`](api/polars.defer.html#polars.defer)(function, \*, schema\[, validate_schema\])                  Deferred execution.
  [`escape_regex`](api/polars.escape_regex.html#polars.escape_regex)(s)                                     Escapes string regex meta characters.
  --------------------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------------

::::

:::: section
## Multiple queries[\#](#multiple-queries)

  ---------------------------------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------
  [`collect_all`](api/polars.collect_all.html#polars.collect_all)(lazy_frames, \*\[, type_coercion, \...\])              Collect multiple LazyFrames at the same time.
  [`collect_all_async`](api/polars.collect_all_async.html#polars.collect_all_async)(lazy_frames, \*\[, gevent, \...\])   Collect multiple LazyFrames at the same time asynchronously in thread pool.
  [`explain_all`](api/polars.explain_all.html#polars.explain_all)(lazy_frames, \*\[, optimizations\])                    Explain multiple LazyFrames as if passed to `collect_all`.
  ---------------------------------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------

::::

:::: section
## Random[\#](#random)

  ----------------------------------------------------------------------------------- ----------------------------------------
  [`set_random_seed`](api/polars.set_random_seed.html#polars.set_random_seed)(seed)   Set the global random seed for Polars.
  ----------------------------------------------------------------------------------- ----------------------------------------

::::

:::: section
## StringCache[\#](#stringcache)

Note that the `StringCache` can be used as both a context manager and a
decorator, in order to explicitly scope cache lifetime.

  ---------------------------------------------------------------------------------------------- ---------------------------------------------------------------------
  [`StringCache`](api/polars.StringCache.html#polars.StringCache)()                              Context manager for enabling and disabling the global string cache.
  [`enable_string_cache`](api/polars.enable_string_cache.html#polars.enable_string_cache)()      Enable the global string cache.
  [`disable_string_cache`](api/polars.disable_string_cache.html#polars.disable_string_cache)()   Disable and clear the global string cache.
  [`using_string_cache`](api/polars.using_string_cache.html#polars.using_string_cache)()         Check whether the global string cache is enabled.
  ---------------------------------------------------------------------------------------------- ---------------------------------------------------------------------

::::
:::::::::::::

[](datatype_expr/api/polars.DataTypeExpr.struct.field_names.html)

previous

polars.DataTypeExpr.struct.field_names

[](api/polars.from_arrow.html)

next

polars.from_arrow

On this page

-   [Conversion](#conversion)
-   [Miscellaneous](#miscellaneous)
-   [Multiple queries](#multiple-queries)
-   [Random](#random)
-   [StringCache](#stringcache)
