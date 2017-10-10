# merge all casted data tables
merged_behaviors <- Reduce(merge,casts)

# switch values depending on major/minor alleles
all_genotypes <- cbind(oxtr_genotypes, avpr1a_genotypes, avpr1b_genotypes, tph1_genotypes, tph2_genotypes, by = "Focal_ID")
all_genotypes <- all_genotypes[-c(8, 22, 29, 31, 36)]
for (i in 2:ncol(all_genotypes)) {
  if (mean(all_genotypes[[i]]) > 1) {
    all_genotypes[[i]][all_genotypes[[i]] == 0] <- 3
    all_genotypes[[i]][all_genotypes[[i]] == 2] <- 4
    all_genotypes[[i]][all_genotypes[[i]] == 3] <- 2
    all_genotypes[[i]][all_genotypes[[i]] == 4] <- 0
  }
}

# merge genotype and behavioral data
merged_OXTR_AVPR1 <- merge(merged_behaviors, all_genotypes, by = "Focal_ID")
# rm(merged_behaviors)

# merge and calculate age data
merged_OXTR_AVPR1 <-  merge(pedigree[,c(1, 2, 11)], merged_OXTR_AVPR1, by = "Focal_ID")
merged_OXTR_AVPR1[,Age:=Year - CS.BIRTH.SEASON]
merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(1:3, ncol(merged_OXTR_AVPR1), 4:(ncol(merged_OXTR_AVPR1))-1),with=F]

# create new column that combines ID and year
# merged_OXTR_AVPR1$IDyear <- paste(merged_OXTR_AVPR1$Focal_ID, merged_OXTR_AVPR1$Year, sep = "")
# merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(55, 1:54)]

# merge ordinal dominance by IDyear column
# merged_OXTR_AVPR1 <- merge(merged_OXTR_AVPR1, dominance[,c(3, 5, 7)], by = "IDyear")

