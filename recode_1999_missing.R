# ===============================================================================
# Script: recode_1999_missing.R
# Purpose: Recode missing data for 1999 dataset
# Author: Generated for vaping2 project
# Date: Created for data cleaning workflow
# ===============================================================================

# Function to recode missing data for 1999 dataset
recode_1999_missing <- function(data_1999) {
  
  cat("Recoding missing data for 1999 dataset...\n")
  
  # CASEID: set to NA if -9
  data_1999$CASEID[data_1999$CASEID == -9] <- NA
  
  # V13: set to NA if 0
  data_1999$V13[data_1999$V13 == 0] <- NA
  
  # V16: set to NA if 0
  data_1999$V16[data_1999$V16 == 0] <- NA
  
  # V17: set to NA if 0
  data_1999$V17[data_1999$V17 == 0] <- NA
  
  # V5: set to NA if -9.0000 (same as -9)
  data_1999$V5[data_1999$V5 == -9] <- NA
  
  # V1: set to NA if -9
  data_1999$V1[data_1999$V1 == -9] <- NA
  
  # V3: set to NA if 0
  data_1999$V3[data_1999$V3 == 0] <- NA
  
  # V4: set to NA if -9
  data_1999$V4[data_1999$V4 == -9] <- NA
  
  # V130: set to NA if -9
  data_1999$V130[data_1999$V130 == -9] <- NA
  
  # V131: set to NA if -9
  data_1999$V131[data_1999$V131 == -9] <- NA
  
  # V132: set to NA if -9
  data_1999$V132[data_1999$V132 == -9] <- NA
  
  # V49: set to NA if -9
  data_1999$V49[data_1999$V49 == -9] <- NA
  
  # V101: set to NA if -9
  data_1999$V101[data_1999$V101 == -9] <- NA
  
  # V102: set to NA if -9
  data_1999$V102[data_1999$V102 == -9] <- NA
  
  # V103: set to NA if -9
  data_1999$V103[data_1999$V103 == -9] <- NA
  
  # V104: set to NA if -9
  data_1999$V104[data_1999$V104 == -9] <- NA
  
  # V105: set to NA if -9
  data_1999$V105[data_1999$V105 == -9] <- NA
  
  # V106: set to NA if -9
  data_1999$V106[data_1999$V106 == -9] <- NA
  
  # V107: set to NA if -9
  data_1999$V107[data_1999$V107 == -9] <- NA
  
  # V108: set to NA if -9
  data_1999$V108[data_1999$V108 == -9] <- NA
  
  # V109: set to NA if -9
  data_1999$V109[data_1999$V109 == -9] <- NA
  
  # V110: set to NA if -9
  data_1999$V110[data_1999$V110 == -9] <- NA
  
  # V111: set to NA if -9
  data_1999$V111[data_1999$V111 == -9] <- NA
  
  # V112: set to NA if -9
  data_1999$V112[data_1999$V112 == -9] <- NA
  
  # V113: set to NA if -9
  data_1999$V113[data_1999$V113 == -9] <- NA
  
  # V114: set to NA if -9
  data_1999$V114[data_1999$V114 == -9] <- NA
  
  # V115: set to NA if -9
  data_1999$V115[data_1999$V115 == -9] <- NA
  
  # V116: set to NA if -9
  data_1999$V116[data_1999$V116 == -9] <- NA
  
  # V117: set to NA if -9
  data_1999$V117[data_1999$V117 == -9] <- NA
  
  # V118: set to NA if -9
  data_1999$V118[data_1999$V118 == -9] <- NA
  
  # V119: set to NA if -9
  data_1999$V119[data_1999$V119 == -9] <- NA
  
  # V120: set to NA if -9
  data_1999$V120[data_1999$V120 == -9] <- NA
  
  # V121: set to NA if -9
  data_1999$V121[data_1999$V121 == -9] <- NA
  
  # V122: set to NA if -9
  data_1999$V122[data_1999$V122 == -9] <- NA
  
  # V123: set to NA if -9
  data_1999$V123[data_1999$V123 == -9] <- NA
  
  # V124: set to NA if -9
  data_1999$V124[data_1999$V124 == -9] <- NA
  
  # V125: set to NA if -9
  data_1999$V125[data_1999$V125 == -9] <- NA
  
  # V126: set to NA if -9
  data_1999$V126[data_1999$V126 == -9] <- NA
  
  # V127: set to NA if -9
  data_1999$V127[data_1999$V127 == -9] <- NA
  
  # V128: set to NA if -9
  data_1999$V128[data_1999$V128 == -9] <- NA
  
  # V129: set to NA if -9
  data_1999$V129[data_1999$V129 == -9] <- NA
  
  # V133: set to NA if -9
  data_1999$V133[data_1999$V133 == -9] <- NA
  
  # V134: set to NA if -9
  data_1999$V134[data_1999$V134 == -9] <- NA
  
  # V135: set to NA if -9
  data_1999$V135[data_1999$V135 == -9] <- NA
  
  # V136: set to NA if -9
  data_1999$V136[data_1999$V136 == -9] <- NA
  
  # V137: set to NA if -9
  data_1999$V137[data_1999$V137 == -9] <- NA
  
  # V138: set to NA if -9
  data_1999$V138[data_1999$V138 == -9] <- NA
  
  # V139: set to NA if -9
  data_1999$V139[data_1999$V139 == -9] <- NA
  
  # V140: set to NA if -9
  data_1999$V140[data_1999$V140 == -9] <- NA
  
  # V141: set to NA if -9
  data_1999$V141[data_1999$V141 == -9] <- NA
  
  # V142: set to NA if -9
  data_1999$V142[data_1999$V142 == -9] <- NA
  
  # V143: set to NA if -9
  data_1999$V143[data_1999$V143 == -9] <- NA
  
  # V144: set to NA if -9
  data_1999$V144[data_1999$V144 == -9] <- NA
  
  # V145: set to NA if -9
  data_1999$V145[data_1999$V145 == -9] <- NA
  
  # V146: set to NA if -9
  data_1999$V146[data_1999$V146 == -9] <- NA
  
  # V147: set to NA if -9
  data_1999$V147[data_1999$V147 == -9] <- NA
  
  # V148: set to NA if -9
  data_1999$V148[data_1999$V148 == -9] <- NA
  
  # V150: set to NA if -9
  data_1999$V150[data_1999$V150 == -9] <- NA
  
  # V151: set to NA if -9
  data_1999$V151[data_1999$V151 == -9] <- NA
  
  # V152: set to NA if -9
  data_1999$V152[data_1999$V152 == -9] <- NA
  
  # V153: set to NA if -9
  data_1999$V153[data_1999$V153 == -9] <- NA
  
  # V155: set to NA if -9
  data_1999$V155[data_1999$V155 == -9] <- NA
  
  # V156: set to NA if -9
  data_1999$V156[data_1999$V156 == -9] <- NA
  
  # V157: set to NA if -9
  data_1999$V157[data_1999$V157 == -9] <- NA
  
  # V163: set to NA if -9
  data_1999$V163[data_1999$V163 == -9] <- NA
  
  # V164: set to NA if -9
  data_1999$V164[data_1999$V164 == -9] <- NA
  
  # V165: set to NA if -9
  data_1999$V165[data_1999$V165 == -9] <- NA
  
  # V166: set to NA if -9
  data_1999$V166[data_1999$V166 == -9] <- NA
  
  # V167: set to NA if -9
  data_1999$V167[data_1999$V167 == -9] <- NA
  
  # V169: set to NA if -9
  data_1999$V169[data_1999$V169 == -9] <- NA
  
  # V170: set to NA if -9
  data_1999$V170[data_1999$V170 == -9] <- NA
  
  # V171: set to NA if -9
  data_1999$V171[data_1999$V171 == -9] <- NA
  
  # V172: set to NA if -9
  data_1999$V172[data_1999$V172 == -9] <- NA
  
  # V173: set to NA if -9
  data_1999$V173[data_1999$V173 == -9] <- NA
  
  # V174: set to NA if -9
  data_1999$V174[data_1999$V174 == -9] <- NA
  
  # V175: set to NA if -9
  data_1999$V175[data_1999$V175 == -9] <- NA
  
  # V176: set to NA if -9
  data_1999$V176[data_1999$V176 == -9] <- NA
  
  # V177: set to NA if -9
  data_1999$V177[data_1999$V177 == -9] <- NA
  
  # V178: set to NA if -9
  data_1999$V178[data_1999$V178 == -9] <- NA
  
  # V179: set to NA if -9
  data_1999$V179[data_1999$V179 == -9] <- NA
  
  # V180: set to NA if -9
  data_1999$V180[data_1999$V180 == -9] <- NA
  
  # V181: set to NA if -9
  data_1999$V181[data_1999$V181 == -9] <- NA
  
  # V182: set to NA if -9
  data_1999$V182[data_1999$V182 == -9] <- NA
  
  # V183: set to NA if -9
  data_1999$V183[data_1999$V183 == -9] <- NA
  
  # V184: set to NA if -9
  data_1999$V184[data_1999$V184 == -9] <- NA
  
  # V185: set to NA if -9
  data_1999$V185[data_1999$V185 == -9] <- NA
  
  # V186: set to NA if -9
  data_1999$V186[data_1999$V186 == -9] <- NA
  
  # V187: set to NA if -9
  data_1999$V187[data_1999$V187 == -9] <- NA
  
  # V188: set to NA if -9
  data_1999$V188[data_1999$V188 == -9] <- NA
  
  # V189: set to NA if -9
  data_1999$V189[data_1999$V189 == -9] <- NA
  
  # V190: set to NA if -9
  data_1999$V190[data_1999$V190 == -9] <- NA
  
  # V191: set to NA if -9
  data_1999$V191[data_1999$V191 == -9] <- NA
  
  # V192: set to NA if -9
  data_1999$V192[data_1999$V192 == -9] <- NA
  
  # V193: set to NA if -9
  data_1999$V193[data_1999$V193 == -9] <- NA
  
  # V194: set to NA if -9
  data_1999$V194[data_1999$V194 == -9] <- NA
  
  # V195: set to NA if -9
  data_1999$V195[data_1999$V195 == -9] <- NA
  
  # V196: set to NA if -9
  data_1999$V196[data_1999$V196 == -9] <- NA
  
  # V197: set to NA if -9
  data_1999$V197[data_1999$V197 == -9] <- NA
  
  # V198: set to NA if -9
  data_1999$V198[data_1999$V198 == -9] <- NA
  
  # V199: set to NA if -9
  data_1999$V199[data_1999$V199 == -9] <- NA
  
  # V200: set to NA if -9
  data_1999$V200[data_1999$V200 == -9] <- NA
  
  # V201: set to NA if -9
  data_1999$V201[data_1999$V201 == -9] <- NA
  
  # V202: set to NA if -9
  data_1999$V202[data_1999$V202 == -9] <- NA
  
  # V203: set to NA if -9
  data_1999$V203[data_1999$V203 == -9] <- NA
  
  # V204: set to NA if -9
  data_1999$V204[data_1999$V204 == -9] <- NA
  
  # V205: set to NA if -9
  data_1999$V205[data_1999$V205 == -9] <- NA
  
  # V206: set to NA if -9
  data_1999$V206[data_1999$V206 == -9] <- NA
  
  # V207: set to NA if -9
  data_1999$V207[data_1999$V207 == -9] <- NA
  
  cat("Missing data recoding completed for 1999 dataset.\n")
  
  # Return the modified dataset
  return(data_1999)
}

# Alternative approach: Direct recoding script (can be sourced directly)
# This section will execute if the script is sourced and data_1999 exists
if (exists("data_1999")) {
  data_1999 <- recode_1999_missing(data_1999)
} 