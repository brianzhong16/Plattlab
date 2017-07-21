# create duration and observation arrays
GroomGET <- array(0, dim = c(50000, 1))
Obs <- array(0, dim = c(50000, 1))

# set first value in observation array to first observation name
Obs[1] <- R_2015$`Observation Name`[1]

# instantiate i and j values
i <- 1
j <- 1

# append values in duration for each reference to GroomGIVE
# print next unique Focal ID in array
for ( i in 2:nrow(R_2015)) {
  if (Obs[j] != R_2015$`Observation Name`[i]) {
    Obs[j + 1] <- R_2015$`Observation Name`[i]
    j <- j + 1
  }
  if (R_2015$`Event Name`[i] == "GroomGET") {
    GroomGET[j] <- GroomGET[j] + R_2015$Duration_Revised[i]
  }
}

# set length of duration array equal to total observations
length(GroomGET) <- j

# bind new array to existing data frame
R_2015_Obs <- cbind(R_2015_GroomGIVE_Obs, GroomGET)
rm(R_2015_GroomGIVE_Obs)
rm(Obs)
