# Missingness Analysis for Processed Pooled Data 2003
# Load required libraries
library(dplyr)
library(tidyr)

# Load the processed data
load("processed_pooled_data_2003.RData")

# Display basic information
cat("=== PROCESSED POOLED DATA 2003 MISSINGNESS ANALYSIS ===\n\n")
cat("Dataset dimensions:", dim(final_data), "\n")
cat("Total observations:", nrow(final_data), "\n")
cat("Total variables:", ncol(final_data), "\n\n")

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
miss_summary <- calculate_missingness(final_data)

# Display comprehensive missingness table
cat("=== COMPREHENSIVE MISSINGNESS SUMMARY ===\n")
cat("Variables sorted by percentage of missing values (highest to lowest):\n\n")

# Print formatted table
cat(sprintf("%-12s %10s %8s %12s %8s\n", 
            "Variable", "Missing", "Miss_%", "Non-Missing", "NonMiss_%"))
cat(paste0(rep("-", 60), collapse = ""), "\n")

for(i in 1:nrow(miss_summary)) {
  cat(sprintf("%-12s %10d %7.2f%% %12d %7.2f%%\n",
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
cat("\n=== VARIABLES WITH HIGHEST MISSINGNESS ===\n")
top_missing <- miss_summary[miss_summary$Missing_Count > 0, ]
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
  cat(paste(no_missing$Variable, collapse = ", "), "\n")
} else {
  cat("No variables with complete data\n")
}

# Variable-specific analysis for key variables
cat("\n=== KEY VARIABLE ANALYSIS ===\n")
key_vars <- c("cig", "ccannabis", "cdrink", "age18", "female", "wrace", "pared", "work")
key_analysis <- miss_summary[miss_summary$Variable %in% key_vars, ]

cat("Missing data for key analysis variables:\n")
for(i in 1:nrow(key_analysis)) {
  cat(sprintf("  %s: %d missing (%.2f%%)\n",
              key_analysis$Variable[i],
              key_analysis$Missing_Count[i],
              key_analysis$Missing_Percent[i]))
}

# Check data types and summary
cat("\n=== DATA STRUCTURE SUMMARY ===\n")
cat("Variable types:\n")
str(final_data)

cat("\n=== ANALYSIS COMPLETE ===\n") 