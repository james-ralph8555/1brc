     

-   [](../index.html)
-   [Python API reference](index.html)
-   Config

:::::::::::::::::::: section
# Config[\#](#config)

:::: section
## Config options[\#](#config-options)

  -------------------------------------------------------------------------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------------
  [`Config.set_ascii_tables`](api/polars.Config.set_ascii_tables.html#polars.Config.set_ascii_tables)(\[active\])                                                Use ASCII characters to display table outlines.
  [`Config.set_auto_structify`](api/polars.Config.set_auto_structify.html#polars.Config.set_auto_structify)(\[active\])                                          Allow multi-output expressions to be automatically turned into Structs.
  [`Config.set_decimal_separator`](api/polars.Config.set_decimal_separator.html#polars.Config.set_decimal_separator)(\[separator\])                              Set the decimal separator character.
  [`Config.set_engine_affinity`](api/polars.Config.set_engine_affinity.html#polars.Config.set_engine_affinity)(\[engine\])                                       Set which engine to use by default.
  [`Config.set_float_precision`](api/polars.Config.set_float_precision.html#polars.Config.set_float_precision)(\[precision\])                                    Control the number of decimal places displayed for floating point values.
  [`Config.set_fmt_float`](api/polars.Config.set_fmt_float.html#polars.Config.set_fmt_float)(\[fmt\])                                                            Control how floating point values are displayed.
  [`Config.set_fmt_str_lengths`](api/polars.Config.set_fmt_str_lengths.html#polars.Config.set_fmt_str_lengths)(n)                                                Set the number of characters used to display string values.
  [`Config.set_fmt_table_cell_list_len`](api/polars.Config.set_fmt_table_cell_list_len.html#polars.Config.set_fmt_table_cell_list_len)(n)                        Set the number of elements to display for List values.
  [`Config.set_streaming_chunk_size`](api/polars.Config.set_streaming_chunk_size.html#polars.Config.set_streaming_chunk_size)(size)                              Overwrite chunk size used in `streaming` engine.
  [`Config.set_tbl_cell_alignment`](api/polars.Config.set_tbl_cell_alignment.html#polars.Config.set_tbl_cell_alignment)(format)                                  Set table cell alignment.
  [`Config.set_tbl_cell_numeric_alignment`](api/polars.Config.set_tbl_cell_numeric_alignment.html#polars.Config.set_tbl_cell_numeric_alignment)(format)          Set table cell alignment for numeric columns.
  [`Config.set_tbl_cols`](api/polars.Config.set_tbl_cols.html#polars.Config.set_tbl_cols)(n)                                                                     Set the number of columns that are visible when displaying tables.
  [`Config.set_tbl_column_data_type_inline`](api/polars.Config.set_tbl_column_data_type_inline.html#polars.Config.set_tbl_column_data_type_inline)(\[active\])   Display the data type next to the column name (to the right, in parentheses).
  [`Config.set_tbl_dataframe_shape_below`](api/polars.Config.set_tbl_dataframe_shape_below.html#polars.Config.set_tbl_dataframe_shape_below)(\[active\])         Print the DataFrame shape information below the data when displaying tables.
  [`Config.set_tbl_formatting`](api/polars.Config.set_tbl_formatting.html#polars.Config.set_tbl_formatting)(\[format, \...\])                                    Set table formatting style.
  [`Config.set_tbl_hide_column_data_types`](api/polars.Config.set_tbl_hide_column_data_types.html#polars.Config.set_tbl_hide_column_data_types)(\[active\])      Hide table column data types (i64, f64, str etc.).
  [`Config.set_tbl_hide_column_names`](api/polars.Config.set_tbl_hide_column_names.html#polars.Config.set_tbl_hide_column_names)(\[active\])                     Hide table column names.
  [`Config.set_tbl_hide_dataframe_shape`](api/polars.Config.set_tbl_hide_dataframe_shape.html#polars.Config.set_tbl_hide_dataframe_shape)(\[active\])            Hide the DataFrame shape information when displaying tables.
  [`Config.set_tbl_hide_dtype_separator`](api/polars.Config.set_tbl_hide_dtype_separator.html#polars.Config.set_tbl_hide_dtype_separator)(\[active\])            Hide the \'\-\-\-\' separator displayed between the column names and column types.
  [`Config.set_tbl_rows`](api/polars.Config.set_tbl_rows.html#polars.Config.set_tbl_rows)(n)                                                                     Set the max number of rows used to draw the table (both Dataframe and Series).
  [`Config.set_tbl_width_chars`](api/polars.Config.set_tbl_width_chars.html#polars.Config.set_tbl_width_chars)(width)                                            Set the maximum width of a table in characters.
  [`Config.set_thousands_separator`](api/polars.Config.set_thousands_separator.html#polars.Config.set_thousands_separator)(\[separator\])                        Set the thousands grouping separator character.
  [`Config.set_trim_decimal_zeros`](api/polars.Config.set_trim_decimal_zeros.html#polars.Config.set_trim_decimal_zeros)(\[active\])                              Strip trailing zeros from Decimal data type values.
  [`Config.set_verbose`](api/polars.Config.set_verbose.html#polars.Config.set_verbose)(\[active\])                                                               Enable additional verbose/debug logging.
  -------------------------------------------------------------------------------------------------------------------------------------------------------------- -----------------------------------------------------------------------------------

::::

:::::: section
## Config load, save, state[\#](#config-load-save-state)

  ------------------------------------------------------------------------------------------------------- ------------------------------------------------------------------------------
  [`Config.load`](api/polars.Config.load.html#polars.Config.load)(cfg)                                    Load (and set) previously saved Config options from a JSON string.
  [`Config.load_from_file`](api/polars.Config.load_from_file.html#polars.Config.load_from_file)(file)     Load (and set) previously saved Config options from file.
  [`Config.save`](api/polars.Config.save.html#polars.Config.save)(\*\[, if_set\])                         Save the current set of Config options as a JSON string.
  [`Config.save_to_file`](api/polars.Config.save_to_file.html#polars.Config.save_to_file)(file)           Save the current set of Config options as a JSON file.
  [`Config.state`](api/polars.Config.state.html#polars.Config.state)(\*\[, if_set, env_only\])            Show the current state of all Config variables in the environment as a dict.
  [`Config.restore_defaults`](api/polars.Config.restore_defaults.html#polars.Config.restore_defaults)()   Reset all polars Config settings to their default state.
  ------------------------------------------------------------------------------------------------------- ------------------------------------------------------------------------------

While it is easy to restore *all* configuration options to their default
value using `restore_defaults`, it can also be useful to reset
*individual* options. This can be done by setting the related value to
`None`, eg:

    pl.Config.set_tbl_rows(None)

::::::

::::::: section
## Use as a context manager[\#](#use-as-a-context-manager)

Note that `Config` supports setting context-scoped options. These
options are valid *only* during scope lifetime, and are reset to their
initial values (whatever they were before entering the new context) on
scope exit.

You can take advantage of this by initialising a `Config` instance and
then explicitly calling one or more of the available "set\_" methods on
it...

    with pl.Config() as cfg:
        cfg.set_verbose(True)
        do_various_things()

    # on scope exit any modified settings are restored to their previous state

...or, often cleaner, by setting the options in the `Config` init
directly (optionally omitting the "set\_" prefix for brevity):

    with pl.Config(verbose=True):
        do_various_things()

:::::::

::::: section
## Use as a decorator[\#](#use-as-a-decorator)

In the same vein, you can also use a `Config` instance as a function
decorator to temporarily set options for the duration of the function
call:

    cfg_ascii_frames = pl.Config(ascii_tables=True, apply_on_context_enter=True)

    @cfg_ascii_frames
    def write_markdown_frame_to_stdout(df: pl.DataFrame) -> None:
        sys.stdout.write(str(df))

:::::

::::: section
## Multiple Config instances[\#](#multiple-config-instances)

You may want to establish related bundles of `Config` options for use in
different parts of your code. Usually options are set immediately on
`Config` init, meaning the `Config` instance cannot be reused; however,
you can defer this so that options are only invoked when entering
context scope (which includes function entry if used as a decorator).\_

This allows you to create multiple *reusable* `Config` instances in one
place, update and modify them centrally, and apply them as needed
throughout your codebase.

    cfg_verbose = pl.Config(verbose=True, apply_on_context_enter=True)
    cfg_markdown = pl.Config(tbl_formatting="MARKDOWN", apply_on_context_enter=True)

    @cfg_markdown
    def write_markdown_frame_to_stdout(df: pl.DataFrame) -> None:
        sys.stdout.write(str(df))

    @cfg_verbose
    def do_various_things():
        ...

:::::
::::::::::::::::::::

[](catalog/api/polars.catalog.unity.TableType.html)

previous

polars.catalog.unity.TableType

[](api/polars.Config.set_ascii_tables.html)

next

polars.Config.set_ascii_tables

On this page

-   [Config options](#config-options)
-   [Config load, save, state](#config-load-save-state)
-   [Use as a context manager](#use-as-a-context-manager)
-   [Use as a decorator](#use-as-a-decorator)
-   [Multiple Config instances](#multiple-config-instances)
