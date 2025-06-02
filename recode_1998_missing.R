# ===============================================================================
# Script: recode_1998_missing.R
# Purpose: Recode missing data for 1998 dataset
# Author: Generated for vaping2 project
# Date: Created for data cleaning workflow
# ===============================================================================

# Function to recode missing data for 1998 dataset
recode_1998_missing <- function(data_1998) {
  
  cat("Recoding missing data for 1998 dataset...\n")
  
  # V130: set to NA if 0 or 9
  data_1998$V130[data_1998$V130 == 0 | data_1998$V130 == 9] <- NA
  
  # V131: set to NA if 0 or 9
  data_1998$V131[data_1998$V131 == 0 | data_1998$V131 == 9] <- NA
  
  # V132: set to NA if 0 or 9
  data_1998$V132[data_1998$V132 == 0 | data_1998$V132 == 9] <- NA
  
  # V49: set to NA if >= 7
  data_1998$V49[data_1998$V49 >= 7] <- NA
  
  # V101: set to NA if 0 or 9
  data_1998$V101[data_1998$V101 == 0 | data_1998$V101 == 9] <- NA
  
  # V102: set to NA if 0 or 9
  data_1998$V102[data_1998$V102 == 0 | data_1998$V102 == 9] <- NA
  
  # V103: set to NA if 0 or 9
  data_1998$V103[data_1998$V103 == 0 | data_1998$V103 == 9] <- NA
  
  # V104: set to NA if 9
  data_1998$V104[data_1998$V104 == 9] <- NA
  
  # V105: set to NA if 9
  data_1998$V105[data_1998$V105 == 9] <- NA
  
  # V106: set to NA if 9
  data_1998$V106[data_1998$V106 == 9] <- NA
  
  # V107: set to NA if 0 or >= 8
  data_1998$V107[data_1998$V107 == 0 | data_1998$V107 >= 8] <- NA
  
  # V108: set to NA if 0 or >= 8
  data_1998$V108[data_1998$V108 == 0 | data_1998$V108 >= 8] <- NA
  
  # V109: set to NA if 9
  data_1998$V109[data_1998$V109 == 9] <- NA
  
  # V110: set to NA if 9
  data_1998$V110[data_1998$V110 == 9] <- NA
  
  # V111: set to NA if 9
  data_1998$V111[data_1998$V111 == 9] <- NA
  
  # V112: set to NA if 9
  data_1998$V112[data_1998$V112 == 9] <- NA
  
  # V113: set to NA if 9
  data_1998$V113[data_1998$V113 == 9] <- NA
  
  # V114: set to NA if 9
  data_1998$V114[data_1998$V114 == 9] <- NA
  
  # V115: set to NA if 9
  data_1998$V115[data_1998$V115 == 9] <- NA
  
  # V116: set to NA if 9
  data_1998$V116[data_1998$V116 == 9] <- NA
  
  # V117: set to NA if 9
  data_1998$V117[data_1998$V117 == 9] <- NA
  
  # V118: set to NA if 9
  data_1998$V118[data_1998$V118 == 9] <- NA
  
  # V119: set to NA if 9
  data_1998$V119[data_1998$V119 == 9] <- NA
  
  # V120: set to NA if 9
  data_1998$V120[data_1998$V120 == 9] <- NA
  
  # V121: set to NA if 9
  data_1998$V121[data_1998$V121 == 9] <- NA
  
  # V122: set to NA if 9
  data_1998$V122[data_1998$V122 == 9] <- NA
  
  # V123: set to NA if 9
  data_1998$V123[data_1998$V123 == 9] <- NA
  
  # V124: set to NA if 9
  data_1998$V124[data_1998$V124 == 9] <- NA
  
  # V125: set to NA if 9
  data_1998$V125[data_1998$V125 == 9] <- NA
  
  # V126: set to NA if 9
  data_1998$V126[data_1998$V126 == 9] <- NA
  
  # V127: set to NA if 9
  data_1998$V127[data_1998$V127 == 9] <- NA
  
  # V128: set to NA if 9
  data_1998$V128[data_1998$V128 == 9] <- NA
  
  # V129: set to NA if 9
  data_1998$V129[data_1998$V129 == 9] <- NA
  
  # V133: set to NA if 9
  data_1998$V133[data_1998$V133 == 9] <- NA
  
  # V134: set to NA if 9
  data_1998$V134[data_1998$V134 == 9] <- NA
  
  # V135: set to NA if 9
  data_1998$V135[data_1998$V135 == 9] <- NA
  
  # V136: set to NA if 9
  data_1998$V136[data_1998$V136 == 9] <- NA
  
  # V137: set to NA if 9
  data_1998$V137[data_1998$V137 == 9] <- NA
  
  # V138: set to NA if 9
  data_1998$V138[data_1998$V138 == 9] <- NA
  
  # V139: set to NA if 9
  data_1998$V139[data_1998$V139 == 9] <- NA
  
  # V140: set to NA if 9
  data_1998$V140[data_1998$V140 == 9] <- NA
  
  # V141: set to NA if 9
  data_1998$V141[data_1998$V141 == 9] <- NA
  
  # V142: set to NA if 9
  data_1998$V142[data_1998$V142 == 9] <- NA
  
  # V143: set to NA if 9
  data_1998$V143[data_1998$V143 == 9] <- NA
  
  # V144: set to NA if 9
  data_1998$V144[data_1998$V144 == 9] <- NA
  
  # V145: set to NA if 9
  data_1998$V145[data_1998$V145 == 9] <- NA
  
  # V146: set to NA if 9
  data_1998$V146[data_1998$V146 == 9] <- NA
  
  # V147: set to NA if 9
  data_1998$V147[data_1998$V147 == 9] <- NA
  
  # V148: set to NA if 9
  data_1998$V148[data_1998$V148 == 9] <- NA
  
  # V150: set to NA if 0 or 9
  data_1998$V150[data_1998$V150 == 0 | data_1998$V150 == 9] <- NA
  
  # V151: set to NA if 9
  data_1998$V151[data_1998$V151 == 9] <- NA
  
  # V152: set to NA if 0
  data_1998$V152[data_1998$V152 == 0] <- NA
  
  # V153: set to NA if 0 or 9
  data_1998$V153[data_1998$V153 == 0 | data_1998$V153 == 9] <- NA
  
  # V155: set to NA if 9
  data_1998$V155[data_1998$V155 == 9] <- NA
  
  # V156: set to NA if 9
  data_1998$V156[data_1998$V156 == 9] <- NA
  
  # V157: set to NA if 9
  data_1998$V157[data_1998$V157 == 9] <- NA
  
  # V163: set to NA if >= 7
  data_1998$V163[data_1998$V163 >= 7] <- NA
  
  # V164: set to NA if >= 7
  data_1998$V164[data_1998$V164 >= 7] <- NA
  
  # V165: set to NA if 9
  data_1998$V165[data_1998$V165 == 9] <- NA
  
  # V166: set to NA if 0 or >= 8
  data_1998$V166[data_1998$V166 == 0 | data_1998$V166 >= 8] <- NA
  
  # V167: set to NA if 0 or >= 8
  data_1998$V167[data_1998$V167 == 0 | data_1998$V167 >= 8] <- NA
  
  # V169: set to NA if 0 or >= 6
  data_1998$V169[data_1998$V169 == 0 | data_1998$V169 >= 6] <- NA
  
  # V170: set to NA if 0 or >= 6
  data_1998$V170[data_1998$V170 == 0 | data_1998$V170 >= 6] <- NA
  
  # V171: set to NA if 0 or 9
  data_1998$V171[data_1998$V171 == 0 | data_1998$V171 == 9] <- NA
  
  # V172: set to NA if 0 or 9
  data_1998$V172[data_1998$V172 == 0 | data_1998$V172 == 9] <- NA
  
  # V173: set to NA if 0 or 9
  data_1998$V173[data_1998$V173 == 0 | data_1998$V173 == 9] <- NA
  
  # V174: set to NA if 0 or 9
  data_1998$V174[data_1998$V174 == 0 | data_1998$V174 == 9] <- NA
  
  # V175: set to NA if 0 or 9
  data_1998$V175[data_1998$V175 == 0 | data_1998$V175 == 9] <- NA
  
  # V176: set to NA if 0 or 9
  data_1998$V176[data_1998$V176 == 0 | data_1998$V176 == 9] <- NA
  
  # V177: set to NA if 0 or 9
  data_1998$V177[data_1998$V177 == 0 | data_1998$V177 == 9] <- NA
  
  # V178: set to NA if 9
  data_1998$V178[data_1998$V178 == 9] <- NA
  
  # V179: set to NA if 0
  data_1998$V179[data_1998$V179 == 0] <- NA
  
  # V180: set to NA if 0 or 9
  data_1998$V180[data_1998$V180 == 0 | data_1998$V180 == 9] <- NA
  
  # V181: set to NA if 0 or 9
  data_1998$V181[data_1998$V181 == 0 | data_1998$V181 == 9] <- NA
  
  # V182: set to NA if 0 or 9
  data_1998$V182[data_1998$V182 == 0 | data_1998$V182 == 9] <- NA
  
  # V183: set to NA if 0 or 9
  data_1998$V183[data_1998$V183 == 0 | data_1998$V183 == 9] <- NA
  
  # V184: set to NA if 0 or 9
  data_1998$V184[data_1998$V184 == 0 | data_1998$V184 == 9] <- NA
  
  # V185: set to NA if 9
  data_1998$V185[data_1998$V185 == 9] <- NA
  
  # V186: set to NA if 9
  data_1998$V186[data_1998$V186 == 9] <- NA
  
  # V187: set to NA if 9
  data_1998$V187[data_1998$V187 == 9] <- NA
  
  # V188: set to NA if 9
  data_1998$V188[data_1998$V188 == 9] <- NA
  
  # V189: set to NA if 9
  data_1998$V189[data_1998$V189 == 9] <- NA
  
  # V190: set to NA if 9
  data_1998$V190[data_1998$V190 == 9] <- NA
  
  # V191: set to NA if 0 or 9
  data_1998$V191[data_1998$V191 == 0 | data_1998$V191 == 9] <- NA
  
  # V192: set to NA if 0
  data_1998$V192[data_1998$V192 == 0] <- NA
  
  # V193: set to NA if 0
  data_1998$V193[data_1998$V193 == 0] <- NA
  
  # V194: set to NA if 0 or 9
  data_1998$V194[data_1998$V194 == 0 | data_1998$V194 == 9] <- NA
  
  # V195: set to NA if 0 or 9
  data_1998$V195[data_1998$V195 == 0 | data_1998$V195 == 9] <- NA
  
  # V196: set to NA if 0 or 9
  data_1998$V196[data_1998$V196 == 0 | data_1998$V196 == 9] <- NA
  
  # V197: set to NA if >= 7
  data_1998$V197[data_1998$V197 >= 7] <- NA
  
  # V198: set to NA if >= 7
  data_1998$V198[data_1998$V198 >= 7] <- NA
  
  # V199: set to NA if >= 7
  data_1998$V199[data_1998$V199 >= 7] <- NA
  
  # V200: set to NA if >= 7
  data_1998$V200[data_1998$V200 >= 7] <- NA
  
  # V201: set to NA if >= 7
  data_1998$V201[data_1998$V201 >= 7] <- NA
  
  # V202: set to NA if >= 7
  data_1998$V202[data_1998$V202 >= 7] <- NA
  
  # V203: set to NA if >= 7
  data_1998$V203[data_1998$V203 >= 7] <- NA
  
  # V204: set to NA if >= 7
  data_1998$V204[data_1998$V204 >= 7] <- NA
  
  # V205: set to NA if 0 or >= 8
  data_1998$V205[data_1998$V205 == 0 | data_1998$V205 >= 8] <- NA
  
  # V206: set to NA if >= 8
  data_1998$V206[data_1998$V206 >= 8] <- NA
  
  # V207: set to NA if 0 or >= 8
  data_1998$V207[data_1998$V207 == 0 | data_1998$V207 >= 8] <- NA
  
  cat("Missing data recoding completed for 1998 dataset.\n")
  
  # Return the modified dataset
  return(data_1998)
}

# Alternative approach: Direct recoding script (can be sourced directly)
# This section will execute if the script is sourced and data_1998 exists
if (exists("data_1998")) {
  data_1998 <- recode_1998_missing(data_1998)
} 