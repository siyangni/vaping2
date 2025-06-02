# Export processed data to Stata format
# Load required library
library(haven)

# Load the processed data
load("processed_pooled_data_2003.RData")

# Display information about the data to be exported
cat("Exporting processed data to Stata format...\n")
cat("Dataset dimensions:", dim(final_data), "\n")
cat("Variables:", names(final_data), "\n\n")

# Export to Stata .dta format
write_dta(final_data, "processed_pooled_data_2003.dta")

# Confirm export
cat("Data successfully exported to 'processed_pooled_data_2003.dta'\n")

# Display file information
file_info <- file.info("processed_pooled_data_2003.dta")
cat("File size:", round(file_info$size / 1024 / 1024, 2), "MB\n")
cat("Export completed!\n") 