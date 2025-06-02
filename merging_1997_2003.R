# Load required library for reading Stata files
library(haven)
library(dplyr)  # For data manipulation

# Define the directory path
data_dir <- "/home/siyang/vaping2_working_data/core_data/"

# Import all 7 Stata data files
data_1997 <- read_dta(paste0(data_dir, "97-0001-Data.dta"))
data_1998 <- read_dta(paste0(data_dir, "98-0001-Data.dta"))
data_1999 <- read_dta(paste0(data_dir, "99-0001-Data.dta"))
data_2000 <- read_dta(paste0(data_dir, "00-0001-Data.dta"))
data_2001 <- read_dta(paste0(data_dir, "01-0001-Data.dta"))
data_2002 <- read_dta(paste0(data_dir, "02-0001-Data.dta"))
data_2003 <- read_dta(paste0(data_dir, "03-0001-Data.dta"))

# Display basic information about each dataset
cat("Data imported successfully!\n\n")

cat("1997 Data dimensions:", dim(data_1997), "\n")
cat("1998 Data dimensions:", dim(data_1998), "\n")
cat("1999 Data dimensions:", dim(data_1999), "\n")
cat("2000 Data dimensions:", dim(data_2000), "\n")
cat("2001 Data dimensions:", dim(data_2001), "\n")
cat("2002 Data dimensions:", dim(data_2002), "\n")
cat("2003 Data dimensions:", dim(data_2003), "\n")

# Optional: View the structure of the first dataset as an example
cat("\nStructure of 1997 data (first few columns):\n")
str(data_1997[1:5])

# Optional: Store all datasets in a list for easier manipulation
data_list <- list(
  "1997" = data_1997,
  "1998" = data_1998,
  "1999" = data_1999,
  "2000" = data_2000,
  "2001" = data_2001,
  "2002" = data_2002,
  "2003" = data_2003
)

cat("\nAll datasets are now available as individual dataframes and in the 'data_list' list.\n")

# Source the missing data recoding scripts
source("recode_1997_missing.R")
source("recode_1998_missing.R")
source("recode_1999_missing.R")
source("recode_2000_missing.R")
source("recode_2001_missing.R")
source("recode_2002_missing.R")
source("recode_2003_missing.R")

# Source the Missing Data Analysis script
source("missing_data_analysis.R")

# Source the merging script
source("merge_data.R")

