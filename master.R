# link for rstan installation https://github.com/stan-dev/rstan/wiki/Installing-RStan-on-Mac-or-Linux

#load in necessary libraries
library(readxl)
library(data.table)
library(stringr)
library(plyr)
library(dplyr)

# read all behavioral and genomic files from DropBox
mainpath <- "~/Plattlab/"
source(paste0(mainpath,"ReadXL.R"), echo=TRUE)

# extract aggregate behavioral data by observation and generate a list of processed data frames
all_files <- list(HH_2014, KK_2015, V_2015, R_2015, V_2016, F_2016, F_2015, F_2013, F_2014)
source(paste0(mainpath,"extract_obs.R"), echo=TRUE)
# merge and cast data files
source(paste0(mainpath,"precast.R"), echo=TRUE)
source(paste0(mainpath,"cast.R"), echo=TRUE)

# add age and genotypes
source(paste0(mainpath,"postcast.R"), echo=TRUE)

# run the model
behaviors = c("GroomGIVE", "GroomGET", "Initiate_Approach", "Receive_Approach", "PassCont", "noncontactAgg")
loci = c("chr2_57650752", "chr2_57649859", "chr2_57650182", "chr11_62124906", "chr11_62124901", "chr11_62124548", "chr11_62125302", "chr11_62121832", "chr1_160482644", "chr1_160488705", "chr1_160482645", "chr1_160482462", "chr14_48350461", "chr11_70811223", "chr11_70811292", "chr11_70826648", "chr11_70826681")
source(paste0(mainpath,"runmodel.R"), echo=TRUE)
