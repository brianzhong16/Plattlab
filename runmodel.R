library(data.table)
data <- copy(merged_OXTR_AVPR1)
N <- nrow(data) # total number of observations
P2 <- length(loci) # all loci (OXTR, AVPR1A, AVPR1B, TPH1, TPH2) excluding those eliminated by r2 calculations
D <- length(behaviors) # GroomGET, GroomGIVE, Initiate Approach, Receive Approach, PassCont, noncontactAgg
L <- c(3, 3, 3, 3, 3, 3) # number of levels per behavior
# dim(L) <- 1
V <- 1 # random effects: focal ID
K <-  data[,length(unique(Focal_ID))] # number of unique focal IDs
dim(K) <- 1 # change number of dimensions of K to 1
# Y <- as.matrix(data[,str_detect(names(data),paste(behaviors,collapse="|")),with=F]) # columns containing behaviors
Y <- as.matrix(data[, c(9:14, 18:23, 28:30, 43:45)]) # behaviors

data$Age <- scale(data$Age) # z score Y
data[,Year:=factor(Year)] # make year a categorical variable
X1 <- model.matrix( ~ Age*SEX + Observer + Year + Group + ORD_RANK, data)[,-1] # demographic predictors
P1 <- ncol(X1)
X2 <- as.matrix(data[, names(data) %in% loci,with=F]) # 17 of 30 genotypes after r2 elimination
Z <- as.matrix(data[,as.numeric(factor(Focal_ID))])

nu <- 4 # degrees of freedom

param <- list(N=N, P1=P1, P2=P2, D=D, L=L, V=V, K=K, Y=Y, X1=X1, X2=X2, Z=Z, nu=nu)

library(rstan)
fit <- stan(file = 'model.stan', data = param, iter = 200, warmup = 100, chains = 1, pars = c("u_raw", "u", "eta"), include = F)
constrainedfit <- stan(file = 'constrainedmodel.stan', data = param, iter = 4000, warmup = 2000, chains = 1, pars = c("u_raw", "u", "eta"), include = F)
# library(shinystan)
# shinyfit <- as.shinystan(fit)
# deploy_shinystan(shinyfit, appName = "morebehaviors")
# groomgive <- plot(fit, pars = selectparams1, main = "Effect Sizes GroomGIVE", fill_color = "green4", xlab = "Effect size")
# groomgive + labs(pars = c("Provide grooming", "Receive grooming", "Initiate approach", "Being appproached", "Passive contact", "Non contact aggression"))
