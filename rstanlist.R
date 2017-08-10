N <- 353 # total number of observations
P1 <- 3 # age, sex, age sex interaction
P2 <- 26 # all loci (OXTR, AVPR1A, AVPR1B, TPH1)
D <- 2 # GroomGIVE, GroomGET
L <- c(3,3)
V <- 1 # focal ID
K <- c(171) # number of unique focal IDs
dim(K) <- 1 # change number of dimensions of K to 1
Y <- as.matrix(merged_OXTR_AVPR1[, 5:10]) # columns containing behaviors

merged_OXTR_AVPR1$Age <- scale(merged_OXTR_AVPR1$Age) # z score Y
 
X1 <- model.matrix( ~ Age*SEX, merged_OXTR_AVPR1)[,-1] # demographic predictors
colnames(X1) <- c("Age", "SEX", "Age*SEX") # set column names of X1

X2 <- as.matrix(merged_OXTR_AVPR1[,c(28:52, 54)]) # all genotypes

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
fit <- stan(file = 'model.stan', data = param, iter = 1000, warmup = 500, chains = 2)

