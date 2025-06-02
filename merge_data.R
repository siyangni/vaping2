# ===============================================================================
# MERGE THE 7 WAVES INTO POOLED CROSS-SECTIONAL DATASET
# ===============================================================================

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("MERGING 7 WAVES INTO POOLED CROSS-SECTIONAL DATASET\n")
cat(paste(rep("=", 80), collapse=""), "\n\n")

# Add year identifier to each dataset
data_1997$SURVEY_YEAR <- 1997
data_1998$SURVEY_YEAR <- 1998
data_1999$SURVEY_YEAR <- 1999
data_2000$SURVEY_YEAR <- 2000
data_2001$SURVEY_YEAR <- 2001
data_2002$SURVEY_YEAR <- 2002
data_2003$SURVEY_YEAR <- 2003

# Create unique CASEID across all waves to avoid conflicts
# Since these are cross-sectional (different people each year), we need unique IDs
data_1997$UNIQUE_ID <- paste0("1997_", data_1997$CASEID)
data_1998$UNIQUE_ID <- paste0("1998_", data_1998$CASEID)
data_1999$UNIQUE_ID <- paste0("1999_", data_1999$CASEID)
data_2000$UNIQUE_ID <- paste0("2000_", data_2000$CASEID)
data_2001$UNIQUE_ID <- paste0("2001_", data_2001$CASEID)
data_2002$UNIQUE_ID <- paste0("2002_", data_2002$CASEID)
data_2003$UNIQUE_ID <- paste0("2003_", data_2003$CASEID)

# Verify all datasets have the same variables before merging
cat("Checking variable consistency across datasets...\n")
var_counts <- sapply(data_list, ncol)
cat("Variable counts by year:\n")
print(var_counts)

if (length(unique(var_counts)) == 1) {
  cat("✓ All datasets have the same number of variables\n")
} else {
  cat("⚠ Warning: Datasets have different numbers of variables\n")
}

# Check variable names consistency
all_vars <- lapply(data_list, names)
common_vars <- Reduce(intersect, all_vars)
cat("Common variables across all datasets:", length(common_vars), "out of", max(var_counts), "\n")

# Combine all datasets into pooled cross-sectional data
cat("\nCombining datasets...\n")

# Method 1: Using rbind (if all variables are identical)
if (length(unique(var_counts)) == 1 && all(sapply(all_vars, function(x) identical(sort(x), sort(all_vars[[1]]))))) {
  
  pooled_data <- rbind(data_1997, data_1998, data_1999, data_2000, 
                       data_2001, data_2002, data_2003)
  cat("✓ Successfully merged using rbind() - all variables identical\n")
  
} else {
  
  # Method 2: Using bind_rows (handles different variable sets)
  pooled_data <- bind_rows(data_1997, data_1998, data_1999, data_2000, 
                           data_2001, data_2002, data_2003)
  cat("✓ Successfully merged using bind_rows() - handled variable differences\n")
  
}

# Display information about the merged dataset
cat("\n", paste(rep("-", 60), collapse=""), "\n")
cat("POOLED DATASET SUMMARY\n")
cat(paste(rep("-", 60), collapse=""), "\n")

cat("Total observations:", nrow(pooled_data), "\n")
cat("Total variables:", ncol(pooled_data), "\n")
cat("Years covered:", min(pooled_data$SURVEY_YEAR), "-", max(pooled_data$SURVEY_YEAR), "\n")

# Show distribution by year
year_counts <- table(pooled_data$SURVEY_YEAR)
cat("\nObservations by year:\n")
print(year_counts)

cat("\nPercentage by year:\n")
year_percentages <- round(prop.table(year_counts) * 100, 2)
print(year_percentages)

# Check for any duplicate UNIQUE_IDs (should be zero)
duplicate_ids <- sum(duplicated(pooled_data$UNIQUE_ID))
cat("\nDuplicate UNIQUE_IDs:", duplicate_ids, "\n")
if (duplicate_ids == 0) {
  cat("✓ All respondents have unique identifiers\n")
} else {
  cat("⚠ Warning: Found duplicate identifiers\n")
}

# Show basic structure of merged data
cat("\nStructure of pooled dataset (first few columns):\n")
str(pooled_data[1:7])  # Show first 7 columns including SURVEY_YEAR and UNIQUE_ID

# Save the pooled dataset
cat("\n", paste(rep("-", 60), collapse=""), "\n")
cat("SAVING POOLED DATASET\n")
cat(paste(rep("-", 60), collapse=""), "\n")

# Save as RData file
save(pooled_data, file = "pooled_data_1997_2003.RData")
cat("✓ Saved as pooled_data_1997_2003.RData\n")

# Save as CSV file
write.csv(pooled_data, "pooled_data_1997_2003.csv", row.names = FALSE)
cat("✓ Saved as pooled_data_1997_2003.csv\n")

# Save as Stata file
write_dta(pooled_data, "pooled_data_1997_2003.dta")
cat("✓ Saved as pooled_data_1997_2003.dta\n")

# Update the data_list to include the pooled dataset
data_list$pooled <- pooled_data

cat("\nPooled dataset is available as 'pooled_data' and in data_list$pooled\n")