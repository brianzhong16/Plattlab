# extract genotype data from VCF object
OXTR_data <- extract.gt(OXTR, element = "GT", mask = FALSE, as.numeric = TRUE, return.alleles = FALSE, IDtoRowNames = TRUE, extract = TRUE, convertNA = TRUE)

# OXTR_DP <- extract.dp(OXTR, element = "GT", mask = FALSE, as.numeric = FALSE, return.alleles = TRUE, IDtoRowNames = TRUE, extract = TRUE, convertNA = TRUE)
OXTR_data <- as.data.table(OXTR_data)

OXTR_chr2 <- melt(OXTR_data, id = c(chr2_57649859, chr2_57649859))

OXTR_chr2_57649859 <- OXTR_chr2[OXTR_chr2$Var1 == "chr2_57649859",]

colnames(OXTR_chr2_57649859) <- c("Chromosome", "Focal_ID", "Genotype")
