# Compare Missingness Between Processed Pooled Data 2003 and 2017-2023 Jeremy Dataset
# Load required libraries
library(dplyr)
library(tidyr)
library(haven)

cat("=== MISSINGNESS COMPARISON: 2003 vs 2017-2023 DATASETS ===\n\n")

# Load both datasets
cat("Loading datasets...\n")
load("processed_pooled_data_2003.RData")
load("missingness_analysis_2017_2023_results.RData")

cat("2003 Dataset: ", nrow(final_data), " observations, ", ncol(final_data), " variables\n")
cat("2017-2023 Dataset: ", nrow(jeremy_data), " observations, ", ncol(jeremy_data), " variables\n\n")

# Calculate missingness for 2003 data
miss_2003 <- final_data %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Missing_Count") %>%
  mutate(
    Total_Obs = nrow(final_data),
    Missing_Percent = round((Missing_Count / Total_Obs) * 100, 2),
    Dataset = "2003_Processed"
  )

# Calculate missingness for 2017-2023 data  
miss_2017_2023 <- jeremy_data %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Missing_Count") %>%
  mutate(
    Total_Obs = nrow(jeremy_data),
    Missing_Percent = round((Missing_Count / Total_Obs) * 100, 2),
    Dataset = "2017-2023_Jeremy"
  )

# Find common variables
vars_2003 <- miss_2003$Variable
vars_2017_2023 <- miss_2017_2023$Variable
common_vars <- intersect(vars_2003, vars_2017_2023)
vars_only_2003 <- setdiff(vars_2003, vars_2017_2023)
vars_only_2017_2023 <- setdiff(vars_2017_2023, vars_2003)

cat("=== VARIABLE COMPARISON ===\n")
cat("Variables in both datasets (", length(common_vars), "):\n")
cat(paste(common_vars, collapse = ", "), "\n\n")
cat("Variables only in 2003 dataset (", length(vars_only_2003), "):\n")
cat(paste(vars_only_2003, collapse = ", "), "\n\n")
cat("Variables only in 2017-2023 dataset (", length(vars_only_2017_2023), "):\n")
cat(paste(vars_only_2017_2023, collapse = ", "), "\n\n")

# Create comparison for common variables
if (length(common_vars) > 0) {
  # Get missingness for common variables only
  miss_2003_common <- miss_2003 %>% filter(Variable %in% common_vars)
  miss_2017_2023_common <- miss_2017_2023 %>% filter(Variable %in% common_vars)
  
  # Create comparison table
  comparison <- data.frame(
    Variable = miss_2003_common$Variable,
    Miss_2003 = miss_2003_common$Missing_Percent,
    Miss_2017_2023 = miss_2017_2023_common$Missing_Percent[match(miss_2003_common$Variable, miss_2017_2023_common$Variable)],
    stringsAsFactors = FALSE
  ) %>%
    mutate(
      Difference = Miss_2017_2023 - Miss_2003,
      Better_Quality = case_when(
        Difference < -1 ~ "2017-2023",
        Difference > 1 ~ "2003", 
        TRUE ~ "Similar"
      )
    ) %>%
    arrange(desc(abs(Difference)))
  
  cat("=== MISSINGNESS COMPARISON FOR COMMON VARIABLES ===\n")
  cat("Variables sorted by largest difference in missingness percentage:\n\n")
  
  cat(sprintf("%-12s %8s %8s %10s %15s\n", 
              "Variable", "2003_%", "2017_%", "Diff_%", "Better_Quality"))
  cat(paste0(rep("-", 65), collapse = ""), "\n")
  
  for(i in 1:nrow(comparison)) {
    cat(sprintf("%-12s %7.2f%% %7.2f%% %+9.2f%% %15s\n",
                comparison$Variable[i],
                comparison$Miss_2003[i],
                comparison$Miss_2017_2023[i],
                comparison$Difference[i],
                comparison$Better_Quality[i]))
  }
  
  cat("\n=== SUMMARY STATISTICS ===\n")
  better_2003 <- sum(comparison$Difference > 1, na.rm = TRUE)
  better_2017_2023 <- sum(comparison$Difference < -1, na.rm = TRUE) 
  similar <- sum(abs(comparison$Difference) <= 1, na.rm = TRUE)
  
  cat("Variables with better data quality in 2003:", better_2003, "\n")
  cat("Variables with better data quality in 2017-2023:", better_2017_2023, "\n")
  cat("Variables with similar data quality:", similar, "\n\n")
  
  # Key substance use variables
  substance_vars <- c("cig", "ccannabis", "cdrink")
  substance_comp <- comparison %>% filter(Variable %in% substance_vars)
  
  if(nrow(substance_comp) > 0) {
    cat("=== KEY SUBSTANCE USE VARIABLES ===\n")
    for(i in 1:nrow(substance_comp)) {
      cat(sprintf("%s: 2003=%.2f%%, 2017-2023=%.2f%% (diff: %+.2f%%)\n",
                  substance_comp$Variable[i],
                  substance_comp$Miss_2003[i],
                  substance_comp$Miss_2017_2023[i],
                  substance_comp$Difference[i]))
    }
    cat("\n")
  }
  
  # Check vaping variable
  if("cvape" %in% vars_only_2017_2023) {
    cvape_miss <- miss_2017_2023 %>% filter(Variable == "cvape")
    cat("=== VAPING VARIABLE (cvape) ===\n")
    cat("Only available in 2017-2023 dataset\n")
    cat(sprintf("cvape missingness: %.2f%% (%d out of %d observations)\n\n",
                cvape_miss$Missing_Percent, cvape_miss$Missing_Count, cvape_miss$Total_Obs))
  }
}

# Overall comparison
cat("=== OVERALL DATA QUALITY ===\n")
avg_2003 <- mean(miss_2003$Missing_Percent)
avg_2017_2023 <- mean(miss_2017_2023$Missing_Percent)

cat(sprintf("Average missingness - 2003: %.2f%%\n", avg_2003))
cat(sprintf("Average missingness - 2017-2023: %.2f%%\n", avg_2017_2023))
cat(sprintf("Difference: %+.2f%% (positive = 2017-2023 higher)\n\n", avg_2017_2023 - avg_2003))

# Complete data comparison
complete_2003 <- sum(miss_2003$Missing_Count == 0)
complete_2017_2023 <- sum(miss_2017_2023$Missing_Count == 0)

cat("Variables with no missing data:\n")
cat(sprintf("2003: %d/%d variables (%.1f%%)\n", 
            complete_2003, length(vars_2003), 100*complete_2003/length(vars_2003)))
cat(sprintf("2017-2023: %d/%d variables (%.1f%%)\n", 
            complete_2017_2023, length(vars_2017_2023), 100*complete_2017_2023/length(vars_2017_2023)))

cat("\n=== ANALYSIS COMPLETE ===\n") 