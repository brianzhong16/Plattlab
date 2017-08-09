# create new column and set value depending on quantiles
for (i in 1:nrow(merged_OXTR_AVPR1)) {
  if (merged_OXTR_AVPR1$'Receive_Approach'[i] == 1) {
    merged_OXTR_AVPR1$'Receive_Approach1'[i] <- "Receive_Approach1"
  }
  else if (merged_OXTR_AVPR1$'Receive_Approach'[i] == 2) {
    merged_OXTR_AVPR1$'Receive_Approach1'[i] <- "Receive_Approach2"
  }
  else {
    merged_OXTR_AVPR1$'Receive_Approach1'[i] <- "Receive_Approach3"
  }
}

# cast data table by year and focal ID  
merged_Receive_Approach <- dcast(merged_OXTR_AVPR1, Year + Focal_ID ~ Receive_Approach1, value.var = "Receive_Approach", fun=sum)
