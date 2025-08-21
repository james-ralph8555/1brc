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

    // Get the file paths from command-line arguments
    let args: Vec<String> = env::args().collect();
    if args.len() != 3 {
        eprintln!("Usage: {} <input_file_path> <output_csv_file>", args[0]);
        std::process::exit(1);
    }
    let input_file = &args[1];
    let output_file = &args[2];

    // 1. Configure the SessionContext for optimal parallelism
    let config = SessionConfig::new().with_target_partitions(num_cpus::get());
    let ctx = SessionContext::new_with_config(config);

    // 2. Define the schema explicitly to avoid inference - using Decimal128(3,1) for temperature
    let schema = Arc::new(Schema::new(vec![
        Field::new("station", DataType::Utf8, false),
        Field::new("temperature", DataType::Decimal128(3, 1), false),
    ]));

    // 3. Configure CSV options with the schema and correct delimiter
    let csv_options = CsvReadOptions::new()
        .schema(&schema)
        .has_header(false)
        .delimiter(b';')
        .file_extension(".txt");

    // Create a DataFrame from the CSV file
    let df = ctx.read_csv(input_file, csv_options).await?;

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
    let batches = sorted_df.collect().await?;

    // Write results to CSV file
    write_results_to_csv(&batches, output_file)?;

    let duration = start_time.elapsed();
    eprintln!("Total execution time: {:?}", duration);
    eprintln!("Results written to {}", output_file);

    Ok(())
}

fn write_results_to_csv(batches: &[datafusion::arrow::record_batch::RecordBatch], output_file: &str) -> Result<()> {
    use std::fs::File;
    use std::io::Write;

    let mut file = File::create(output_file).map_err(|e| {
        datafusion::error::DataFusionError::External(Box::new(e))
    })?;

    // Write CSV header
    writeln!(file, "station_name,min_measurement,mean_measurement,max_measurement").map_err(|e| {
        datafusion::error::DataFusionError::External(Box::new(e))
    })?;

    for batch in batches {
        let station_col = batch.column(0).as_any().downcast_ref::<datafusion::arrow::array::StringArray>()
            .ok_or_else(|| datafusion::error::DataFusionError::Internal("Expected StringArray for station column".to_string()))?;

        // Handle the aggregated columns which might be different types due to aggregation
        for i in 0..batch.num_rows() {
            let station = station_col.value(i);
            
            // Extract values handling potential type conversions from aggregation
            let min_val = extract_numeric_value(batch.column(1), i)?;
            let mean_val = extract_numeric_value(batch.column(2), i)?;
            let max_val = extract_numeric_value(batch.column(3), i)?;

            writeln!(file, "{},{:.1},{:.1},{:.1}", station, min_val, mean_val, max_val).map_err(|e| {
                datafusion::error::DataFusionError::External(Box::new(e))
            })?;
        }
    }

    Ok(())
}

fn extract_numeric_value(column: &datafusion::arrow::array::ArrayRef, index: usize) -> Result<f64> {
    use datafusion::arrow::array::*;
    
    // Try different numeric types that might result from aggregation
    if let Some(decimal_array) = column.as_any().downcast_ref::<Decimal128Array>() {
        let decimal_val = decimal_array.value(index);
        // Convert decimal128 with scale 1 to f64
        Ok(decimal_val as f64 / 10.0)
    } else if let Some(float_array) = column.as_any().downcast_ref::<Float64Array>() {
        Ok(float_array.value(index))
    } else if let Some(float_array) = column.as_any().downcast_ref::<Float32Array>() {
        Ok(float_array.value(index) as f64)
    } else {
        Err(datafusion::error::DataFusionError::Internal(
            format!("Unsupported numeric type for aggregation result: {:?}", column.data_type())
        ))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use datafusion::arrow::array::{Decimal128Array, StringArray};

    #[tokio::test]
    async fn test_1brc_basic_logic() -> Result<()> {
        let test_data = "Hamburg;12.0\nBulawayo;8.9\nPalembang;38.8\nHamburg;10.0\nBulawayo;11.1";
        
        let temp_dir = tempfile::tempdir().unwrap();
        let file_path = temp_dir.path().join("measurements.txt");
        std::fs::write(&file_path, test_data).unwrap();
        let file_path = file_path.to_str().unwrap();

        let config = SessionConfig::new().with_target_partitions(num_cpus::get());
        let ctx = SessionContext::new_with_config(config);
        
        let schema = Arc::new(Schema::new(vec![
            Field::new("station", DataType::Utf8, false),
            Field::new("temperature", DataType::Decimal128(3, 1), false),
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

        // Test that we have the expected stations in alphabetical order
        assert_eq!(station_col.value(0), "Bulawayo");
        assert_eq!(station_col.value(1), "Hamburg");
        assert_eq!(station_col.value(2), "Palembang");

        Ok(())
    }
}