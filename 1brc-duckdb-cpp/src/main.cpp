#include <iostream>
#include <iomanip>
#include <memory>
#include <string>
#include <thread>
#include "duckdb.hpp"

void process_and_print_results(std::unique_ptr<duckdb::MaterializedQueryResult>& result) {
    if (result->HasError()) {
        std::cerr << "Query Error: " << result->GetError() << std::endl;
        return;
    }

    // Efficiently iterate over the result set
    for (const auto& row : result->Collection().Rows()) {
        auto station_name = row.GetValue(0).GetValue<std::string>();
        auto min_val = row.GetValue(1).GetValue<double>();
        auto mean_val = row.GetValue(2).GetValue<double>();
        auto max_val = row.GetValue(3).GetValue<double>();

        // Print the formatted output directly to std::cout
        std::cout << station_name << "="
                  << std::fixed << std::setprecision(1)
                  << min_val << "/" << mean_val << "/" << max_val << "\n";
    }
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <path_to_measurements_file>" << std::endl;
        return 1;
    }
    std::string file_path = argv[1];

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

    // Build the SQL query with the file path
    const std::string sql = R"(
        WITH result AS (
            SELECT
                station_name,
                MIN(measurement) AS min_measurement,
                ROUND(AVG(measurement), 1) AS mean_measurement,
                MAX(measurement) AS max_measurement
            FROM READ_CSV(')" + file_path + R"(', header=false, columns={'station_name':'VARCHAR','measurement':'DECIMAL(3,1)'}, delim=';')
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
    
    process_and_print_results(result);

    return 0;
}