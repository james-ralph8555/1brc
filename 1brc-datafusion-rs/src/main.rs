use datafusion::arrow::datatypes::{DataType, Field, Schema};
use datafusion::error::Result;
use datafusion::execution::context::SessionConfig;
use datafusion::functions_aggregate::expr_fn::{avg, max, min};
use datafusion::prelude::*;
use std::env;
use std::sync::Arc;
use std::time::Instant;

#[tokio::main]
async fn main() -> Result<()> {
    let start_time = Instant::now();

    // Get the file path from command-line arguments
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: {} <file_path>", args[0]);
        std::process::exit(1);
    }
    let file_path = &args[1];

    // 1. Configure the SessionContext for optimal parallelism
    let config = SessionConfig::new().with_target_partitions(num_cpus::get());
    let ctx = SessionContext::new_with_config(config);

    // 2. Define the schema explicitly to avoid inference
    let schema = Arc::new(Schema::new(vec![
        Field::new("station", DataType::Utf8, false),
        Field::new("temperature", DataType::Float64, false),
    ]));

    // 3. Configure CSV options with the schema and correct delimiter
    let csv_options = CsvReadOptions::new()
        .schema(&schema)
        .has_header(false)
        .delimiter(b';')
        .file_extension(".txt");

    // Create a DataFrame from the CSV file
    let df = ctx.read_csv(file_path, csv_options).await?;

    // Define the aggregation logic
    let aggregated_df = df.aggregate(
        vec![col("station")],
        vec![
            min(col("temperature")).alias("min_temp"),
            avg(col("temperature")).alias("mean_temp"),
            max(col("temperature")).alias("max_temp"),
        ],
    )?;

    // Sort the results alphabetically by station name
    let sorted_df = aggregated_df.sort(vec![col("station").sort(true, true)])?;

    // Execute the query and collect the results
    let _batches = sorted_df.collect().await?;

    // In a real submission, the results would be formatted and printed here.
    // For pure benchmarking, we stop after collection.

    let duration = start_time.elapsed();
    eprintln!("Total execution time: {:?}", duration);

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use datafusion::arrow::array::{Float64Array, StringArray};

    #[tokio::test]
    async fn test_1brc_basic_logic() -> Result<()> {
        // Sample data mimicking the 1BRC format
        let test_data = "Hamburg;12.0\nBulawayo;8.9\nPalembang;38.8\nHamburg;10.0\nBulawayo;11.1";
        
        // Create temporary file with .txt extension
        let temp_dir = tempfile::tempdir().unwrap();
        let file_path = temp_dir.path().join("measurements.txt");
        std::fs::write(&file_path, test_data).unwrap();
        let file_path = file_path.to_str().unwrap();

        let config = SessionConfig::new().with_target_partitions(num_cpus::get());
        let ctx = SessionContext::new_with_config(config);
        
        let schema = Arc::new(Schema::new(vec![
            Field::new("station", DataType::Utf8, false),
            Field::new("temperature", DataType::Float64, false),
        ]));
        
        let csv_options = CsvReadOptions::new()
            .schema(&schema)
            .has_header(false)
            .delimiter(b';')
            .file_extension(".txt");
        
        let df = ctx.read_csv(file_path, csv_options).await?;

        let aggregated_df = df.aggregate(
            vec![col("station")],
            vec![
                min(col("temperature")).alias("min_temp"),
                avg(col("temperature")).alias("mean_temp"),
                max(col("temperature")).alias("max_temp"),
            ],
        )?;
        
        let sorted_df = aggregated_df.sort(vec![col("station").sort(true, true)])?;
        let results = sorted_df.collect().await?;

        assert_eq!(results.len(), 1);
        let batch = &results[0];

        let station_col = batch
            .column(0)
            .as_any()
            .downcast_ref::<StringArray>()
            .unwrap();
        let min_col = batch
            .column(1)
            .as_any()
            .downcast_ref::<Float64Array>()
            .unwrap();
        let mean_col = batch
            .column(2)
            .as_any()
            .downcast_ref::<Float64Array>()
            .unwrap();
        let max_col = batch
            .column(3)
            .as_any()
            .downcast_ref::<Float64Array>()
            .unwrap();

        // Expected results:
        // Bulawayo: min=8.9, max=11.1, sum=20.0, count=2, mean=10.0
        // Hamburg:  min=10.0, max=12.0, sum=22.0, count=2, mean=11.0
        
        assert_eq!(station_col.value(0), "Bulawayo");
        assert_eq!(min_col.value(0), 8.9);
        assert_eq!(mean_col.value(0), 10.0);
        assert_eq!(max_col.value(0), 11.1);

        assert_eq!(station_col.value(1), "Hamburg");
        assert_eq!(min_col.value(1), 10.0);
        assert_eq!(mean_col.value(1), 11.0);
        assert_eq!(max_col.value(1), 12.0);

        Ok(())
    }

    #[tokio::test]
    async fn test_single_station() -> Result<()> {
        let test_data = "SingleStation;25.5\nSingleStation;30.2\nSingleStation;22.1";
        
        let temp_dir = tempfile::tempdir().unwrap();
        let file_path = temp_dir.path().join("single_station.txt");
        std::fs::write(&file_path, test_data).unwrap();
        let file_path = file_path.to_str().unwrap();

        let config = SessionConfig::new().with_target_partitions(1);
        let ctx = SessionContext::new_with_config(config);
        
        let schema = Arc::new(Schema::new(vec![
            Field::new("station", DataType::Utf8, false),
            Field::new("temperature", DataType::Float64, false),
        ]));
        
        let csv_options = CsvReadOptions::new()
            .schema(&schema)
            .has_header(false)
            .delimiter(b';')
            .file_extension(".txt");
        
        let df = ctx.read_csv(file_path, csv_options).await?;
        let aggregated_df = df.aggregate(
            vec![col("station")],
            vec![
                min(col("temperature")).alias("min_temp"),
                avg(col("temperature")).alias("mean_temp"),
                max(col("temperature")).alias("max_temp"),
            ],
        )?;
        
        let results = aggregated_df.collect().await?;
        assert_eq!(results.len(), 1);
        let batch = &results[0];
        assert_eq!(batch.num_rows(), 1);

        let station_col = batch.column(0).as_any().downcast_ref::<StringArray>().unwrap();
        let min_col = batch.column(1).as_any().downcast_ref::<Float64Array>().unwrap();
        let mean_col = batch.column(2).as_any().downcast_ref::<Float64Array>().unwrap();
        let max_col = batch.column(3).as_any().downcast_ref::<Float64Array>().unwrap();

        assert_eq!(station_col.value(0), "SingleStation");
        assert_eq!(min_col.value(0), 22.1);
        assert!((mean_col.value(0) - 25.933333333333334).abs() < 1e-10);
        assert_eq!(max_col.value(0), 30.2);

        Ok(())
    }

    #[tokio::test]
    async fn test_extreme_temperatures() -> Result<()> {
        let test_data = "Arctic;-50.0\nDesert;50.0\nArctic;-45.5\nDesert;48.2";
        
        let temp_dir = tempfile::tempdir().unwrap();
        let file_path = temp_dir.path().join("extreme_temps.txt");
        std::fs::write(&file_path, test_data).unwrap();
        let file_path = file_path.to_str().unwrap();

        let config = SessionConfig::new().with_target_partitions(2);
        let ctx = SessionContext::new_with_config(config);
        
        let schema = Arc::new(Schema::new(vec![
            Field::new("station", DataType::Utf8, false),
            Field::new("temperature", DataType::Float64, false),
        ]));
        
        let csv_options = CsvReadOptions::new()
            .schema(&schema)
            .has_header(false)
            .delimiter(b';')
            .file_extension(".txt");
        
        let df = ctx.read_csv(file_path, csv_options).await?;
        let aggregated_df = df.aggregate(
            vec![col("station")],
            vec![
                min(col("temperature")).alias("min_temp"),
                avg(col("temperature")).alias("mean_temp"),
                max(col("temperature")).alias("max_temp"),
            ],
        )?;
        
        let sorted_df = aggregated_df.sort(vec![col("station").sort(true, true)])?;
        let results = sorted_df.collect().await?;

        assert_eq!(results.len(), 1);
        let batch = &results[0];
        assert_eq!(batch.num_rows(), 2);

        let station_col = batch.column(0).as_any().downcast_ref::<StringArray>().unwrap();
        let min_col = batch.column(1).as_any().downcast_ref::<Float64Array>().unwrap();
        let max_col = batch.column(3).as_any().downcast_ref::<Float64Array>().unwrap();

        // Arctic should be first alphabetically
        assert_eq!(station_col.value(0), "Arctic");
        assert_eq!(min_col.value(0), -50.0);
        assert_eq!(max_col.value(0), -45.5);

        // Desert should be second
        assert_eq!(station_col.value(1), "Desert");
        assert_eq!(min_col.value(1), 48.2);
        assert_eq!(max_col.value(1), 50.0);

        Ok(())
    }

    #[tokio::test]
    async fn test_alphabetical_sorting() -> Result<()> {
        let test_data = "Zebra;10.0\nAlpha;20.0\nMidpoint;15.0\nBravo;25.0";
        
        let temp_dir = tempfile::tempdir().unwrap();
        let file_path = temp_dir.path().join("sorting_test.txt");
        std::fs::write(&file_path, test_data).unwrap();
        let file_path = file_path.to_str().unwrap();

        let config = SessionConfig::new().with_target_partitions(1);
        let ctx = SessionContext::new_with_config(config);
        
        let schema = Arc::new(Schema::new(vec![
            Field::new("station", DataType::Utf8, false),
            Field::new("temperature", DataType::Float64, false),
        ]));
        
        let csv_options = CsvReadOptions::new()
            .schema(&schema)
            .has_header(false)
            .delimiter(b';')
            .file_extension(".txt");
        
        let df = ctx.read_csv(file_path, csv_options).await?;
        let aggregated_df = df.aggregate(
            vec![col("station")],
            vec![
                min(col("temperature")).alias("min_temp"),
                avg(col("temperature")).alias("mean_temp"),
                max(col("temperature")).alias("max_temp"),
            ],
        )?;
        
        let sorted_df = aggregated_df.sort(vec![col("station").sort(true, true)])?;
        let results = sorted_df.collect().await?;

        let batch = &results[0];
        let station_col = batch.column(0).as_any().downcast_ref::<StringArray>().unwrap();

        // Verify alphabetical ordering
        assert_eq!(station_col.value(0), "Alpha");
        assert_eq!(station_col.value(1), "Bravo");
        assert_eq!(station_col.value(2), "Midpoint");
        assert_eq!(station_col.value(3), "Zebra");

        Ok(())
    }

    #[tokio::test]
    async fn test_precision_and_edge_cases() -> Result<()> {
        let test_data = "Precision;0.1\nPrecision;0.2\nPrecision;0.3\nZero;0.0\nZero;-0.0";
        
        let temp_dir = tempfile::tempdir().unwrap();
        let file_path = temp_dir.path().join("precision_test.txt");
        std::fs::write(&file_path, test_data).unwrap();
        let file_path = file_path.to_str().unwrap();

        let config = SessionConfig::new().with_target_partitions(1);
        let ctx = SessionContext::new_with_config(config);
        
        let schema = Arc::new(Schema::new(vec![
            Field::new("station", DataType::Utf8, false),
            Field::new("temperature", DataType::Float64, false),
        ]));
        
        let csv_options = CsvReadOptions::new()
            .schema(&schema)
            .has_header(false)
            .delimiter(b';')
            .file_extension(".txt");
        
        let df = ctx.read_csv(file_path, csv_options).await?;
        let aggregated_df = df.aggregate(
            vec![col("station")],
            vec![
                min(col("temperature")).alias("min_temp"),
                avg(col("temperature")).alias("mean_temp"),
                max(col("temperature")).alias("max_temp"),
            ],
        )?;
        
        let sorted_df = aggregated_df.sort(vec![col("station").sort(true, true)])?;
        let results = sorted_df.collect().await?;

        let batch = &results[0];
        let station_col = batch.column(0).as_any().downcast_ref::<StringArray>().unwrap();
        let mean_col = batch.column(2).as_any().downcast_ref::<Float64Array>().unwrap();

        // Test precision calculation
        assert_eq!(station_col.value(0), "Precision");
        assert!((mean_col.value(0) - 0.2).abs() < 1e-15);

        // Test zero handling
        assert_eq!(station_col.value(1), "Zero");
        assert_eq!(mean_col.value(1), 0.0);

        Ok(())
    }
}