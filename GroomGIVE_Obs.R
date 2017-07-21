# check for lowercase in focal ID column
# for (i in (1:nrow(R_2015))) {
#  if (grepl("[[:lower:]|[:digit:]][[:lower:]|[:digit:]][[:lower:]|[:digit:]]", R_2015$`Focal ID`[i], ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE) == TRUE) {
#   # print(R_2015$`Focal ID`[i])
#    gsub("[[:lower:]|[:digit:]][[:lower:]|[:digit:]][[:lower:]|[:digit:]]", "[[:upper:]|[:digit:]][[:upper:]|[:digit:]][[:upper:]|[:digit:]]", R_2015$`Focal ID`[i], ignore.case = FALSE, perl = TRUE, fixed = FALSE, useBytes = FALSE)
#  }
# }

# R_2015$`Focal ID` <- gsub("[[:lower:]|[:digit:]][[:lower:]|[:digit:]][[:lower:]|[:digit:]]", "[[:upper:]|[:digit:]][[:upper:]|[:digit:]][[:upper:]|[:digit:]]", R_2015$`Focal ID`, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)

# R_2015$Month <- grepl([[:lower:]|[:digit:]][[:lower:]|[:digit:]][[:lower:]|[:digit:]], R_2015$`Focal ID`[1], ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE) == FALSE

# R_2015$`Focal ID` <- gsub("00V", "00v", R_2015$`Focal ID`, ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE)

# convert lowercase focal IDs and observation names to uppercase
R_2015$`Observation Name` <- str_to_upper(R_2015$`Observation Name`)
R_2015$`Focal_ID` <- str_to_upper(R_2015$`Focal_ID`)

# R_2015_Obs$`Focal_ID` <- str_to_upper(R_2015_Obs$`Focal_ID`)

# eliminate rows where observation name is missing
R_2015 <- R_2015[!is.na(R_2015$`Observation Name`),]

# create empty arrays of observations, focal IDs, and durations
Obs <- array(0, dim = c(50000, 1))
Duration <- array(0, dim = c(50000, 1))
Focal_ID <- array(0, dim = c(50000, 1))

# set the first value in the Obs and Focal ID arrays to the first value in the data frame
Obs[1] <- R_2015$`Observation Name`[1]
Focal_ID[1] <- R_2015$`Focal ID`[1]

# instantiate i and j values
i <- 1
j <- 1

# append values in duration for each reference to GroomGIVE
# print next unique Focal ID in array
for ( i in 2:nrow(R_2015)) {
  if (Obs[j] != R_2015$`Observation Name`[i]) {
    Obs[j + 1] <- R_2015$`Observation Name`[i]
    Focal_ID[j + 1] <- R_2015$`Focal ID`[i]
    j <- j + 1
  }
  if (R_2015$`Event Name`[i] == "GroomGIVE") {
    Duration[j] <- Duration[j] + R_2015$Duration_Revised[i]
  }
}

# set length of arrays to number of unique Focal IDs
length(Obs) <- j
length(Duration) <- j
length(Focal_ID) <- j

# rename the Obs vector to Observation_name
Observation_name <- Obs
GroomGIVE <- Duration

# create a vector of years
Year <- rep(c("2015"), times = j)

# create a data frame that combines all three vectors
R_2015_GroomGIVE_Obs <- data.frame(Focal_ID, Year, Observation_name, GroomGIVE)