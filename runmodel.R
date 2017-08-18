library(data.table)
data <- copy(merged_OXTR_AVPR1)
N <- nrow(data) # total number of observations
P2 <- length(loci) # all loci (OXTR, AVPR1A, AVPR1B, TPH1, TPH2) excluding those eliminated by r2 calculations
D <- 2 # GroomGIVE, GroomGET
L <- c(3,3) # number of levels per behavior
V <- 1 # random effects: focal ID
K <-  data[,length(unique(Focal_ID))] # number of unique focal IDs
dim(K) <- 1 # change number of dimensions of K to 1
Y <- as.matrix(data[,str_detect(names(data),paste(behaviors,collapse="|")),with=F]) # columns containing behaviors

data$Age <- scale(data$Age) # z score Y
data[,Year:=factor(Year)] # make year a categorical variable
X1 <- model.matrix( ~ Age*SEX + Observer + Year + Group, data)[,-1] # demographic predictors
P1 <- ncol(X1)
X2 <- as.matrix(data[, names(data) %in% loci,with=F]) # 17 of 30 genotypes after r2 elimination

# set unique value for each focal ID
# Z <- array(0, dim = c(353, 1))
# Z[1] <- 1
# for (i in 2:nrow(Y)) {
#   if (data$Focal_ID[i] == data$Focal_ID[i-1]) {
#     Z[i] <- Z[i-1] 
#   }
#   else {
#     Z[i] <- Z[i-1] + 1
#   }
# }
Z <- as.matrix(data[,as.numeric(factor(Focal_ID))])

nu <- 4 # degrees of freedom

param <- list(N=N, P1=P1, P2=P2, D=D, L=L, V=V, K=K, Y=Y, X1=X1, X2=X2, Z=Z, nu=nu)

library(rstan)
fit <- stan(file = 'model.stan', data = param, iter = 1000, warmup = 500, chains = 1, pars = c("u_raw", "u", "eta"), include = F)
library(shinystan)
shinyfit <- as.shinystan(fit)
deploy_shinystan(shinyfit, appName = "morepredictors")
