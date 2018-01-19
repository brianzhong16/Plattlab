# bind all behavioral data across files
all_obs <- do.call(rbind,processed_files)
# I can't believe we have to do this shit
all_obs <- all_obs[!is.na(`Focal_ID`)]
all_obs[Year<2000,Year:=2000 + Year]

# get rid of animals w/ too few obs in a year
obscount <- all_obs[,length(`Observation Name`),by=c("Focal_ID","Year","Group")]
obskeep <- obscount[,.(Focal_ID,V1,V1>(mean(V1)-2*sd(V1))),by=c("Year","Group")][V3==T]
all_obs <- all_obs[all_obs[,paste0(Focal_ID,Year,Group)] %in% obskeep[,paste0(Focal_ID,Year,Group)]]

all_obs <- all_obs[Focal_ID %in% all_genotypes$Focal_ID]
# all_obs$IDyear <- paste(all_obs$Focal_ID, all_obs$Year, all_obs$Observer, sep = "")
# merged_OXTR_AVPR1$IDyear <- paste(merged_OXTR_AVPR1$Focal_ID, merged_OXTR_AVPR1$Year, merged_OXTR_AVPR1$Observer, sep = "")

# loop quantile function for all behaviors
blevels <- list()
for (i in 6:ncol(all_obs)) {
  all_obs[[i]] <- cut(all_obs[[i]],c(0,0.5,quantile(all_obs[[i]][all_obs[[i]]>0],c(0.5,1.0))+0.5) %>% unique(),include.lowest = T)
  blevels[[i-5]] <- levels(all_obs[[i]])
  all_obs[[i]] <- as.numeric(all_obs[[i]])
}

#behavs <- colnames(all_obs)[6:ncol(all_obs)]

#all_obs <- merge(all_obs, oxtr_genotypes, by="Focal_ID")

# convert data frame to data table
#all_obs <- as.data.table(all_obs)

# cast data table by behavior (refer to cast script)

