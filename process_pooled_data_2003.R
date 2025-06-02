# Process pooled data with 2003-style transformations
# Load required libraries
library(dplyr)
library(haven)

# Load the pooled data
load("pooled_data_1997_2003.RData")

# Display basic information about the dataset
cat("Pooled data loaded successfully!\n")
cat("Dataset dimensions:", dim(pooled_data), "\n")
cat("Column names:", names(pooled_data), "\n\n")

# Convert haven_labelled variables to numeric to avoid comparison issues
pooled_data <- pooled_data %>%
  mutate(across(where(is.labelled), as.numeric))

# Apply the transformations from the Stata script
# Note: Missing data recoding (-9 to NA) is already done, so focusing on value transformations

# Current smoke cigarette: V102 -> cig
# recode V102 (1=0) (2/7=1), g(cig)
pooled_data <- pooled_data %>%
  mutate(cig = case_when(
    V102 == 1 ~ 0,
    V102 >= 2 & V102 <= 7 ~ 1,
    TRUE ~ NA_real_
  ))

# Region: clonevar region=V13
pooled_data <- pooled_data %>%
  mutate(region = V13)

# Age: V148 -> age18
# recode V148 (1=0) (2=1), g(age18)
pooled_data <- pooled_data %>%
  mutate(age18 = case_when(
    V148 == 1 ~ 0,
    V148 == 2 ~ 1,
    TRUE ~ NA_real_
  ))

# Female: V150 -> female
# recode V150 (1=0) (2=1), g(female)
pooled_data <- pooled_data %>%
  mutate(female = case_when(
    V150 == 1 ~ 0,
    V150 == 2 ~ 1,
    TRUE ~ NA_real_
  ))

# Highest parent education of mother and father
# recode V163 V164 (7=.), g(daded momed)
# egen pared=rowmax(daded momed)
pooled_data <- pooled_data %>%
  mutate(
    daded = ifelse(V163 == 7, NA, V163),
    momed = ifelse(V164 == 7, NA, V164),
    pared = pmax(daded, momed, na.rm = TRUE)
  ) %>%
  # If both are NA, pared should be NA
  mutate(pared = ifelse(is.na(daded) & is.na(momed), NA, pared))

# Skip class: V178 -> skip
pooled_data <- pooled_data %>%
  mutate(skip = V178)

# GPA: V179 -> gpa
pooled_data <- pooled_data %>%
  mutate(gpa = V179)

# Nights out: V194 -> goout
pooled_data <- pooled_data %>%
  mutate(goout = V194)

# 21+ hours of work: V191 -> work
# recode V191 (1=0) (2/5=1) (6/8=2), g(work)
pooled_data <- pooled_data %>%
  mutate(work = case_when(
    V191 == 1 ~ 0,
    V191 >= 2 & V191 <= 5 ~ 1,
    V191 >= 6 & V191 <= 8 ~ 2,
    TRUE ~ NA_real_
  ))

# Current cannabis: V117 -> ccannabis
# recode V117 (1=0) (2/7=1), g(ccannabis)
pooled_data <- pooled_data %>%
  mutate(ccannabis = case_when(
    V117 == 1 ~ 0,
    V117 >= 2 & V117 <= 7 ~ 1,
    TRUE ~ NA_real_
  ))

# Current drink: V106 -> cdrink
# recode V106 (1=0) (2/7=1), g(cdrink)
pooled_data <- pooled_data %>%
  mutate(cdrink = case_when(
    V106 == 1 ~ 0,
    V106 >= 2 & V106 <= 7 ~ 1,
    TRUE ~ NA_real_
  ))

# Race: V151 -> wrace
# recode V151 (0=1) (1=0), g(wrace)
pooled_data <- pooled_data %>%
  mutate(wrace = case_when(
    V151 == 0 ~ 1,
    V151 == 1 ~ 0,
    TRUE ~ NA_real_
  ))

# College expectations: V183 -> collexp
pooled_data <- pooled_data %>%
  mutate(collexp = V183)

# Dates: V195 -> dates
pooled_data <- pooled_data %>%
  mutate(dates = V195)

# Create year variable (set to 2003 for all observations as in Stata script)
pooled_data <- pooled_data %>%
  mutate(year = 2003)

# Summary of the new variables
cat("Summary of created variables:\n")
summary(pooled_data[c("cig", "region", "age18", "female", "pared", "skip", "gpa", 
                      "goout", "work", "ccannabis", "cdrink", "wrace", "collexp", 
                      "dates", "V5", "year")])

# Keep only the specified variables (equivalent to Stata's 'keep' command)
# keep CASEID cig region age18 female pared skip gpa goout work ccannabis cdrink wrace collexp dates V5
final_data <- pooled_data %>%
  select(CASEID, cig, region, age18, female, pared, skip, gpa, goout, work, 
         ccannabis, cdrink, wrace, collexp, dates, V5, year)

# Display final dataset information
cat("\nFinal dataset dimensions:", dim(final_data), "\n")
cat("Final dataset variables:", names(final_data), "\n")

# Save the processed data
save(final_data, file = "processed_pooled_data_2003.RData")
cat("\nProcessed data saved as 'processed_pooled_data_2003.RData'\n")

# Display first few rows
cat("\nFirst few rows of processed data:\n")
head(final_data) 