# Multiple Imputation Analysis for Pooled Data 1997-2003
# Load required libraries
library(dplyr)
library(mice)      # For multiple imputation
library(survey)    # For survey analysis
library(VIM)       # For missing data visualization
library(haven)

# Load the pooled data
load("pooled_data_1997_2003.RData")

# Display basic information
cat("=== MULTIPLE IMPUTATION ANALYSIS FOR POOLED DATA 1997-2003 ===\n\n")
cat("Original dataset dimensions:", dim(pooled_data), "\n")

# Convert haven_labelled to numeric
pooled_data <- pooled_data %>%
  mutate(across(where(is.labelled), as.numeric))

# Apply the same transformations as in the processing script to get consistent variables
# Current smoke cigarette: V102 -> cig
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
pooled_data <- pooled_data %>%
  mutate(age18 = case_when(
    V148 == 1 ~ 0,
    V148 == 2 ~ 1,
    TRUE ~ NA_real_
  ))

# Female: V150 -> female
pooled_data <- pooled_data %>%
  mutate(female = case_when(
    V150 == 1 ~ 0,
    V150 == 2 ~ 1,
    TRUE ~ NA_real_
  ))

# Highest parent education
pooled_data <- pooled_data %>%
  mutate(
    daded = ifelse(V163 == 7, NA, V163),
    momed = ifelse(V164 == 7, NA, V164),
    pared = pmax(daded, momed, na.rm = TRUE)
  ) %>%
  mutate(pared = ifelse(is.na(daded) & is.na(momed), NA, pared))

# Other variables
pooled_data <- pooled_data %>%
  mutate(
    skip = V178,
    gpa = V179,
    goout = V194,
    work = case_when(
      V191 == 1 ~ 0,
      V191 >= 2 & V191 <= 5 ~ 1,
      V191 >= 6 & V191 <= 8 ~ 2,
      TRUE ~ NA_real_
    ),
    ccannabis = case_when(
      V117 == 1 ~ 0,
      V117 >= 2 & V117 <= 7 ~ 1,
      TRUE ~ NA_real_
    ),
    cdrink = case_when(
      V106 == 1 ~ 0,
      V106 >= 2 & V106 <= 7 ~ 1,
      TRUE ~ NA_real_
    ),
    wrace = case_when(
      V151 == 0 ~ 1,
      V151 == 1 ~ 0,
      TRUE ~ NA_real_
    ),
    collexp = V183,
    dates = V195
  )

# Create year variable for 1997-2003 (recode to match the pattern)
# Since we have SURVEY_YEAR, let's use that and recode appropriately
pooled_data <- pooled_data %>%
  mutate(year_cat = case_when(
    SURVEY_YEAR == 1997 ~ 1,
    SURVEY_YEAR == 1998 ~ 2,
    SURVEY_YEAR == 1999 ~ 3,
    SURVEY_YEAR == 2000 ~ 4,
    SURVEY_YEAR == 2001 ~ 5,
    SURVEY_YEAR == 2002 ~ 6,
    SURVEY_YEAR == 2003 ~ 7,
    TRUE ~ NA_real_
  ))

# Note: cvape (vaping) did not exist in 1997-2003, so we'll exclude it from analysis
# Select variables for imputation (excluding cvape since vaping wasn't available then)
imputation_vars <- c("CASEID", "region", "work", "cig", "age18", "female", 
                     "ccannabis", "cdrink", "wrace", "pared", "skip", "gpa", 
                     "goout", "collexp", "dates", "year_cat", "V5")

# Create analysis dataset
analysis_data <- pooled_data %>%
  select(all_of(imputation_vars))

cat("Analysis dataset dimensions:", dim(analysis_data), "\n")
cat("Variables for imputation:\n")
print(names(analysis_data))

# Check missing data patterns
cat("\n=== MISSING DATA PATTERN ANALYSIS ===\n")
missing_pattern <- md.pattern(analysis_data, rotate.names = TRUE)

# Prepare data for multiple imputation
# Remove CASEID and V5 from imputation (keep as auxiliaries)
imp_data <- analysis_data %>%
  select(-CASEID, -V5)

# Set up imputation method
# Categorical variables: pmm or polyreg
# Binary variables: logreg  
# Continuous variables: pmm

