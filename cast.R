# create new column and set value depending on quantiles
for (i in 1:nrow(all_obs)) {
  if (all_obs$'GroomGIVE'[i] == 1) {
    all_obs$'GroomGIVE1'[i] <- "GroomGIVE1"
    }
  else if (all_obs$'GroomGIVE'[i] == 2) {
    all_obs$'GroomGIVE1'[i] <- "GroomGIVE2"
    }
  else {
    all_obs$'GroomGIVE1'[i] <- "GroomGIVE3"
    }
  if (all_obs$'GroomGET'[i] == 1) {
    all_obs$'GroomGET1'[i] <- "GroomGET1"
    }
  else if (all_obs$'GroomGET'[i] == 2) {
    all_obs$'GroomGET1'[i] <- "GroomGET2"
    }
  else {
    all_obs$'GroomGET1'[i] <- "GroomGET3"
    }
  if (all_obs$'GroomInf'[i] == 1) {
    all_obs$'GroomInf1'[i] <- "GroomInf1"
    }
  else if (all_obs$'GroomInf'[i] == 2) {
    all_obs$'GroomInf1'[i] <- "GroomInf2"
    }
  else {
    all_obs$'GroomInf1'[i] <- "GroomInf3"
    }
  if (all_obs$'Initiate_Approach'[i] == 1) {
    all_obs$'Initiate_Approach1'[i] <- "Initiate_Approach1"
    }
  else if (all_obs$'Initiate_Approach'[i] == 2) {
    all_obs$'Initiate_Approach1'[i] <- "Initiate_Approach2"
    }
  else {
    all_obs$'Initiate_Approach1'[i] <- "Initiate_Approach3"
    }
  if (all_obs$'Receive_Approach'[i] == 1) {
    all_obs$'Receive_Approach1'[i] <- "Receive_Approach1"
    }
  else if (all_obs$'Receive_Approach'[i] == 2) {
    all_obs$'Receive_Approach1'[i] <- "Receive_Approach2"
    }
  else {
    all_obs$'Receive_Approach1'[i] <- "Receive_Approach3"
    }
  if (all_obs$'Initiate_PassCont'[i] == 1) {
    all_obs$'Initiate_PassCont1'[i] <- "Initiate_PassCont1"
    }
  else if (all_obs$'Initiate_PassCont'[i] == 2) {
    all_obs$'Initiate_PassCont1'[i] <- "Initiate_PassCont2"
    }
  else {
    all_obs$'Initiate_PassCont1'[i] <- "Initiate_PassCont3"
    }
  if (all_obs$'Receive_PassCont'[i] == 1) {
    all_obs$'Receive_PassCont1'[i] <- "Receive_PassCont1"
    }
  else if (all_obs$'Receive_PassCont'[i] == 2) {
    all_obs$'Receive_PassCont1'[i] <- "Receive_PassCont2"
    }
  else {
    all_obs$'Receive_PassCont1'[i] <- "Receive_PassCont3"
    }
  if (all_obs$'Give_contactAgg'[i] == 1) {
    all_obs$'Give_contactAgg1'[i] <- "Give_contactAgg1"
    }
  else if (all_obs$'Give_contactAgg'[i] == 2) {
    all_obs$'Give_contactAgg1'[i] <- "Give_contactAgg2"
    }
  else {
    all_obs$'Give_contactAgg1'[i] <- "Give_contactAgg3"
    }
  if (all_obs$'Receive_contactAgg'[i] == 1) {
    all_obs$'Receive_contactAgg1'[i] <- "Receive_contactAgg1"
    }
  else if (all_obs$'Receive_contactAgg'[i] == 2) {
    all_obs$'Receive_contactAgg1'[i] <- "Receive_contactAgg2"
    }
  else {
    all_obs$'Receive_contactAgg1'[i] <- "Receive_contactAgg3"
    }
  }

cast1 <- dcast(all_obs, Year + Focal_ID + Observer ~ GroomGIVE1, value.var = "GroomGIVE", fun=sum)
cast2 <- dcast(all_obs, Year + Focal_ID + Observer ~ GroomGET1, value.var = "GroomGET", fun=sum)
cast3 <- dcast(all_obs, Year + Focal_ID + Observer ~ GroomInf1, value.var = "GroomInf", fun=sum)
cast4 <- dcast(all_obs, Year + Focal_ID + Observer ~ Initiate_PassCont1, value.var = "Initiate_PassCont", fun=sum)
cast5 <- dcast(all_obs, Year + Focal_ID + Observer ~ Receive_PassCont1, value.var = "Receive_PassCont", fun=sum)
cast6 <- dcast(all_obs, Year + Focal_ID + Observer ~ Give_contactAgg1, value.var = "Give_contactAgg", fun=sum)
cast7 <- dcast(all_obs, Year + Focal_ID + Observer ~ Receive_contactAgg1, value.var = "Receive_contactAgg", fun=sum)
cast8 <- dcast(all_obs, Year + Focal_ID + Observer ~ Initiate_Approach1, value.var = "Initiate_Approach", fun=sum)
cast9 <- dcast(all_obs, Year + Focal_ID + Observer ~ Receive_Approach1, value.var = "Receive_Approach", fun=sum)


