# create new column and set value depending on quantiles
casts <- list()
for (i in 1:length(behaviors)) {
  casts[[i]] <- dcast(all_obs, as.formula(paste0("Year + `Focal_ID` + Observer + Group ~ ",behaviors[i])), value.var = behaviors[i], fun=length)
  colnames(casts[[i]])[5:ncol(casts[[i]])] <- paste0(behaviors[i],1:(ncol(casts[[i]])-4))
}
