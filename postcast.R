# merge all casted data tables
merged_behaviors <- Reduce(merge,casts)

# merge genotype and behavioral data
merged_OXTR_AVPR1 <- merge(merged_behaviors, all_genotypes, by = "Focal_ID")
# rm(merged_behaviors)

# merge and calculate age data
merged_OXTR_AVPR1 <-  merge(merged_OXTR_AVPR1,pedigree[,c(1, 2, 11)], by = "Focal_ID")
merged_OXTR_AVPR1[,Age:=Year - CS.BIRTH.SEASON]
merged_OXTR_AVPR1[,CS.BIRTH.SEASON:=NULL]
merged_OXTR_AVPR1 <- merge(merged_OXTR_AVPR1,dominance[,c("ID","YEAR","ORD_RANK")],by.x=c("Focal_ID","Year"),by.y=c("ID","YEAR"))
merged_OXTR_AVPR1[,ORD_RANK:=ordered(ORD_RANK,levels=c("L","M","H"))]
nc <- ncol(merged_OXTR_AVPR1)
merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(1,(nc-2):nc,2:(nc-3)),with=F]
#merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(1:3, ncol(merged_OXTR_AVPR1), 4:(ncol(merged_OXTR_AVPR1))-1),with=F]

# create new column that combines ID and year
# merged_OXTR_AVPR1$IDyear <- paste(merged_OXTR_AVPR1$Focal_ID, merged_OXTR_AVPR1$Year, sep = "")
# merged_OXTR_AVPR1 <- merged_OXTR_AVPR1[,c(55, 1:54)]

# merge ordinal dominance by IDyear column
# merged_OXTR_AVPR1 <- merge(merged_OXTR_AVPR1, dominance[,c(3, 5, 7)], by = "IDyear")

