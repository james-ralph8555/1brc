# Streaming

One additional benefit of the lazy API is that it allows queries to be
executed in a streaming manner. Instead of processing all the data at
once, Polars can execute the query in batches allowing you to process
datasets that do not fit in memory. Besides memory pressure, the
streaming engine also is more performant than Polars' in-memory engine.

To tell Polars we want to execute a query in streaming mode we pass the
`engine="streaming"` argument to `collect`:

[ Python](#__tabbed_1_1)[ Rust](#__tabbed_1_2)

[`collect`](https://docs.pola.rs/api/python/stable/reference/lazyframe/api/polars.LazyFrame.collect.html)

    q1 = (
        pl.scan_csv("docs/assets/data/iris.csv")
        .filter(pl.col("sepal_length") > 5)
        .group_by("species")
        .agg(pl.col("sepal_width").mean())
    )
    df = q1.collect(engine="streaming")

[`collect`](https://docs.pola.rs/api/rust/dev/polars/prelude/struct.LazyFrame.html#method.collect)
·[ Available on feature
streaming](https://docs.pola.rs/user-guide/installation/#feature-flags)

    let q1 = LazyCsvReader::new(PlPath::new("docs/assets/data/iris.csv"))
        .with_has_header(true)
        .finish()?
        .filter(col("sepal_length").gt(lit(5)))
        .group_by(vec![col("species")])
        .agg([col("sepal_width").mean()]);

    let df = q1.clone().with_new_streaming(true).collect()?;
    println!("{df}");

## Inspecting a streaming query

Polars can run many operations in a streaming manner. Some operations
are inherently non-streaming, or are not implemented in a streaming
manner (yet). In the latter case, Polars will fall back to the in-memory
engine for those operations. A user doesn't have to know about this,
but it can be interesting for debugging memory or performance issues.

To inspect the physical plan of streaming query, you can plot the
physical graph. The legend shows how memory intensive the operation can
be.

    q1 = (
        pl.scan_csv("docs/assets/data/iris.csv")
        .filter(pl.col("sepal_length") > 5)
        .group_by("species")
        .agg(
            mean_width=pl.col("sepal_width").mean(),
            mean_width2=pl.col("sepal_width").sum() / pl.col("sepal_length").count(),
        )
        .show_graph(plan_stage="physical", engine="streaming")
    )
