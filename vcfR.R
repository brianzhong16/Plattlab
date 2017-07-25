# read VCF file from computer 
OXTR <- read.vcfR("OXTR_data", file = "/Users/brianzhong/OXTR_imputed_rhemac8_all_impact.vcf")
u_OXTR<- readVcf("/Users/brianzhong/OXTR_imputed_rhemac8_all_impact.vcf")

# extract genotype data from VCF object
OXTR_d <- extract.gt(OXTR, element = "GT", mask = FALSE, as.numeric = FALSE, return.alleles = FALSE, IDtoRowNames = TRUE, extract = TRUE, convertNA = TRUE)

# transpose data frame
OXTR_d <- t(OXTR_d)
OXTR_d <- as.data.frame(OXTR_d)
u_OXTR <- genotypeToSnpMatrix(u_OXTR, uncertain = FALSE)
u_OXTR <- as.data.table(u_OXTR)

# OXTR_DP <- extract.dp(OXTR, element = "GT", mask = FALSE, as.numeric = FALSE, return.alleles = TRUE, IDtoRowNames = TRUE, extract = TRUE, convertNA = TRUE)
# OXTR_data <- as.data.table(OXTR_data)

# convert Focal ID rownames to a column
OXTR_d <- rownames_to_column(OXTR_d, var = "Focal_ID")

# merge genotype and behavioral data
merged_OXTR <- merge(all_obs, oxtr_genotypes, by = "Focal_ID")

# OXTR_chr2_57649859 <- OXTR_chr2[OXTR_chr2$Var1 == "chr2_57649859",]
# colnames(OXTR_chr2_57649859) <- c("Chromosome", "Focal_ID", "Genotype")
