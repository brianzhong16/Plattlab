# bind all behavioral data across files
all_obs <- rbind(HH_2014_obs, KK_2015_obs, V_2015_obs, V_2016_obs, F_2016_obs, F_2015_obs, F_2014_obs)
all_obs$Year <- 2000 + all_obs$Year
all_obs$IDyear <- paste(all_obs$Focal_ID, all_obs$Year, sep = "")

# merge and calculate age data
merged_OXTR_AVPR1 <-  merge(pedigree[,c(1, 2, 11)], merged_OXTR_AVPR1, by = "Focal_ID")
merged_OXTR_AVPR1$Age <- merged_OXTR_AVPR1$Year - merged_OXTR_AVPR1$`CS BIRTH SEASON`
merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(1:4, 55, 5:54)]

# create new column that combines ID and year
merged_OXTR_AVPR1$IDyear <- paste(merged_OXTR_AVPR1$Focal_ID, merged_OXTR_AVPR1$Year, sep = "")
merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(55, 1:54)]

# merge ordinal dominance by IDyear column
merged_OXTR_AVPR1 <- merge(merged_OXTR_AVPR1, dominance[,c(3, 5, 7)], by = "IDyear")

# merge all casted data tables
merged_behaviors <- Reduce(function(x, y) merge(x, y, all=TRUE), list(cast10, cast11, cast12, cast13, cast14, cast15, cast16, cast17, cast18))

# merge genotype and behavioral data
merged_OXTR <- merge(merged_behaviors, oxtr_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <-  merge(merged_OXTR, avpr1a_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <-  merge(merged_OXTR_AVPR1, avpr1b_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <- merge(merged_OXTR_AVPR1, tph1_genotypes, by = "Focal_ID")
rm(merged_OXTR)

# function to compute quantiles and convert to numeric
q <- function(column) {
  column <- cut(column,c(0,quantile(column,c(0.025,0.335,0.665,0.975,1.0))+0.5) %>% unique,include.lowest = T)
  column <- as.numeric(column)
}

# loop quantile function for all behaviors
for (i in 5:17) {
  all_obs[,i] <- q(all_obs[,i])
}

# convert data frame to data table
library(data.table)
all_obs <- as.data.table(all_obs)
