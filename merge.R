# bind all behavioral data across files
merged_OXTR_AVPR1 <- rbind(HH_2014_obs, KK_2015_obs, V_2015_obs, V_2016_obs, F_2016_obs, F_2015_obs, F_2014_obs)
merged_OXTR_AVPR1$Year <- 2000 + merged_OXTR_AVPR1$Year

# merge and calculate age data
merged_OXTR_AVPR1 <-  merge(pedigree[,c(1, 2, 11)], merged_OXTR_AVPR1, by = "Focal_ID")
merged_OXTR_AVPR1$Age <- merged_OXTR_AVPR1$Year - merged_OXTR_AVPR1$`CS BIRTH SEASON`
merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(1, 2, 52, 3:51)]

# create new column that combines ID and year
merged_OXTR_AVPR1$IDyear <- paste(merged_OXTR_AVPR1$Focal_ID, merged_OXTR_AVPR1$Year, sep = "")
merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(1:4, 53, 5:52)]

# merge ordinal dominance by IDyear column
merged_OXTR_AVPR1 <- merge(merged_OXTR_AVPR1, dominance[,c(3, 5, 7)], by = "IDyear")

# merge all casted data tables
merged_behaviors <- Reduce(function(x, y) merge(x, y, all=TRUE), list(cast1, cast2, cast3, cast4, cast5, cast6, cast7, cast8, cast9))

# merge genotype and behavioral data
merged_OXTR <- merge(merged_behaviors, oxtr_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <-  merge(merged_OXTR, avpr1a_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <-  merge(merged_OXTR_AVPR1, avpr1b_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <- merge(merged_OXTR_AVPR1, tph1_genotypes, by = "Focal_ID")
rm(merged_OXTR)

# function to compute quantiles and convert to numeric
# q <- function(column) {
#   column <- cut(column,c(0,quantile(column,c(0.025,0.335,0.665,0.975,1.0))+0.5) %>% unique,include.lowest = T)
#   column <- as.numeric(column)
# }

# loop quantile function for all behaviors
for (i in 4:16) {
  merged_OXTR_AVPR1[,i] <- q(merged_OXTR_AVPR1[,i])
}

# convert data frame to data table
merged_OXTR_AVPR1 <- as.data.table(merged_OXTR_AVPR1)
