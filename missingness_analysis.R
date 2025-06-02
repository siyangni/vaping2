# Missingness Analysis for Pooled Data 1997-2003
# Load required libraries
library(dplyr)
library(tidyr)
library(haven)

# Load the pooled data
load("pooled_data_1997_2003.RData")

# Display basic information
cat("=== POOLED DATA 1997-2003 MISSINGNESS ANALYSIS ===\n\n")
cat("Dataset dimensions:", dim(pooled_data), "\n")
cat("Total observations:", nrow(pooled_data), "\n\n")

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
miss_summary <- calculate_missingness(pooled_data)

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

# Variables with highest missingness
cat("\n=== TOP 10 VARIABLES WITH HIGHEST MISSINGNESS ===\n")
top_missing <- head(miss_summary, 10)
for(i in 1:nrow(top_missing)) {
  cat(sprintf("%s: %d missing (%.2f%%)\n",
              top_missing$Variable[i],
              top_missing$Missing_Count[i],
              top_missing$Missing_Percent[i]))
}

# Variables with no missing data
no_missing <- miss_summary[miss_summary$Missing_Count == 0, ]
cat("\n=== VARIABLES WITH NO MISSING DATA ===\n")
if(nrow(no_missing) > 0) {
  cat(paste(no_missing$Variable, collapse = ", "), "\n")
} else {
  cat("No variables with complete data\n")
}

# Check for specific patterns (-9, which might indicate missing data not yet recoded)
cat("\n=== CHECKING FOR POTENTIAL MISSING DATA CODES ===\n")
# Convert haven_labelled to numeric for checking
pooled_numeric <- pooled_data %>%
  mutate(across(where(is.labelled), as.numeric))

# Check for -9 values (common missing data code)
check_minus9 <- pooled_numeric %>%
  summarise(across(everything(), ~sum(. == -9, na.rm = TRUE))) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Minus9_Count") %>%
  filter(Minus9_Count > 0) %>%
  arrange(desc(Minus9_Count))

if(nrow(check_minus9) > 0) {
  cat("Variables with -9 values (potential missing data codes):\n")
  for(i in 1:nrow(check_minus9)) {
    cat(sprintf("%s: %d occurrences of -9\n",
                check_minus9$Variable[i],
                check_minus9$Minus9_Count[i]))
  }
} else {
  cat("No -9 values found (missing data codes likely already recoded)\n")
}

cat("\n=== ANALYSIS COMPLETE ===\n") 