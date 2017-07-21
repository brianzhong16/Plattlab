# bind all data frames 
All_obs_GroomGIVE <- rbind(V_2016_GroomGIVE_Obs, V_2015_GroomGIVE_Obs, HH_2014_GroomGIVE_Obs, F_2014_GroomGIVE_Obs, F_2015_GroomGIVE_Obs, F_2016_GroomGIVE_Obs, KK_2015_GroomGIVE_Obs)

All_obs_GroomGIVE$`Focal_ID` <- str_to_upper(All_obs_GroomGIVE$`Focal_ID`)

# cast all observations by Focal ID
# test <- dcast(All_obs_GroomGIVE, GroomGIVE ~ Observation_name)

table <- as.data.table(All_obs_GroomGIVE)
All_obs_ID <- table[,sum(GroomGIVE), by=Focal_ID]
colnames(All_obs_ID) <- c("Focal_ID", "GroomGIVE")
fgo[,.(MeanDur=mean(Duration),VarDur=var(Duration)),by=FocalID]
fgo[,.(MeanDur=mean(Duration)),by=.(FocalID,Observation_name)]