method_vector <- rep("", ncol(imp_data))
names(method_vector) <- names(imp_data)

# Set methods based on variable types
method_vector["region"] <- "polyreg"        # multinomial (1-4 regions)
method_vector["work"] <- "polyreg"          # multinomial (0, 1, 2)
method_vector["cig"] <- "logreg"            # binary
method_vector["age18"] <- "logreg"          # binary
method_vector["female"] <- "logreg"         # binary
method_vector["ccannabis"] <- "logreg"      # binary
method_vector["cdrink"] <- "logreg"         # binary
method_vector["wrace"] <- "logreg"          # binary
method_vector["pared"] <- "pmm"             # ordinal/continuous
method_vector["skip"] <- "pmm"              # ordinal/continuous
method_vector["gpa"] <- "pmm"               # continuous
method_vector["goout"] <- "pmm"             # ordinal/continuous
method_vector["collexp"] <- "pmm"           # ordinal/continuous
method_vector["dates"] <- "pmm"             # ordinal/continuous
method_vector["year_cat"] <- "polyreg"      # multinomial (1-7)

cat("\n=== IMPUTATION SETUP ===\n")
cat("Imputation methods:\n")
print(method_vector)

# Perform multiple imputation
# Note: Using fewer imputations (20) initially for faster processing, can increase to 50
cat("\n=== PERFORMING MULTIPLE IMPUTATION ===\n")
cat("Starting imputation process (this may take a few minutes)...\n")

set.seed(1174778793)  # Same seed as in Stata script
mice_imp <- mice(imp_data, 
                 method = method_vector,
                 m = 20,  # Number of imputations (can increase to 50)
                 maxit = 20,  # Maximum iterations
                 printFlag = TRUE)

cat("\n=== IMPUTATION COMPLETED ===\n")
cat("Number of imputations:", mice_imp$m, "\n")
cat("Number of iterations:", mice_imp$iteration, "\n")

# Check convergence
plot(mice_imp)

# Create complete datasets
complete_data_list <- vector("list", mice_imp$m)
for(i in 1:mice_imp$m) {
  complete_data_list[[i]] <- complete(mice_imp, i) %>%
    mutate(
      CASEID = analysis_data$CASEID,
      V5 = analysis_data$V5,
      .imp = i
    )
}

# Combine all imputed datasets
all_imputed <- bind_rows(complete_data_list)

cat("\n=== DESCRIPTIVE ANALYSIS ON IMPUTED DATA ===\n")

# Proportions for key variables (pooled across imputations)
prop_results <- all_imputed %>%
  group_by(.imp) %>%
  summarise(
    prop_cig = mean(cig, na.rm = TRUE),
    prop_ccannabis = mean(ccannabis, na.rm = TRUE),
    prop_cdrink = mean(cdrink, na.rm = TRUE),
    prop_female = mean(female, na.rm = TRUE),
    prop_age18 = mean(age18, na.rm = TRUE),
    .groups = "drop"
  )

pooled_props <- prop_results %>%
  summarise(
    across(starts_with("prop_"), list(mean = mean, se = sd)),
    .groups = "drop"
  )

cat("Pooled proportions across imputations:\n")
print(pooled_props)

# Proportions by year
prop_by_year <- all_imputed %>%
  group_by(.imp, year_cat) %>%
  summarise(
    prop_cig = mean(cig, na.rm = TRUE),
    prop_ccannabis = mean(ccannabis, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  group_by(year_cat) %>%
  summarise(
    prop_cig_mean = mean(prop_cig),
    prop_cig_se = sd(prop_cig),
    prop_ccannabis_mean = mean(prop_ccannabis),
    prop_ccannabis_se = sd(prop_ccannabis),
    n_mean = mean(n),
    .groups = "drop"
  )

cat("\nProportions by year (1997-2003):\n")
print(prop_by_year)

# Save results
save(mice_imp, all_imputed, analysis_data, 
     file = "multiple_imputation_results_1997_2003.RData")

cat("\n=== ANALYSIS COMPLETE ===\n")
cat("Results saved to 'multiple_imputation_results_1997_2003.RData'\n")
cat("Total imputed datasets:", mice_imp$m, "\n")
cat("Note: Vaping variables excluded as vaping was not available in 1997-2003\n") 