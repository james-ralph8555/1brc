#include <iostream>
#include <iomanip>
#include <memory>
#include <string>
#include <thread>
#include <fstream>
#include "duckdb.hpp"

void process_and_write_csv_results(std::unique_ptr<duckdb::MaterializedQueryResult>& result, const std::string& output_file) {
    if (result->HasError()) {
        std::cerr << "Query Error: " << result->GetError() << std::endl;
        return;
    }

    std::ofstream csv_file(output_file);
    if (!csv_file.is_open()) {
        std::cerr << "Error: Could not open output file " << output_file << std::endl;
        return;
    }

    // Write CSV header
    csv_file << "station_name,min_measurement,mean_measurement,max_measurement\n";

    // Efficiently iterate over the result set
    for (const auto& row : result->Collection().Rows()) {
        auto station_name = row.GetValue(0).GetValue<std::string>();
        auto min_val = row.GetValue(1).GetValue<double>();
        auto mean_val = row.GetValue(2).GetValue<double>();
        auto max_val = row.GetValue(3).GetValue<double>();

        // Write to CSV with proper formatting
        csv_file << station_name << ","
                 << std::fixed << std::setprecision(1)
                 << min_val << "," << mean_val << "," << max_val << "\n";
    }

    csv_file.close();
    std::cout << "Results written to " << output_file << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <path_to_measurements_file> <output_csv_file>" << std::endl;
        return 1;
    }
    std::string file_path = argv[1];
    std::string output_file = argv[2];

    // Decouple C++ streams from C standard I/O for performance
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(NULL);

    duckdb::DBConfig config;
    try {
        // Configure DuckDB for maximum performance
        unsigned int num_threads = std::thread::hardware_concurrency();
        config.SetOptionByName("threads", duckdb::Value(std::to_string(num_threads)));
        config.SetOptionByName("memory_limit", duckdb::Value("16GB"));
        // Allow the engine to reorder data for faster aggregation
        config.SetOptionByName("preserve_insertion_order", duckdb::Value(false));
    } catch (std::exception &e) {
        std::cerr << "Error setting DuckDB config: " << e.what() << std::endl;
        return 1;
    }

    // Instantiate the database with the custom configuration
    duckdb::DuckDB db(nullptr, &config);
    duckdb::Connection con(db);

    // Build the SQL query with the file path - using DOUBLE for temperature
    const std::string sql = R"(
        WITH result AS (
            SELECT
                station_name,
                MIN(measurement) AS min_measurement,
                ROUND(AVG(measurement), 1) AS mean_measurement,
                MAX(measurement) AS max_measurement
            FROM READ_CSV(')" + file_path + R"(', header=false, columns={'station_name':'VARCHAR','measurement':'DOUBLE'}, delim=';')
            GROUP BY station_name
        )
        SELECT
            station_name,
            min_measurement,
            mean_measurement,
            max_measurement
        FROM result
        ORDER BY station_name;
    )";

    // Execute the query
    auto result = con.Query(sql);
    
    process_and_write_csv_results(result, output_file);

    return 0;
}