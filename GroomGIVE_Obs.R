# all_files <- c(HH_2014, KK_2015, V_2015, R_2015, V_2016, F_2016, F_2015, F_2013, F_2014)

# for (i in all_files) {
#  all_files[i] <- x(all_files[i])
# }

F_2016_obs <- x(F_2016)

x <- function(file) {
  
  # convert Focal IDs and observation names to uppercase
  file$`Observation Name` <- str_to_upper(file$`Observation Name`)
  file$`Focal ID` <- str_to_upper(file$`Focal ID`)
  
  # eliminate rows where observation name is missing
  file <- file[!is.na(file$`Observation Name`),]
  
  # create empty arrays of observations, focal IDs, and durations
  Obs <- array(0, dim = c(50000, 1))
  Focal_ID <- array(0, dim = c(50000, 1))
  GroomGIVE <- array(0, dim = c(50000, 1))
  GroomGET <- array(0, dim = c(50000, 1))
  Initiate_Approach <- array(0, dim = c(50000, 1))
  Receive_Approach <- array(0, dim = c(50000, 1))
  
  # set the first value in the Obs and Focal ID arrays to the first value in the data frame
  Obs[1] <- file$`Observation Name`[1]
  Focal_ID[1] <- file$`Focal ID`[1]
  
  # instantiate i and j values
  i <- 1
  j <- 1
  
  # append values in respective arrays for each reference to GroomGIVE, GroomGET, Approach
  # add next unique observation in array
  for ( i in 2:nrow(file)) {
    if (Obs[j] != file$`Observation Name`[i]) {
      Obs[j + 1] <- file$`Observation Name`[i]
      Focal_ID[j + 1] <- file$`Focal ID`[i]
      j <- j + 1
    }
    if (file$`Event Name`[i] == "GroomGIVE") {
      GroomGIVE[j] <- GroomGIVE[j] + file$Duration_Revised[i]
    }
    if (file$`Event Name`[i] == "GroomGET") {
      GroomGET[j] <- GroomGET[j] + file$Duration_Revised[i]
    }
    if (file$`Event Name`[i] == "Approach") {
      if (file$'Behavior Modifier 1'[i] == "initiate (focal)") {
      Initiate_Approach[j] <- Initiate_Approach[j] + 1
      }
      else if (file$'Behavior Modifier 1'[i] == "initiate (partner)") {
        Receive_Approach[j] <- Receive_Approach[j] + 1
      }
    }
  }
  
  # set length of arrays to number of unique Focal IDs
  length(Obs) <- j
  length(GroomGIVE) <- j
  length(GroomGET) <- j
  length(Initiate_Approach) <- j
  length(Receive_Approach) <- j
  length(Focal_ID) <- j
  
  # rename the Obs vector to Observation_name
  Observation_name <- Obs
  
  # create a vector of years
  Year <- rep(c(file$Year[1]), times = j)
  
  # create a data frame that combines all three vectors
  observation <- data.frame(Focal_ID, Year, Observation_name, GroomGIVE, GroomGET, Initiate_Approach, Receive_Approach)
  return(observation)
}

# all_obs <- cbind(KK_2015_GroomGIVE_Obs, KK_2015_GroomGIVE_Obs, KK_2015_Obs)