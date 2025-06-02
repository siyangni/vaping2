# Compare Missingness Between Processed Pooled Data 2003 and 2017-2023 Jeremy Dataset
# Load required libraries
library(dplyr)
library(tidyr)
library(haven)

cat("=== MISSINGNESS COMPARISON: 2003 vs 2017-2023 DATASETS ===\n\n")

# Function to calculate missingness statistics
calculate_missingness <- function(data, dataset_name) {
  miss_stats <- data %>%
    summarise(across(everything(), ~sum(is.na(.)))) %>%
    pivot_longer(everything(), names_to = "Variable", values_to = "Missing_Count") %>%
    mutate(
      Total_Obs = nrow(data),
      Missing_Percent = round((Missing_Count / Total_Obs) * 100, 2),
      Non_Missing = Total_Obs - Missing_Count,
      Non_Missing_Percent = round(((Total_Obs - Missing_Count) / Total_Obs) * 100, 2),
      Dataset = dataset_name
    ) %>%
    arrange(desc(Missing_Percent))
  
  return(miss_stats)
}

# Load 2003 Processed Data
cat("Loading 2003 Processed Pooled Data...\n")
load("processed_pooled_data_2003.RData")
miss_2003 <- calculate_missingness(final_data, "2003_Processed")

cat("2003 Dataset: ", nrow(final_data), " observations, ", ncol(final_data), " variables\n")

# Load 2017-2023 Jeremy Data
cat("Loading 2017-2023 Jeremy Dataset...\n")
load("missingness_analysis_2017_2023_results.RData")
miss_2017_2023 <- calculate_missingness(jeremy_data, "2017-2023_Jeremy")

cat("2017-2023 Dataset: ", nrow(jeremy_data), " observations, ", ncol(jeremy_data), " variables\n\n")

# Combine missingness data
all_miss <- bind_rows(miss_2003, miss_2017_2023)

# Find common variables between datasets
vars_2003 <- unique(miss_2003$Variable)
vars_2017_2023 <- unique(miss_2017_2023$Variable)
common_vars <- intersect(vars_2003, vars_2017_2023)
vars_only_2003 <- setdiff(vars_2003, vars_2017_2023)
vars_only_2017_2023 <- setdiff(vars_2017_2023, vars_2003)

cat("=== VARIABLE COMPARISON ===\n")
cat("Variables in both datasets (", length(common_vars), "):", paste(common_vars, collapse = ", "), "\n")
cat("Variables only in 2003 dataset (", length(vars_only_2003), "):", paste(vars_only_2003, collapse = ", "), "\n")
cat("Variables only in 2017-2023 dataset (", length(vars_only_2017_2023), "):", paste(vars_only_2017_2023, collapse = ", "), "\n\n")

