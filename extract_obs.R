ext <- function(file) {
  
  library(stringr)
  
  # convert Focal IDs and observation names to uppercase
  file$`Observation Name` <- str_to_upper(file$`Observation Name`)
  file$`Focal ID` <- str_to_upper(file$`Focal ID`)
  file$`Observer` <- str_to_upper(file$`Observer`)
  file$`PartnerID` <- str_to_upper(file$`PartnerID`)
  colnames(file)[colnames(file)=="Focal ID"] <- "Focal_ID"
  
  # eliminate rows where observation name is missing
  file <- file[!is.na(file$`Observation Name`),]
  
  # eliminate rows where partner ID is not an adult primate (or empty)
  file <- file[ ! file$'PartnerID' %in% c("INFANT", "JUVENILE", "MISTAKE" ,"UNKNOWN", "HUMAN","JUVENIL","JUVENILLE","?","#N/A")]
  
  if (ff) {
    file <- file[Focal_ID %in% pedigree[SEX=="f",Focal_ID]]
    partsex <- file[,(str_detect(colnames(file) %>% tolower(),pattern = "partner") & 
                        str_detect(colnames(file) %>% tolower(),pattern = "sex$")),with=F][[1]]
    file <- file[str_detect(tolower(partsex),"^f") | is.na(partsex)]
  }
  
  # convert all duration values to numeric
  file$'Duration_Revised' <- as.numeric(file$'Duration_Revised')
  
  # order file by observation name
  file <- file[order(file$`Observation Name`),]
  
  ##### Grooming
  out <- file[,.(GroomGIVE=sum(Duration_Revised[`Event Name`=="GroomGIVE"])),by=.(`Observation Name`,`Focal_ID`,`Observer`)]
  out <- merge(out,file[,.(GroomGET=sum(Duration_Revised[`Event Name`=="GroomGET"])),by=`Observation Name`])
  #out <- merge(out,file[,.(GroomInf=sum(Duration_Revised[`Event Name`=="GromInf"])),by=`Observation Name`])
  out <- merge(out,file[,.(PassCont=sum(Duration_Revised[`Event Name`=="passcont"])),by=`Observation Name`])
  
  spliton <- c("Focal","Partner")#,"Unknown","Displace")
  varname <- c("Give","Receive")#,"Unknown","Displacement")
  ##### Approach
  for (i in 1:length(spliton)) {
    tmp <- file[,sum(grepl(spliton[i],`Initiator`, ignore.case = TRUE) & `Event Name`=="Approach"),by=`Observation Name`]
    names(tmp)[2] <- paste0(varname[i],"_Approach")
    out <- merge(out,tmp)
  }
  
  ##### contact Agg
  spliton <- c("give","receive")
  varname <- c("Give","Receive")
  for (i in 1:length(spliton)) {
    tmp <- file[,sum(grepl(spliton[i],`Direction`, ignore.case = TRUE) & `Event Name`=="contactAgg"),by=`Observation Name`]
    names(tmp)[2] <- paste0(varname[i],"_contactAgg")
    out <- merge(out,tmp)
  }
  
  ##### noncontact Agg & threat
  for (i in 1:length(spliton)) {
    tmp <- file[,sum(grepl(spliton[i],`Direction`, ignore.case = TRUE) & `Event Name`%in%c("noncontactAgg","threat")),by=`Observation Name`]
    names(tmp)[2] <- paste0(varname[i],"_noncontactAgg")
    out <- merge(out,tmp)
  }
  
  out$Year <- file$Year[1]
  out$Group <- file$Group[1]
  nc <- ncol(out)
  out <- out[,c(1:3,(nc-1):nc,4:(nc-2)),with=F]
  return(out)
}
