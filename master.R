# read all behavioral and genomic files from DropBox
source('~/Plattlab/ReadXL.R', echo=TRUE)

# extract aggregate behavioral data by observation and generate a list of processed data frames
all_files <- list(HH_2014, KK_2015, V_2015, R_2015, V_2016, F_2016, F_2015, F_2013, F_2014)
source('~/Plattlab/extract_obs.R', echo=TRUE)

# merge and cast data files
source('~/Plattlab/precast.R', echo=TRUE)
source('~/Plattlab/cast.R', echo=TRUE)

# add age and genotypes
source('~/Plattlab/postcast.R', echo=TRUE)

# run the model
behaviors = c("GroomGIVE1", "GroomGIVE2", "GroomGIVE3", "GroomGET1", "GroomGET2", "GroomGET3")
loci = c("chr2_57650752", "chr2_57649859", "chr2_57650182", "chr11_62124906", "chr11_62124901", "chr11_62124548", "chr11_62125302", "chr11_62121832", "chr1_160482644", "chr1_160488705", "chr1_160482645", "chr1_160482462", "chr14_48350461", "chr11_70811223", "chr11_70811292", "chr11_70826648", "chr11_70826681")
source('~/Plattlab/runmodel.R', echo=TRUE)
