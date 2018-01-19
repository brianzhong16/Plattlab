# path = "/Users/brianzhong/DropBox/" #brian's path
path <- "~/Dropbox/" #seth's path

pedigree <- read_excel(paste0(path,"Pedigree and Life-History Data/PEDIGREE_updated2016.xlsx"), sheet = "Demographic Data")
pedigree <- as.data.table(pedigree)
pedigree[is.na(DAM),DAM:=`BEHAVIORAL MOM`]

# F_2010 <- read_excel(paste0(behpath,"2014_groupHH_FOCALdata.xlsx"), sheet = "alldata_randomised")
# F_2012_novigilance <- read_excel(paste0(behpath,"2012_GroupF_Masterdatafile.xls", sheet = "behaviours_no vigilance")
# F_2011 <- read_excel(paste0(behpath,"Group F_FOCAL DATA MASTERCOPY_2011.xlsx"), sheet = "DATA")
# S_2011 <- read_excel(paste0(behpath,"Group S FOCAL DATA Sam Larson 2011", sheet = "DATA no Duplicate DAYS")
behpath <- "~/Dropbox/Behavioural Data for Seth/"
HH_2014 <- read_excel(paste0(behpath,"2014_groupHH_FOCALdata.xlsx"), sheet = "2014 HH FOCAL")
KK_2015 <- read_excel(paste0(behpath,"2015_groupKK_FOCALdata.xlsx"), sheet = "grpKK_2015")
V_2015 <- read_excel(paste0(behpath,"2015_GroupV_FOCALdata.xlsx"), sheet = "groupV 2015")
R_2015 <- read_excel(paste0(behpath,"2015.GroupR_focal_MASTERFILE.xlsx"), sheet = "DATA")
V_2016 <- read_excel(paste0(behpath,"2016_GroupV_MASTERFILE.xlsx"), sheet = "Sheet1")
F_2016 <- read_excel(paste0(behpath,"2016.GrpF_Masterfile.xlsx"), sheet = "2016.GrpF_MASTER")
F_2015 <- read_excel(paste0(behpath,"GroupF_2015_FOCALdata.xlsx"), sheet = "behaviours")
#F_2013 <- read_excel(paste0(behpath,"GrpF focal data_2013 MASTERFILE.xls"), sheet = "behaviours")
F_2014 <- read_excel(paste0(behpath,"Masterdatafile2014_ALL_GroupF.xls"), sheet = "behaviours")
#oh my fucking god
F_2014$Direction <- F_2014$`Behavior Modifier`

F_2011 <- fread(paste0(behpath,"GroupF2011_FocalData.txt"))
F_2011 <- F_2011[constrained.duration!="overtime"]
F_2011[,constrained.duration:=as.numeric(constrained.duration)]
F_2011[behaviour=="Agg",Direction:=behaviour.modifers]
F_2011[behaviour=="Approach",Initiator:=behaviour.modifers]
F_2011[behaviour=="Agg" & (grepl(behaviour.modifers,pattern = "\\(threat\\)") | grepl(behaviour.modifers,pattern="noncont")) ,
       behaviour:="noncontactAgg"]
F_2011[behaviour=="Agg" & grepl(behaviour.modifers,pattern="contact"),behaviour:="contactAgg"]

F_2012 <- fread(paste0(behpath,"GroupF2012_FocalData.txt"))
F_2012 <- F_2012[constrained.duration!="overtime"]
F_2012[,constrained.duration:=as.numeric(constrained.duration)]
F_2012[behaviour %in% c("contactAgg","noncontactAgg","threat"),Direction:=behaviour.modifers]
F_2012[behaviour=="Approach",Initiator:=behaviour.modifers]

F_2013 <- fread(paste0(behpath,"GroupF2013_FocalData.txt"))
F_2013 <- F_2013[constrained.duration!="overtime"]
F_2013[,constrained.duration:=as.numeric(constrained.duration)]
F_2013[behaviour %in% c("contactAgg","noncontactAgg","threat"),Direction:=behaviour.modifers]
F_2013[behaviour=="Approach",Initiator:=behaviour.modifers]
F_2013$partner.sex <- pedigree$SEX[match(F_2013[,partner.id],pedigree$Focal_ID)]

F_2015 <- fread(paste0(behpath,"/GroupF2015_FocalData.txt"))
F_2015 <- F_2015[constrained.duration!="overtime"]
F_2015[,constrained.duration:=as.numeric(constrained.duration)]
F_2015[behaviour %in% c("contactAgg","noncontactAgg","threat"),Direction:=behaviour.modifers]
F_2015[behaviour=="Approach",Initiator:=behaviour.modifers]

more_files <- list(F_2011,F_2012,F_2013,F_2015)
more_files <- lapply(more_files,setnames,old = c("focal.id","behaviour","constrained.duration","partner.id","observation.name","year"),
                     new=c("Focal ID","Event Name","Duration_Revised","PartnerID","Observation Name","Year"))
more_files <- lapply(more_files,function(x) x[,focal.sex:=NULL])
more_files <- lapply(more_files,function(x) x[,Group:="F"])




oxtr_genotypes <- read_excel(paste0(behpath,"genotypes.xlsx"), sheet = "OXTR")
avpr1a_genotypes <- read_excel(paste0(behpath,"genotypes.xlsx"), sheet = "AVPR1A")
avpr1b_genotypes <- read_excel(paste0(behpath,"genotypes.xlsx"), sheet = "AVPR1B")
#tph1_genotypes <- read_excel(paste0(behpath,"genotypes.xlsx"), sheet = "TPH1")
#tph2_genotypes <- read_excel(paste0(behpath,"genotypes.xlsx"), sheet = "TPH2")
# dominance data is pending 2016
dominance <- read_excel(paste0(path,"Subjects_attributes, dominance, etc/Dominance Hierarchies/DOMINANCE_ALLSUBJECTS_LONGLIST.xlsx"), sheet = "DOMINANCE_ALLSUBJECTS")


# switch values depending on major/minor alleles
all_genotypes <- Reduce(merge,list(oxtr_genotypes, avpr1a_genotypes, avpr1b_genotypes))
all_genotypes <- as.data.table(all_genotypes)
#all_genotypes <- all_genotypes[-c(8, 22, 29, 31, 36)]
for (i in 2:ncol(all_genotypes)) {
  if (mean(all_genotypes[[i]]) > 1) {
    all_genotypes[[i]][all_genotypes[[i]] == 0] <- 3
    all_genotypes[[i]][all_genotypes[[i]] == 2] <- 4
    all_genotypes[[i]][all_genotypes[[i]] == 3] <- 2
    all_genotypes[[i]][all_genotypes[[i]] == 4] <- 0
  }
}

#cull loci with corrs > 0.9
cormat <- cor(all_genotypes[,-1,with=F])
again <- T
while (again) {
  cull <- c()
  for (i in 1:ncol(cormat)) {
    if (any(abs(cormat[-i,i])>0.9)) { 
      cull <- c(cull,i)
      break
    }
  }
  
  if (length(cull)>0) {
    cormat <- cormat[-cull,-cull]
  } else again <- F
}
all_genotypes <- all_genotypes[,c("Focal_ID",colnames(cormat)),with=F]

all_files <- list(HH_2014, KK_2015, V_2015, R_2015, V_2016, F_2016, F_2014) #dropping F_2013 because of data quality problems #dropping F_2015 because missing PartnerIDs
all_files <- c(all_files,more_files)
all_files <- lapply(all_files,as.data.table)
