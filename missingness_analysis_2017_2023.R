# Missingness Analysis for 2017-2023 Jeremy Dataset
# Load required libraries
library(dplyr)
library(tidyr)
library(haven)

# Load the 2017-2023 data
# The path from Windows WSL format to actual WSL path
data_path <- "/home/siyang/vaping2_working_data/2017_2023_jeremy.dta"

cat("=== 2017-2023 JEREMY DATASET MISSINGNESS ANALYSIS ===\n\n")
cat("Loading data from:", data_path, "\n")

# Check if file exists
if (!file.exists(data_path)) {
  cat("ERROR: File not found at", data_path, "\n")
  cat("Checking alternative paths...\n")
  
  # Try alternative paths
  alt_paths <- c(
    "/mnt/c/Users/*/AppData/Local/Packages/CanonicalGroupLimited.Ubuntu*/LocalState/rootfs/home/siyang/vaping2_working_data/2017_2023_jeremy.dta",
    "../vaping2_working_data/2017_2023_jeremy.dta",
    "~/vaping2_working_data/2017_2023_jeremy.dta"
  )
  
  for (alt_path in alt_paths) {
    if (file.exists(alt_path)) {
      data_path <- alt_path
      cat("Found file at:", data_path, "\n")
      break
    }
  }
  
  # List contents of potential directory
  working_data_dir <- "/home/siyang/vaping2_working_data"
  if (dir.exists(working_data_dir)) {
    cat("Contents of", working_data_dir, ":\n")
    files <- list.files(working_data_dir, full.names = FALSE)
    for (file in files) {
      cat("  ", file, "\n")
    }
  } else {
    cat("Directory", working_data_dir, "does not exist\n")
    cat("Current working directory:", getwd(), "\n")
    cat("Contents of current directory:\n")
    files <- list.files(".", full.names = FALSE)
    for (file in files) {
      cat("  ", file, "\n")
    }
  }
}

# Try to load the data
if (file.exists(data_path)) {
  jeremy_data <- read_dta(data_path)
  
  # Display basic information
  cat("Dataset loaded successfully!\n")
  cat("Dataset dimensions:", dim(jeremy_data), "\n")
  cat("Total observations:", nrow(jeremy_data), "\n")
  cat("Total variables:", ncol(jeremy_data), "\n\n")
  
  # Function to calculate missingness statistics
  calculate_missingness <- function(data) {
    miss_stats <- data %>%
      summarise(across(everything(), ~sum(is.na(.)))) %>%
      pivot_longer(everything(), names_to = "Variable", values_to = "Missing_Count") %>%
      mutate(
        Total_Obs = nrow(data),
        Missing_Percent = round((Missing_Count / Total_Obs) * 100, 2),
        Non_Missing = Total_Obs - Missing_Count,
        Non_Missing_Percent = round(((Total_Obs - Missing_Count) / Total_Obs) * 100, 2)
      ) %>%
      arrange(desc(Missing_Percent))
    
    return(miss_stats)
  }
  
  # Calculate missingness statistics
  miss_summary <- calculate_missingness(jeremy_data)
  
  # Display comprehensive missingness table
  cat("=== COMPREHENSIVE MISSINGNESS SUMMARY ===\n")
  cat("Variables sorted by percentage of missing values (highest to lowest):\n\n")
  
  # Print formatted table
  cat(sprintf("%-15s %10s %8s %12s %8s\n", 
              "Variable", "Missing", "Miss_%", "Non-Missing", "NonMiss_%"))
  cat(paste0(rep("-", 65), collapse = ""), "\n")
  
  for(i in 1:nrow(miss_summary)) {
    cat(sprintf("%-15s %10d %7.2f%% %12d %7.2f%%\n",
                miss_summary$Variable[i],
                miss_summary$Missing_Count[i],
                miss_summary$Missing_Percent[i],
                miss_summary$Non_Missing[i],
                miss_summary$Non_Missing_Percent[i]))
  }
  
  # Summary statistics
  cat("\n=== MISSINGNESS OVERVIEW ===\n")
  cat("Variables with NO missing data:", sum(miss_summary$Missing_Count == 0), "\n")
  cat("Variables with ANY missing data:", sum(miss_summary$Missing_Count > 0), "\n")
  cat("Variables with >50% missing:", sum(miss_summary$Missing_Percent > 50), "\n")
  cat("Variables with >25% missing:", sum(miss_summary$Missing_Percent > 25), "\n")
  cat("Variables with >10% missing:", sum(miss_summary$Missing_Percent > 10), "\n")
  cat("Variables with >5% missing:", sum(miss_summary$Missing_Percent > 5), "\n")
  
  # Variables with highest missingness
  cat("\n=== TOP 15 VARIABLES WITH HIGHEST MISSINGNESS ===\n")
  top_missing <- head(miss_summary[miss_summary$Missing_Count > 0, ], 15)
  if(nrow(top_missing) > 0) {
    for(i in 1:nrow(top_missing)) {
      cat(sprintf("%s: %d missing (%.2f%%)\n",
                  top_missing$Variable[i],
                  top_missing$Missing_Count[i],
                  top_missing$Missing_Percent[i]))
    }
  } else {
    cat("No variables with missing data!\n")
  }
  
  # Variables with no missing data
  no_missing <- miss_summary[miss_summary$Missing_Count == 0, ]
  cat("\n=== VARIABLES WITH NO MISSING DATA ===\n")
  if(nrow(no_missing) > 0) {
    if(nrow(no_missing) <= 20) {
      cat(paste(no_missing$Variable, collapse = ", "), "\n")
    } else {
      cat("First 20 variables:", paste(head(no_missing$Variable, 20), collapse = ", "), "\n")
      cat("... and", nrow(no_missing) - 20, "more variables\n")
    }
  } else {
    cat("No variables with complete data\n")
  }
  
  # Look for key variables that might be relevant (vaping, smoking, etc.)
  key_patterns <- c("vap", "cig", "smoke", "cannabis", "alcohol", "drink", "drug", "age", "sex", "gender", "race", "year")
  key_vars <- character(0)
  
  for(pattern in key_patterns) {
    matches <- grep(pattern, names(jeremy_data), ignore.case = TRUE, value = TRUE)
    key_vars <- c(key_vars, matches)
  }
  
  key_vars <- unique(key_vars)
  
  if(length(key_vars) > 0) {
    cat("\n=== KEY VARIABLES ANALYSIS ===\n")
    cat("Variables potentially related to substance use:\n")
    key_analysis <- miss_summary[miss_summary$Variable %in% key_vars, ]
    
    if(nrow(key_analysis) > 0) {
      for(i in 1:nrow(key_analysis)) {
        cat(sprintf("  %s: %d missing (%.2f%%)\n",
                    key_analysis$Variable[i],
                    key_analysis$Missing_Count[i],
                    key_analysis$Missing_Percent[i]))
      }
    }
  }
  
  # Check data types and structure summary
  cat("\n=== DATA STRUCTURE SUMMARY ===\n")
  cat("Variable types (first 20 variables):\n")
  str(jeremy_data[1:min(20, ncol(jeremy_data))])
  
  # Save missingness summary
  save(miss_summary, jeremy_data, 
       file = "missingness_analysis_2017_2023_results.RData")
  
  cat("\n=== ANALYSIS COMPLETE ===\n")
  cat("Results saved to 'missingness_analysis_2017_2023_results.RData'\n")
  cat("Total variables analyzed:", ncol(jeremy_data), "\n")
  
} else {
  cat("ERROR: Could not find the data file. Please check the path.\n")
} 