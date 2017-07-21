# convert lowercase IDs to uppercase
F_2015$`Focal ID` <- str_to_upper(F_2015$`Focal ID`)

# eliminate rows where observation name is missing
F_2015 <- F_2015[!is.na(F_2015$`Observation Name`),]

# create an array of Focal IDs and durations
Focal_ID <- array(0, dim = c(50000, 1))
Duration <- array(0, dim = c(50000, 1))

# set the first value in the Focal ID array to the first value in the data frame
Focal_ID[1] <- F_2015$`Focal ID`[1]

# instantiate i and j values
i <- 1
j <- 1

# append values in duration for each reference to GroomGIVE
# print next unique Focal ID in array
for ( i in 1:nrow(F_2015)) {
  if (Focal_ID[j] != F_2015$`Focal ID`[i]) {
    Focal_ID[j + 1] <- F_2015$`Focal ID`[i]
    j <- j + 1
  }
  if (F_2015$`Event Name`[i] == "GroomGIVE") {
    Duration[j] <- Duration[j] + F_2015$Duration_Revised[i]
  }
}

# set length of arrays to number of unique Focal IDs
length(Focal_ID) <- j
length(Duration) <- j

# create a vector of Event names
Event_name <- rep(c("GroomGIVE"), times = j)

# create a data frame that combines all three vectors
F_2015_GroomGIVE_FocalID <- data.frame(Event_name, Focal_ID, Duration)

