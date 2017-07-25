# check for lowercase in focal ID column
# for (i in (1:nrow(KK_2015))) {
#  if (grepl("[[:lower:]|[:digit:]][[:lower:]|[:digit:]][[:lower:]|[:digit:]]", KK_2015$`Focal ID`[i], ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE) == TRUE) {
#   # print(KK_2015$`Focal ID`[i])
#    gsub("[[:lower:]|[:digit:]][[:lower:]|[:digit:]][[:lower:]|[:digit:]]", "[[:upper:]|[:digit:]][[:upper:]|[:digit:]][[:upper:]|[:digit:]]", KK_2015$`Focal ID`[i], ignore.case = FALSE, perl = TRUE, fixed = FALSE, useBytes = FALSE)
#  }
# }

# KK_2015$`Focal ID` <- gsub("[[:lower:]|[:digit:]][[:lower:]|[:digit:]][[:lower:]|[:digit:]]", "[[:upper:]|[:digit:]][[:upper:]|[:digit:]][[:upper:]|[:digit:]]", KK_2015$`Focal ID`, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)

# KK_2015$Month <- grepl([[:lower:]|[:digit:]][[:lower:]|[:digit:]][[:lower:]|[:digit:]], KK_2015$`Focal ID`[1], ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE) == FALSE

# KK_2015$`Focal ID` <- gsub("00V", "00v", KK_2015$`Focal ID`, ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE)

# convert lowercase focal IDs and observation names to uppercase
KK_2015$`Observation Name` <- str_to_upper(KK_2015$`Observation Name`)
KK_2015$`Focal ID` <- str_to_upper(KK_2015$`Focal ID`)

# KK_2015_Obs$`Focal_ID` <- str_to_upper(KK_2015_Obs$`Focal_ID`)

# eliminate rows where observation name is missing
KK_2015 <- KK_2015[!is.na(KK_2015$`Observation Name`),]

# create empty arrays of observations, focal IDs, and durations
Obs <- array(0, dim = c(50000, 1))
Duration <- array(0, dim = c(50000, 1))
Focal_ID <- array(0, dim = c(50000, 1))

# set the first value in the Obs and Focal ID arrays to the first value in the data frame
Obs[1] <- KK_2015$`Observation Name`[1]
Focal_ID[1] <- KK_2015$`Focal ID`[1]

# instantiate i and j values
i <- 1
j <- 1

# append values in duration for each reference to GroomGIVE
# print next unique Focal ID in array
for ( i in 2:nrow(KK_2015)) {
  if (Obs[j] != KK_2015$`Observation Name`[i]) {
    Obs[j + 1] <- KK_2015$`Observation Name`[i]
    Focal_ID[j + 1] <- KK_2015$`Focal ID`[i]
    j <- j + 1
  }
  if (KK_2015$`Event Name`[i] == "GroomGIVE") {
    Duration[j] <- Duration[j] + KK_2015$Duration_Revised[i]
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
KK_2015_GroomGIVE_Obs <- data.frame(Focal_ID, Year, Observation_name, GroomGIVE)

# create duration and observation arrays
GroomGET <- array(0, dim = c(50000, 1))
Obs <- array(0, dim = c(50000, 1))

# set first value in observation array to first observation name
Obs[1] <- KK_2015$`Observation Name`[1]

# instantiate i and j values
i <- 1
j <- 1

# append values in duration for each reference to GroomGIVE
# print next unique Focal ID in array
for ( i in 2:nrow(KK_2015)) {
  if (Obs[j] != KK_2015$`Observation Name`[i]) {
    Obs[j + 1] <- KK_2015$`Observation Name`[i]
    j <- j + 1
  }
  if (KK_2015$`Event Name`[i] == "GroomGET") {
    GroomGET[j] <- GroomGET[j] + KK_2015$Duration_Revised[i]
  }
}

# set length of duration array equal to total observations
length(GroomGET) <- j

# bind new array to existing data frame
KK_2015_Obs <- cbind(KK_2015_GroomGIVE_Obs, GroomGET)
rm(KK_2015_GroomGIVE_Obs)
rm(Obs)
rm(GroomGET)

# all_obs <- rbind(KK_2015_Obs, F_2015_Obs, KK_2015_Obs)


# all_obs <- cbind(KK_2015_GroomGIVE_Obs, KK_2015_GroomGIVE_Obs, KK_2015_Obs)