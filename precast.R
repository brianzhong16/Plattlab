# bind all behavioral data across files
all_obs <- as.data.frame(Reduce(function(x, y) merge(x, y, all=TRUE), processed_files))
all_obs$Year <- 2000 + all_obs$Year
# all_obs$IDyear <- paste(all_obs$Focal_ID, all_obs$Year, all_obs$Observer, sep = "")
# merged_OXTR_AVPR1$IDyear <- paste(merged_OXTR_AVPR1$Focal_ID, merged_OXTR_AVPR1$Year, merged_OXTR_AVPR1$Observer, sep = "")

# function to compute quantiles and convert to numeric
createbin <- function(column) {
  column <- cut(column,c(0,quantile(column,c(0.025,0.335,0.665,0.975,1.0))+0.5) %>% unique,include.lowest = T)
  column <- as.numeric(column)
}

# loop quantile function for all behaviors
for (i in 6:ncol(all_obs)) {
  all_obs[,i] <- createbin(all_obs[,i])
}

all_obs <- merge(all_obs, oxtr_genotypes, by = "Focal_ID")

# convert data frame to data table
all_obs <- as.data.table(all_obs)

# cast data table by behavior (refer to cast script)

