# ===============================================================================
# MISSING DATA ANALYSIS
# ===============================================================================

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("MISSING DATA ANALYSIS\n")
cat(paste(rep("=", 80), collapse=""), "\n\n")

# Function to calculate missing data statistics for a dataset
analyze_missing_data <- function(data, year) {
  total_cells <- nrow(data) * ncol(data)
  missing_cells <- sum(is.na(data))
  missing_percentage <- round((missing_cells / total_cells) * 100, 2)
  
  # Missing data by variable
  var_missing <- sapply(data, function(x) sum(is.na(x)))
  var_missing_pct <- round((var_missing / nrow(data)) * 100, 2)
  
  # Variables with no missing data
  complete_vars <- names(var_missing)[var_missing == 0]
  
  # Variables with high missing data (>50%)
  high_missing_vars <- names(var_missing_pct)[var_missing_pct > 50]
  
  cat("Dataset:", year, "\n")
  cat("  Total observations:", nrow(data), "\n")
  cat("  Total variables:", ncol(data), "\n")
  cat("  Total cells:", total_cells, "\n")
  cat("  Missing cells:", missing_cells, "\n")
  cat("  Overall missing percentage:", missing_percentage, "%\n")
  cat("  Variables with no missing data:", length(complete_vars), "\n")
  cat("  Variables with >50% missing:", length(high_missing_vars), "\n")
  
  if (length(high_missing_vars) > 0) {
    cat("  High missing variables:", paste(high_missing_vars, collapse=", "), "\n")
  }
  cat("\n")
  
  # Return summary for further analysis
  return(list(
    year = year,
    n_obs = nrow(data),
    n_vars = ncol(data),
    missing_cells = missing_cells,
    missing_pct = missing_percentage,
    complete_vars = complete_vars,
    high_missing_vars = high_missing_vars,
    var_missing_pct = var_missing_pct
  ))
}

# Analyze missing data for each dataset
missing_summaries <- list()
for (year in names(data_list)) {
  missing_summaries[[year]] <- analyze_missing_data(data_list[[year]], year)
}

# Create summary table of missing data patterns across years
cat("SUMMARY TABLE: Missing Data Across Years\n")
cat(paste(rep("-", 60), collapse=""), "\n")
cat(sprintf("%-6s %-8s %-8s %-12s %-10s\n", "Year", "N_Obs", "N_Vars", "Missing_%", "Complete_Vars"))
cat(paste(rep("-", 60), collapse=""), "\n")

for (year in names(missing_summaries)) {
  summary <- missing_summaries[[year]]
  cat(sprintf("%-6s %-8d %-8d %-12.2f %-10d\n", 
              year, summary$n_obs, summary$n_vars, 
              summary$missing_pct, length(summary$complete_vars)))
}
cat(paste(rep("-", 60), collapse=""), "\n\n")

# Analyze missing data patterns for ALL variables across years
# Get all unique variables across all datasets
all_unique_vars <- unique(unlist(lapply(data_list, names)))
cat("MISSING DATA PATTERNS FOR ALL VARIABLES\n")
cat(paste(rep("-", 70), collapse=""), "\n")
cat("Total unique variables found:", length(all_unique_vars), "\n\n")

# Create a comprehensive matrix for ALL variables
all_missing_matrix <- matrix(NA, nrow = length(all_unique_vars), ncol = length(data_list))
rownames(all_missing_matrix) <- all_unique_vars
colnames(all_missing_matrix) <- names(data_list)

# Fill the matrix with missing percentages for all variables
for (i in 1:length(all_unique_vars)) {
  var <- all_unique_vars[i]
  for (j in 1:length(data_list)) {
    year <- names(data_list)[j]
    if (var %in% names(data_list[[year]])) {
      missing_pct <- round((sum(is.na(data_list[[year]][[var]])) / nrow(data_list[[year]])) * 100, 1)
      all_missing_matrix[i, j] <- missing_pct
    }
  }
}

