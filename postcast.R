# merge all casted data tables
merged_behaviors <- Reduce(function(x, y) merge(x, y, all=TRUE), list(cast1, cast2, cast3, cast4, cast5, cast6, cast7, cast8, cast9))

# merge genotype and behavioral data
merged_OXTR <- merge(merged_behaviors, oxtr_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <-  merge(merged_OXTR, avpr1a_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <-  merge(merged_OXTR_AVPR1, avpr1b_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <- merge(merged_OXTR_AVPR1, tph1_genotypes, by = "Focal_ID")
merged_OXTR_AVPR1 <- merge(merged_OXTR_AVPR1, tph2_genotypes, by = "Focal_ID")
rm(merged_OXTR)
rm(merged_behaviors)

# merge and calculate age data
merged_OXTR_AVPR1 <-  merge(pedigree[,c(1, 2, 11)], merged_OXTR_AVPR1, by = "Focal_ID")
merged_OXTR_AVPR1$Age <- merged_OXTR_AVPR1$Year - merged_OXTR_AVPR1$`CS BIRTH SEASON`
merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(1:3, 59, 4:58)]

# create new column that combines ID and year
# merged_OXTR_AVPR1$IDyear <- paste(merged_OXTR_AVPR1$Focal_ID, merged_OXTR_AVPR1$Year, sep = "")
# merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(55, 1:54)]

# merge ordinal dominance by IDyear column
# merged_OXTR_AVPR1 <- merge(merged_OXTR_AVPR1, dominance[,c(3, 5, 7)], by = "IDyear")

