#load in necessary libraries
library(readxl)

#female only?
ff <- F
# read all behavioral and genomic files from DropBox
#mainpath <- "~/Plattlab/"
mainpath <- "~/code/brianzhong/Plattlab/"
source(paste0(mainpath,"ReadXL.R"), echo=TRUE)

# extract aggregate behavioral data by observation and generate a list of processed data frames
source(paste0(mainpath,"extract_obs.R"), echo=TRUE)
# merge and cast data files
source(paste0(mainpath,"precast.R"), echo=TRUE)
#source(paste0(mainpath,"cast.R"), echo=TRUE)

# extract monkey info
source(paste0(mainpath,"postcast.R"), echo=TRUE)

