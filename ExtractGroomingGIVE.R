# generate data frame containing Focal ID, Event Name, Duration GroomGIVE
F_2013_GroomGIVE <- F_2013[,c("Focal ID", "Event Name", "Duration_Revised")]

# for all animals, replace durations for which the event is NOT "GroomGIVE" with 0s
for ( i in (nrow(F_2013_GroomGIVE)-1):1) {
  if ( F_2013_GroomGIVE$'Event Name'[i] != "GroomGIVE") {
    F_2013_GroomGIVE$Duration_Revised[i] <- 0
  }
}

# generate data frame of all 0A4 observations
F_2013_0A4 <- F_2013_GroomGIVE[c(F_2013_GroomGIVE$`Focal ID` == "0A4"),]

# delete rows with na values
F_2013_0A4 <- F_2013_0A4[complete.cases(F_2013_0A4),]

# for 0A4, replace durations for which the event is NOT "GroomGIVE" with 0s
for ( i in (nrow(F_2013_0A4)-1):1) {
  if ( F_2013_0A4$'Event Name'[i] != "GroomGIVE") {
    F_2013_0A4$Duration_revised[i] <- 0
  }
}
