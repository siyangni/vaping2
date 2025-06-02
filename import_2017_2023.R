# Load required library for reading Stata files
library(haven)

# Import the Stata .dta file
# Converting Windows UNC path @\\wsl.localhost\Ubuntu\home\siyang\vaping2_working_data\2017_2023_jeremy.dta
# to Linux path format
data_2017_2023 <- read_dta("/home/siyang/vaping2_working_data/2017_2023_jeremy.dta")

# Display basic information about the imported data
print(paste("Data dimensions:", nrow(data_2017_2023), "rows,", ncol(data_2017_2023), "columns"))
print("Variable names:")
print(names(data_2017_2023))
print("First few rows:")
print(head(data_2017_2023))
