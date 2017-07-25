# create duration and observation arrays
GroomGET <- array(0, dim = c(50000, 1))
Obs <- array(0, dim = c(50000, 1))

# set first value in observation array to first observation name
Obs[1] <- V_2015$`Observation Name`[1]

# instantiate i and j values
i <- 1
j <- 1

# append values in duration for each reference to GroomGIVE
# print next unique Focal ID in array
for ( i in 2:nrow(V_2015)) {
  if (Obs[j] != V_2015$`Observation Name`[i]) {
    Obs[j + 1] <- V_2015$`Observation Name`[i]
    j <- j + 1
  }
  if (V_2015$`Event Name`[i] == "GroomGET") {
    GroomGET[j] <- GroomGET[j] + V_2015$Duration_Revised[i]
  }
}

# set length of duration array equal to total observations
length(GroomGET) <- j

# bind new array to existing data frame
V_2015_Obs <- cbind(V_2015_GroomGIVE_Obs, GroomGET)
rm(V_2015_GroomGIVE_Obs)
rm(Obs)
rm(GroomGET)

all_obs <- rbind(F_2016_Obs, F_2015_Obs, F_2014_Obs, V_2016_Obs, V_2015_Obs, R_2015_Obs, HH_2014_Obs, KK_2015_Obs)