# Create comparison table for common variables
if (length(common_vars) > 0) {
  comparison_table <- all_miss %>%
    filter(Variable %in% common_vars) %>%
    select(Variable, Dataset, Missing_Percent, Missing_Count, Total_Obs) %>%
    pivot_wider(names_from = Dataset, 
                values_from = c(Missing_Percent, Missing_Count, Total_Obs),
                names_sep = "_") %>%
    mutate(
      Difference_Percent = `Missing_Percent_2017-2023_Jeremy` - Missing_Percent_2003_Processed,
      Better_In = case_when(
        Difference_Percent < -1 ~ "2017-2023 (Lower Miss%)",
        Difference_Percent > 1 ~ "2003 (Lower Miss%)",
        TRUE ~ "Similar"
      )
    ) %>%
    arrange(desc(abs(Difference_Percent)))
  
  cat("=== MISSINGNESS COMPARISON FOR COMMON VARIABLES ===\n")
  cat("Variables sorted by largest difference in missingness percentage:\n\n")
  
  cat(sprintf("%-12s %8s %8s %10s %20s\n", 
              "Variable", "2003_%", "2017_%", "Diff_%", "Better_Data_Quality"))
  cat(paste0(rep("-", 70), collapse = ""), "\n")
  
  for(i in 1:nrow(comparison_table)) {
    cat(sprintf("%-12s %7.2f%% %7.2f%% %+9.2f%% %20s\n",
                comparison_table$Variable[i],
                comparison_table$Missing_Percent_2003_Processed[i],
                comparison_table$`Missing_Percent_2017-2023_Jeremy`[i],
                comparison_table$Difference_Percent[i],
                comparison_table$Better_In[i]))
  }
  
  cat("\nNote: Positive difference means 2017-2023 has higher missingness\n")
  cat("      Negative difference means 2003 has higher missingness\n\n")
  
  # Summary statistics
  cat("=== SUMMARY OF COMPARISON ===\n")
  better_2003 <- sum(comparison_table$Difference_Percent > 1, na.rm = TRUE)
  better_2017_2023 <- sum(comparison_table$Difference_Percent < -1, na.rm = TRUE)
  similar <- sum(abs(comparison_table$Difference_Percent) <= 1, na.rm = TRUE)
  
  cat("Variables with better data quality in 2003 dataset:", better_2003, "\n")
  cat("Variables with better data quality in 2017-2023 dataset:", better_2017_2023, "\n")
  cat("Variables with similar data quality:", similar, "\n\n")
  
  # Substance use variables comparison
  substance_vars <- c("cig", "cvape", "ccannabis", "cdrink")
  substance_comparison <- comparison_table %>%
    filter(Variable %in% substance_vars)
  
  if(nrow(substance_comparison) > 0) {
    cat("=== SUBSTANCE USE VARIABLES COMPARISON ===\n")
    for(i in 1:nrow(substance_comparison)) {
      var_name <- substance_comparison$Variable[i]
      miss_2003 <- substance_comparison$Missing_Percent_2003_Processed[i]
      miss_2017 <- substance_comparison$`Missing_Percent_2017-2023_Jeremy`[i]
      diff <- substance_comparison$Difference_Percent[i]
      
      cat(sprintf("%s: 2003 = %.2f%%, 2017-2023 = %.2f%% (diff: %+.2f%%)\n",
                  var_name, miss_2003, miss_2017, diff))
    }
  }
  
  # Special note about vaping
  if("cvape" %in% vars_only_2017_2023) {
    cvape_miss <- miss_2017_2023 %>% filter(Variable == "cvape")
    cat("\n=== VAPING VARIABLE (cvape) ===\n")
    cat("Only available in 2017-2023 dataset\n")
    cat(sprintf("cvape missingness: %.2f%% (%d out of %d observations)\n",
                cvape_miss$Missing_Percent, cvape_miss$Missing_Count, cvape_miss$Total_Obs))
  }
}

# Overall data quality comparison
cat("\n=== OVERALL DATA QUALITY COMPARISON ===\n")

# Calculate average missingness per dataset
avg_miss_2003 <- mean(miss_2003$Missing_Percent, na.rm = TRUE)
avg_miss_2017_2023 <- mean(miss_2017_2023$Missing_Percent, na.rm = TRUE)

cat("Average missingness across all variables:\n")
cat(sprintf("2003 Dataset: %.2f%%\n", avg_miss_2003))
cat(sprintf("2017-2023 Dataset: %.2f%%\n", avg_miss_2017_2023))
cat(sprintf("Difference: %+.2f%%\n", avg_miss_2017_2023 - avg_miss_2003))

# Variables with no missing data
complete_2003 <- sum(miss_2003$Missing_Count == 0)
complete_2017_2023 <- sum(miss_2017_2023$Missing_Count == 0)

cat("\nVariables with no missing data:\n")
cat(sprintf("2003 Dataset: %d out of %d variables (%.1f%%)\n", 
            complete_2003, length(vars_2003), 100*complete_2003/length(vars_2003)))
cat(sprintf("2017-2023 Dataset: %d out of %d variables (%.1f%%)\n", 
            complete_2017_2023, length(vars_2017_2023), 100*complete_2017_2023/length(vars_2017_2023)))

# Variables with high missingness (>20%)
high_miss_2003 <- sum(miss_2003$Missing_Percent > 20)
high_miss_2017_2023 <- sum(miss_2017_2023$Missing_Percent > 20)

cat("\nVariables with high missingness (>20%):\n")
cat(sprintf("2003 Dataset: %d variables\n", high_miss_2003))
cat(sprintf("2017-2023 Dataset: %d variables\n", high_miss_2017_2023))

# Save comparison results
save(comparison_table, miss_2003, miss_2017_2023, all_miss, common_vars,
     file = "missingness_comparison_results.RData")

cat("\n=== ANALYSIS COMPLETE ===\n")
cat("Results saved to 'missingness_comparison_results.RData'\n") 