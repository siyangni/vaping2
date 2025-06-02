# Data Processing Summary: Pooled Data 1997-2003

## Overview
This document summarizes the data processing performed on the pooled dataset (`pooled_data_1997_2003.RData`) following the Stata script transformations for 2003 data.

## Dataset Information
- **Original dataset dimensions**: 101,133 observations × 110 variables
- **Final dataset dimensions**: 101,133 observations × 17 variables
- **Output file**: `processed_pooled_data_2003.RData`

## Variable Transformations Applied

### 1. Smoking Behavior
- **cig** (from V102): Current cigarette smoking
  - 1 → 0 (non-smoker)
  - 2-7 → 1 (current smoker)

### 2. Demographics
- **region** (from V13): Geographic region (direct copy)
- **age18** (from V148): Age indicator
  - 1 → 0 (under 18)
  - 2 → 1 (18 or older)
- **female** (from V150): Gender indicator
  - 1 → 0 (male)
  - 2 → 1 (female)

### 3. Family Background
- **pared** (from V163, V164): Highest parental education
  - Created from maximum of father's (daded) and mother's (momed) education
  - Value 7 recoded to missing for both parent variables
- **daded** (from V163): Father's education (7 → missing)
- **momed** (from V164): Mother's education (7 → missing)

### 4. Academic Variables
- **skip** (from V178): Skip class frequency (direct copy)
- **gpa** (from V179): Grade point average (direct copy)
- **collexp** (from V183): College expectations (direct copy)

### 5. Social Behavior
- **goout** (from V194): Nights out frequency (direct copy)
- **dates** (from V195): Dating frequency (direct copy)
- **work** (from V191): Work hours categorization
  - 1 → 0 (no work/minimal hours)
  - 2-5 → 1 (moderate work hours)
  - 6-8 → 2 (high work hours, 21+ hours)

### 6. Substance Use
- **ccannabis** (from V117): Current cannabis use
  - 1 → 0 (non-user)
  - 2-7 → 1 (current user)
- **cdrink** (from V106): Current drinking
  - 1 → 0 (non-drinker)
  - 2-7 → 1 (current drinker)

### 7. Race/Ethnicity
- **wrace** (from V151): White race indicator
  - 0 → 1 (white)
  - 1 → 0 (non-white)

### 8. Additional Variables
- **V5**: Survey weight variable (kept as is)
- **year**: Year indicator (set to 2003 for all observations)
- **CASEID**: Case identifier (kept as is)

## Key Processing Notes

1. **Haven Labels Handling**: All haven_labelled variables from Stata import were converted to numeric to enable proper comparisons and transformations.

2. **Missing Data**: The script assumes missing data recoding (-9 → NA) was already performed in previous steps, so it focuses on value transformations only.

3. **Variable Selection**: The final dataset includes only the variables specified in the original Stata script's "keep" command.

4. **Year Assignment**: All observations were assigned year = 2003, following the original Stata script logic.

## Summary Statistics

The processed dataset contains:
- **N = 101,133** total observations
- **17 variables** (including identifiers, recoded variables, and year)
- Various levels of missing data across variables (ranging from no missing data for region and year to ~25% missing for race variables)

The data is now ready for analysis following the same structure as the original 2003 Stata processing pipeline. 