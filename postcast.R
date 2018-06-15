#extract IDs
id_dat <- unique(all_obs[,.(Focal_ID,Year)])

# merge and calculate age data
id_dat <-  merge(id_dat,pedigree[,c(1, 2, 11)], by = "Focal_ID")
id_dat[,Age:=Year - CS.BIRTH.SEASON]
id_dat[,CS.BIRTH.SEASON:=NULL]
id_dat <- merge(id_dat,dominance[,c("ID","YEAR","ORD_RANK")],by.x=c("Focal_ID","Year"),by.y=c("ID","YEAR"))
id_dat[,ORD_RANK:=ordered(ORD_RANK,levels=c("L","M","H"))]

nc1 <- ncol(all_obs)
# remove animals w/ no dominance rank
all_obs <- merge(all_obs,id_dat)
nc2 <- ncol(all_obs)
all_obs <- all_obs[,c(1:5,(nc2-2):nc2,6:nc1),with=F]
