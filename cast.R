# create new column and set value depending on quantiles
for (i in 1:nrow(all_obs)) {
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

# cast data table by year and focal ID  
cast18 <- dcast(all_obs, Year + Focal_ID + Observer ~ Receive_contactAgg1, value.var = "Receive_contactAgg", fun=sum)
alarm()
# add observer to cast function to account for different observers