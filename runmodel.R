N <- 976 # total number of observations
P1 <- 14 # age, sex, age sex interaction, 10 individual observers (11 - 1), year
P2 <- 17 # all loci (OXTR, AVPR1A, AVPR1B, TPH1, TPH2) excluding those eliminated by r2 calculations
D <- 2 # GroomGIVE, GroomGET
L <- c(3,3) # number of levels per behavior
V <- 1 # random effects: focal ID
K <- c(191) # number of unique focal IDs
dim(K) <- 1 # change number of dimensions of K to 1
Y <- as.matrix(merged_OXTR_AVPR1[, names(merged_OXTR_AVPR1) %in% behaviors]) # columns containing behaviors

merged_OXTR_AVPR1$Age <- scale(merged_OXTR_AVPR1$Age) # z score Y

X1 <- model.matrix( ~ Age*SEX + Observer + Year, merged_OXTR_AVPR1)[,-1] # demographic predictors

X2 <- as.matrix(merged_OXTR_AVPR1[, names(merged_OXTR_AVPR1) %in% loci]) # 17 of 30 genotypes after r2 elimination

# set unique value for each focal ID
Z <- array(0, dim = c(353, 1))
Z[1] <- 1
for (i in 2:nrow(Y)) {
  if (merged_OXTR_AVPR1$Focal_ID[i] == merged_OXTR_AVPR1$Focal_ID[i-1]) {
    Z[i] <- Z[i-1] 
  }
  else {
    Z[i] <- Z[i-1] + 1
  }
}
Z <- as.matrix(Z)

nu <- 4 # degrees of freedom

param <- list(N=N, P1=P1, P2=P2, D=D, L=L, V=V, K=K, Y=Y, X1=X1, X2=X2, Z=Z, nu=nu)

library(rstan)
fit <- stan(file = 'model.stan', data = param, iter = 1000, warmup = 500, chains = 2, pars = c("u_raw", "u", "eta"), include = F)
# library(shinystan)
# shinyfit <- as.shinystan(fit)
# deploy_shinystan(shinyfit, appName = "monday_update")