# Sort variables by average missing percentage for better readability
avg_missing <- rowMeans(all_missing_matrix, na.rm = TRUE)
sorted_indices <- order(avg_missing)
all_missing_matrix_sorted <- all_missing_matrix[sorted_indices, ]

# Print summary of missing data patterns
cat("SUMMARY BY MISSING DATA LEVEL:\n")
cat(paste(rep("-", 40), collapse=""), "\n")

# Complete variables (0% missing across all years where they exist)
complete_vars_all_years <- rownames(all_missing_matrix_sorted)[
  apply(all_missing_matrix_sorted, 1, function(x) all(x == 0, na.rm = TRUE) && !all(is.na(x)))
]

# Variables with low missing (0-10%)
low_missing_vars <- rownames(all_missing_matrix_sorted)[
  apply(all_missing_matrix_sorted, 1, function(x) {
    non_na_values <- x[!is.na(x)]
    length(non_na_values) > 0 && all(non_na_values <= 10) && any(non_na_values > 0)
  })
]

# Variables with moderate missing (10-50%)
moderate_missing_vars <- rownames(all_missing_matrix_sorted)[
  apply(all_missing_matrix_sorted, 1, function(x) {
    non_na_values <- x[!is.na(x)]
    length(non_na_values) > 0 && any(non_na_values > 10) && all(non_na_values <= 50)
  })
]

# Variables with high missing (>50%)
high_missing_vars <- rownames(all_missing_matrix_sorted)[
  apply(all_missing_matrix_sorted, 1, function(x) {
    non_na_values <- x[!is.na(x)]
    length(non_na_values) > 0 && any(non_na_values > 50)
  })
]

cat("Complete variables (0% missing):", length(complete_vars_all_years), "\n")
cat("Low missing variables (1-10%):", length(low_missing_vars), "\n")
cat("Moderate missing variables (10-50%):", length(moderate_missing_vars), "\n")
cat("High missing variables (>50%):", length(high_missing_vars), "\n\n")

# Print the complete matrix (this will be large, so we'll also save it for inspection)
cat("COMPLETE MISSING DATA MATRIX (first 20 variables shown):\n")
cat(paste(rep("-", 70), collapse=""), "\n")

# Print header
cat(sprintf("%-12s", "Variable"))
for (year in colnames(all_missing_matrix_sorted)) {
  cat(sprintf("%-8s", year))
}
cat("\n")
cat(paste(rep("-", 12 + 8*ncol(all_missing_matrix_sorted)), collapse=""), "\n")

# Print first 20 rows for display
display_rows <- min(20, nrow(all_missing_matrix_sorted))
for (i in 1:display_rows) {
  var_name <- rownames(all_missing_matrix_sorted)[i]
  cat(sprintf("%-12s", substr(var_name, 1, 11)))
  for (j in 1:ncol(all_missing_matrix_sorted)) {
    if (is.na(all_missing_matrix_sorted[i, j])) {
      cat(sprintf("%-8s", "N/A"))
    } else {
      cat(sprintf("%-8.1f", all_missing_matrix_sorted[i, j]))
    }
  }
  cat("\n")
}

if (nrow(all_missing_matrix_sorted) > 20) {
  cat("... (showing first 20 of", nrow(all_missing_matrix_sorted), "variables)\n")
}
cat("\n")

# Also create a focused view of key variables for comparison
key_vars <- c("CASEID", "V1", "V3", "V4", "V5", "V13", "V16", "V17", "V49")
cat("KEY VARIABLES MISSING DATA PATTERNS:\n")
cat(paste(rep("-", 50), collapse=""), "\n")

key_missing_matrix <- all_missing_matrix[key_vars[key_vars %in% rownames(all_missing_matrix)], ]

cat(sprintf("%-8s", "Variable"))
for (year in colnames(key_missing_matrix)) {
  cat(sprintf("%-8s", year))
}
cat("\n")
cat(paste(rep("-", 8 + 8*ncol(key_missing_matrix)), collapse=""), "\n")

