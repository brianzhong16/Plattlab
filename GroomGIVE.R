F_2016 <- F_2016[!is.na(F_2016$`Observation name`),]

Obs <- array(0, dim = c(50000, 1))

Duration <- array(0, dim = c(50000, 1))

Obs[1] <- F_2016$`Observation name`[1]

i <- 1
j <- 1
for ( i in 1:nrow(F_2016)) {
  if (F_2016$`Event Name`[i] == "GroomGIVE") {
    Duration[j] <- Duration[j] + F_2016$Duration_revised[i]
  }
  if (Obs[j] != F_2016$`Observation name`[i]) {
    Obs[j + 1] <- F_2016$`Observation name`[i]
    j <- j + 1
  }
}

length(Obs) <- j
length(Duration) <- j
Observation_name <- Obs

Event_name <- rep(c("GroomGIVE"), times = j)
F_2016_GroomGIVE_Obs <- data.frame(Event_name, Observation_name, Duration)