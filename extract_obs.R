ext <- function(file) {
  
  library(stringr)
  
  # convert Focal IDs and observation names to uppercase
  file$`Observation Name` <- str_to_upper(file$`Observation Name`)
  file$`Focal ID` <- str_to_upper(file$`Focal ID`)
  file$`Observer` <- str_to_upper(file$`Observer`)
  file$`PartnerID` <- str_to_upper(file$`PartnerID`)
  
  # eliminate rows where observation name is missing
  file <- file[!is.na(file$`Observation Name`),]
  
  # eliminate rows where partner ID is not an adult primate
  file <- file[ ! file$'PartnerID' %in% c("Infant", "Juvenile", "Mistake" ,"Unknown", "Human"), ]
  
  # convert all duration values to numeric
  file$'Duration_Revised' <- as.numeric(file$'Duration_Revised')
  
  # order file by observation name
  file <- file[order(file$`Observation Name`),]
  
  # create empty arrays of observations, focal IDs, and durations
  Obs <- array(0, dim = c(50000, 1))
  Focal_ID <- array(0, dim = c(50000, 1))
  Observer  <- array(0, dim = c(50000, 1))
  Group <- array(0, dim = c(50000, 1))
  GroomGIVE <- array(0, dim = c(50000, 1))
  GroomGET <- array(0, dim = c(50000, 1))
  Initiate_Approach <- array(0, dim = c(50000, 1))
  Receive_Approach <- array(0, dim = c(50000, 1))
  Unknown_Approach <- array(0, dim = c(50000, 1))
  Displacement_Approach <- array(0, dim = c(50000, 1))
  Initiate_PassCont <- array(0, dim = c(50000, 1))
  Receive_PassCont <- array(0, dim = c(50000, 1))
  Unknown_PassCont <- array(0, dim = c(50000, 1))
  Displacement_PassCont <- array(0, dim = c(50000, 1))
  Give_contactAgg <- array(0, dim = c(50000, 1))
  Receive_contactAgg <- array(0, dim = c(50000, 1))
  GroomInf <- array(0, dim = c(50000, 1))
  
  # set the first value in the Obs and Focal ID arrays to the first value in the data frame
  Obs[1] <- file$`Observation Name`[1]
  Focal_ID[1] <- file$`Focal ID`[1]
  Observer[1] <- file$'Observer'[1]
  
  # instantiate j and k values
  j <- 1
  k <- 1
  
  # append values in respective arrays for each reference to each behavior
  # add next unique observation in array

  for ( j in 2:nrow(file)) {
    if (Obs[k] != file$`Observation Name`[j]) {
      Obs[k + 1] <- file$`Observation Name`[j]
      Focal_ID[k + 1] <- file$`Focal ID`[j]
      Observer[k + 1] <- file$'Observer'[j]
      k <- k + 1
    }
    if (file$`Event Name`[j] == "GroomGIVE") {
      GroomGIVE[k] <- GroomGIVE[k] + file$Duration_Revised[j]
    }
    if (file$`Event Name`[j] == "GroomGET") {
      GroomGET[k] <- GroomGET[k] + file$Duration_Revised[j]
    }
    if (file$`Event Name`[j] == "GromInf") {
      GroomInf[k] <- GroomInf[k] + file$Duration_Revised[j]
    }
    if (file$`Event Name`[j] == "Approach") {
      if (grepl("Focal", file$`Initiator`[j], ignore.case = TRUE)) {
      Initiate_Approach[k] <- Initiate_Approach[k] + 1
      }
      else if (grepl("Partner", file$`Initiator`[j], ignore.case = TRUE)) {
        Receive_Approach[k] <- Receive_Approach[k] + 1
      }
      else if (grepl("Unknown", file$`Initiator`[j], ignore.case = TRUE)) {
        Unknown_Approach[k] <- Unknown_Approach[k] + 1
      }
      else if (grepl("Displac", file$`Initiator`[j], ignore.case = TRUE)) {
        Displacement_Approach[k] <- Displacement_Approach[k] + 1
      }
    }
    if (file$`Event Name`[j] == "passcont") {
      if (grepl("Focal", file$`Initiator`[j], ignore.case = TRUE)) {
        Initiate_PassCont[k] <- Initiate_PassCont[k] + 1
      }
      else if (grepl("Partner", file$`Initiator`[j], ignore.case = TRUE)) {
        Receive_PassCont[k] <- Receive_PassCont[k] + 1
      }
      else if (grepl("Unknown", file$`Initiator`[j], ignore.case = TRUE)) {
        Unknown_PassCont[k] <- Unknown_PassCont[k] + 1
      }
      else if (grepl("Displac", file$`Initiator`[j], ignore.case = TRUE)) {
        Displacement_PassCont[k] <- Displacement_PassCont[k] + 1
      }
    }
    if (file$`Event Name`[j] == "contactAgg") {
      if (grepl("give", file$`Direction`[j], ignore.case = TRUE)) {
        Give_contactAgg[k] <- Give_contactAgg[k] + 1
      }
      else if (grepl("receive", file$`Direction`[j], ignore.case = TRUE)) {
        Receive_contactAgg[k] <- Receive_contactAgg[k] + 1
      }
    }
  }
  
  # set length of arrays to number of unique observations
  length(Obs) <- k
  length(Observer) <- k
  length(GroomGIVE) <- k
  length(GroomGET) <- k
  length(GroomInf) <- k
  length(Initiate_Approach) <- k
  length(Receive_Approach) <- k
  length(Unknown_Approach) <- k
  length(Displacement_Approach) <- k
  length(Initiate_PassCont) <- k
  length(Receive_PassCont) <- k
  length(Unknown_PassCont) <- k
  length(Displacement_PassCont) <- k
  length(Give_contactAgg) <- k
  length(Receive_contactAgg) <- k
  length(Focal_ID) <- k
  
  # rename the Obs vector to Observation_name
  Observation_name <- Obs
  
  # create a vector of years and groups
  Year <- rep(c(file$Year[1]), times = k)
  
  if ("Group" %in% colnames(file) == TRUE) {
    Group <- rep(c(file$Group[1]), times = k)
  }
  
  # create a data frame that combines all three vectors
  if ("Group" %in% colnames(file) == TRUE) {
    observation <- data.frame(Focal_ID, Year, Observer, Group, Observation_name, GroomGIVE, GroomGET, GroomInf, Initiate_Approach, Receive_Approach, Unknown_Approach, Displacement_Approach, Initiate_PassCont, Receive_PassCont, Unknown_PassCont, Displacement_PassCont, Give_contactAgg, Receive_contactAgg)
  }
  else {
    observation <- data.frame(Focal_ID, Year, Observer, Observation_name, GroomGIVE, GroomGET, GroomInf, Initiate_Approach, Receive_Approach, Unknown_Approach, Displacement_Approach, Initiate_PassCont, Receive_PassCont, Unknown_PassCont, Displacement_PassCont, Give_contactAgg, Receive_contactAgg)
  }


  # delete all arrays
  rm(Focal_ID, Year, Observation_name, Observer, Group, GroomGIVE, GroomGET, GroomInf, Initiate_Approach, Receive_Approach, Unknown_Approach, Displacement_Approach, Initiate_PassCont, Receive_PassCont, Unknown_PassCont, Displacement_PassCont, Give_contactAgg, Receive_contactAgg)

  return(observation)
}

processed_files <- list()

for (i in 1:length(all_files)) {
  processed_files[[i]] = ext(all_files[[i]])
}