for (i in 1:nrow(key_missing_matrix)) {
  cat(sprintf("%-8s", rownames(key_missing_matrix)[i]))
  for (j in 1:ncol(key_missing_matrix)) {
    if (is.na(key_missing_matrix[i, j])) {
      cat(sprintf("%-8s", "N/A"))
    } else {
      cat(sprintf("%-8.1f", key_missing_matrix[i, j]))
    }
  }
  cat("\n")
}
cat("\n")

# Function to identify variables that exist across multiple years
common_vars_analysis <- function(data_list) {
  all_vars <- unique(unlist(lapply(data_list, names)))
  var_presence <- matrix(FALSE, nrow = length(all_vars), ncol = length(data_list))
  rownames(var_presence) <- all_vars
  colnames(var_presence) <- names(data_list)
  
  for (i in 1:length(all_vars)) {
    var <- all_vars[i]
    for (j in 1:length(data_list)) {
      var_presence[i, j] <- var %in% names(data_list[[j]])
    }
  }
  
  # Variables present in all years
  all_years_vars <- rownames(var_presence)[rowSums(var_presence) == ncol(var_presence)]
  
  # Variables present in some but not all years
  partial_vars <- rownames(var_presence)[rowSums(var_presence) > 0 & rowSums(var_presence) < ncol(var_presence)]
  
  cat("VARIABLE PRESENCE ACROSS YEARS\n")
  cat(paste(rep("-", 40), collapse=""), "\n")
  cat("Variables present in all years:", length(all_years_vars), "\n")
  cat("Variables present in some years:", length(partial_vars), "\n")
  cat("Total unique variables:", length(all_vars), "\n\n")
  
  if (length(partial_vars) > 0 && length(partial_vars) <= 20) {
    cat("Variables with partial presence:\n")
    for (var in partial_vars) {
      years_present <- names(data_list)[var_presence[var, ]]
      cat(sprintf("  %-10s: %s\n", var, paste(years_present, collapse=", ")))
    }
    cat("\n")
  }
  
  return(list(
    all_years_vars = all_years_vars,
    partial_vars = partial_vars,
    var_presence_matrix = var_presence
  ))
}

# Analyze variable presence across years
var_analysis <- common_vars_analysis(data_list)

# Save missing data analysis results
cat("SAVING MISSING DATA ANALYSIS RESULTS\n")
cat(paste(rep("-", 40), collapse=""), "\n")

# Create a comprehensive summary dataframe
missing_summary_df <- do.call(rbind, lapply(names(missing_summaries), function(year) {
  summary <- missing_summaries[[year]]
  data.frame(
    Year = year,
    N_Observations = summary$n_obs,
    N_Variables = summary$n_vars,
    Missing_Cells = summary$missing_cells,
    Missing_Percentage = summary$missing_pct,
    Complete_Variables = length(summary$complete_vars),
    High_Missing_Variables = length(summary$high_missing_vars),
    stringsAsFactors = FALSE
  )
}))

# Save results to the global environment
missing_data_summary <<- missing_summary_df
missing_data_by_variable <<- key_missing_matrix  # Key variables for quick reference
missing_data_all_variables <<- all_missing_matrix_sorted  # ALL variables comprehensive matrix
variable_presence_analysis <<- var_analysis
complete_variables_list <<- complete_vars_all_years
high_missing_variables_list <<- high_missing_vars

cat("Missing data analysis complete!\n")
cat("Results saved as:\n")
cat("  - missing_data_summary: Overall summary by year\n")
cat("  - missing_data_by_variable: Key variables missing % by year\n")
cat("  - missing_data_all_variables: ALL variables missing % by year (sorted by avg missing)\n")
cat("  - variable_presence_analysis: Variable presence across years\n")
cat("  - complete_variables_list: List of variables with 0% missing\n")
cat("  - high_missing_variables_list: List of variables with >50% missing\n\n")

# Print instructions for viewing the complete data
cat("TO VIEW ALL VARIABLES:\n")
cat("  - View(missing_data_all_variables)  # Opens data viewer\n")
cat("  - print(missing_data_all_variables)  # Prints to console\n")
cat("  - write.csv(missing_data_all_variables, 'missing_data_all_vars.csv')  # Save to file\n\n")