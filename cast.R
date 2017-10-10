# create new column and set value depending on quantiles
behavs <- colnames(all_obs)[c(6:20)]
casts <- list()
for (i in 1:length(behavs)) {
  casts[[i]] <- dcast(all_obs, as.formula(paste0("Year + Focal_ID + Observer + Group ~ ",behavs[i])), value.var = behavs[i], fun=length)
  colnames(casts[[i]])[5:ncol(casts[[i]])] <- paste0(behavs[i],1:(ncol(casts[[i]])-3))
}
