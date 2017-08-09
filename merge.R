# bind all behavioral data across files
all_obs <- rbind(HH_2014_obs, KK_2015_obs, V_2015_obs, V_2016_obs, F_2016_obs, F_2015_obs, F_2014_obs)
all_obs$Year <- 2000 + all_obs$Year

# merge and calculate age data
all_obs <-  merge(all_obs, pedigree[,c(1, 11)], by = "Focal_ID")
all_obs$Age <- all_obs$Year - all_obs$`CS BIRTH SEASON`

# create new column that combines ID and year
all_obs$IDyear <- paste(all_obs$Focal_ID, all_obs$Year, sep = "")

# merge ordinal dominance by IDyear column
all_obs <- merge(all_obs, dominance[,c(3, 5, 7)], by = "IDyear")

# merge genotype and behavioral data
merged_OXTR <- merge(all_obs, oxtr_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <-  merge(merged_OXTR, avpr1a_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <-  merge(merged_OXTR_AVPR1, avpr1b_genotypes, by = "Focal_ID")
rm(merged_OXTR)

# function to compute quantiles and convert to numeric
q <- function(column) {
  column <- cut(column,c(0,quantile(column,c(0.025,0.335,0.665,0.975,1.0))+0.5) %>% unique,include.lowest = T)
  column <- as.numeric(column)
}

# loop quantile function for all behaviors
for (i in 5:17) {
  merged_OXTR_AVPR1[,i] <- q(merged_OXTR_AVPR1[,i])
}

# convert data frame to data table
merged_OXTR_AVPR1 <- as.data.table(merged_OXTR_AVPR1)

# create new column and set value depending on quantiles
for (i in 1:nrow(merged_OXTR_AVPR1)) {
  if (merged_OXTR_AVPR1$'GroomGET'[i] == 1) {
    merged_OXTR_AVPR1$'GroomGET1'[i] <- "GroomGET1"
  }
  else if (merged_OXTR_AVPR1$'GroomGET'[i] == 2) {
    merged_OXTR_AVPR1$'GroomGET1'[i] <- "GroomGET2"
  }
  else {
    merged_OXTR_AVPR1$'GroomGET1'[i] <- "GroomGET3"
  }
}

# cast data table by year and focal ID  
merged_GroomGET <- dcast(merged_OXTR_AVPR1, Year + Focal_ID ~ GroomGET1, value.var = "GroomGET", fun=sum)


