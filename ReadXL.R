path <- "/Users/brianzhong/Desktop/Behavioral Data/KK_2015.xlsx"
path2<- "/Users/brianzhong/Desktop/oxtr_genotypes.xlsx"

HH_2014 <- read_excel(path, sheet = "2014 HH FOCAL")
F_2010 <- read_excel(path, sheet = "alldata_randomised")
F_2012_novigilance <- read_excel(path, sheet = "behaviours_no vigilance")
KK_2015 <- read_excel(path, sheet = "grpKK_2015")
V_2015 <- read_excel(path, sheet = "groupV 2015")
R_2015 <- read_excel(path, sheet = "DATA")
V_2016 <- read_excel(path, sheet = "Sheet1")
F_2016 <- read_excel(path, sheet = "2016.GrpF_MASTER")
F_2011 <- read_excel(path, sheet = "DATA")
S_2011 <- read_excel(path, sheet = "DATA no Duplicate DAYS")
F_2015 <- read_excel(path, sheet = "behaviours")
F_2013 <- read_excel(path, sheet = "behaviours")
F_2014 <- read_excel(path, sheet = "behaviours")
oxtr_genotypes <- read_excel(path2, sheet = "Sheet1")
