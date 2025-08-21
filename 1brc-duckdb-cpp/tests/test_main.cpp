#include <cassert>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>

// Simple test framework
class TestFramework {
private:
    int passed = 0;
    int failed = 0;
    
public:
    void assert_equal(const std::string& expected, const std::string& actual, const std::string& test_name) {
        if (expected == actual) {
            std::cout << "✓ " << test_name << " PASSED" << std::endl;
            passed++;
        } else {
            std::cout << "✗ " << test_name << " FAILED" << std::endl;
            std::cout << "  Expected: " << expected << std::endl;
            std::cout << "  Actual:   " << actual << std::endl;
            failed++;
        }
    }
    
    void assert_contains(const std::string& content, const std::string& substring, const std::string& test_name) {
        if (content.find(substring) != std::string::npos) {
            std::cout << "✓ " << test_name << " PASSED" << std::endl;
            passed++;
        } else {
            std::cout << "✗ " << test_name << " FAILED" << std::endl;
            std::cout << "  Content should contain: " << substring << std::endl;
            failed++;
        }
    }
    
    int summary() {
        std::cout << "\n=== Test Summary ===" << std::endl;
        std::cout << "Passed: " << passed << std::endl;
        std::cout << "Failed: " << failed << std::endl;
        return failed;
    }
};

std::string read_file(const std::string& filename) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        return "";
    }
    std::stringstream buffer;
    buffer << file.rdbuf();
    return buffer.str();
}

std::vector<std::string> split_lines(const std::string& content) {
    std::vector<std::string> lines;
    std::stringstream ss(content);
    std::string line;
    while (std::getline(ss, line)) {
        if (!line.empty()) {
            lines.push_back(line);
        }
    }
    return lines;
}

int main() {
    TestFramework test;
    
    std::cout << "=== 1BRC DuckDB C++ Unit Tests ===" << std::endl;
    
    // Test 1: Basic CSV format validation
    {
        std::string test_content = read_file("test_output.csv");
        auto lines = split_lines(test_content);
        
        // Should have header + data lines
        test.assert_equal("true", lines.size() >= 2 ? "true" : "false", "CSV has header and data");
        
        if (!lines.empty()) {
            test.assert_equal("station_name,min_measurement,mean_measurement,max_measurement", 
                            lines[0], "CSV header format");
        }
    }
    
    // Test 2: Data line format validation
    {
        std::string test_content = read_file("test_output.csv");
        auto lines = split_lines(test_content);
        
        if (lines.size() > 1) {
            std::string first_data_line = lines[1];
            // Count commas (should be 3 for 4 columns)
            int comma_count = std::count(first_data_line.begin(), first_data_line.end(), ',');
            test.assert_equal("3", std::to_string(comma_count), "CSV data line has correct number of columns");
            
            // Check if contains expected station
            test.assert_contains(test_content, "Bulawayo", "Contains expected station Bulawayo");
            test.assert_contains(test_content, "Hamburg", "Contains expected station Hamburg");
        }
    }
    
    // Test 3: Numeric format validation
    {
        std::string test_content = read_file("test_output.csv");
        auto lines = split_lines(test_content);
        
        if (lines.size() > 1) {
            // Check if numeric values are properly formatted (one decimal place)
            test.assert_contains(test_content, "8.9", "Contains properly formatted temperatures");
            test.assert_contains(test_content, "12.0", "Contains zero decimal temperatures");
        }
    }
    
    // Test 4: Sorting validation
    {
        std::string test_content = read_file("test_output.csv");
        auto lines = split_lines(test_content);
        
        if (lines.size() > 2) {
            std::vector<std::string> stations;
            for (size_t i = 1; i < lines.size(); ++i) {
                size_t comma_pos = lines[i].find(',');
                if (comma_pos != std::string::npos) {
                    stations.push_back(lines[i].substr(0, comma_pos));
                }
            }
            
            std::vector<std::string> sorted_stations = stations;
            std::sort(sorted_stations.begin(), sorted_stations.end());
            
            bool is_sorted = (stations == sorted_stations);
            test.assert_equal("true", is_sorted ? "true" : "false", "Stations are sorted alphabetically");
        }
    }
    
    return test.summary();
}