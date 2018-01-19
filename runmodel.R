data <- copy(merged_OXTR_AVPR1)
N <- nrow(data) # total number of observations
P2 <- length(loci) # all loci (OXTR, AVPR1A, AVPR1B, TPH1, TPH2) excluding those eliminated by r2 calculations
D <- length(behaviors) # GroomGET, GroomGIVE, Initiate Approach, Receive Approach, PassCont, noncontactAgg
#L <- c(3, 3, 3, 3, 3, 3) # number of levels per behavior
# dim(L) <- 1
#dim(K) <- 1 # change number of dimensions of K to 1
Y <- as.matrix(data[,Reduce(`|`,lapply(behaviors,function(x) str_detect(names(data),x))),with=F]) # columns containing behaviors
L <- str_extract(colnames(Y),"\\d") %>% as.numeric()
L <- c(-diff(L)[diff(L)<0]+1,L[D])

#data$Age <- scale(data$Age) # z score Y
data[,Year:=factor(Year)] # make year a categorical variable
if (ff) {
  X1 <- model.matrix( ~ poly(Age,2) + ORD_RANK, data)[,-1]
  X1[,1:2] <- apply(X1[,1:2],MARGIN = 2,scale)
} else {
  X1 <- model.matrix( ~ SEX*poly(Age,2) + SEX*ORD_RANK +paste0(Year,Group), data)[,-1] # demographic predictors
  X1[,2:3] <- apply(X1[,2:3],MARGIN = 2,scale) #normalize continuous predictors
  X1[,16:17] = X1[,2:3]*X1[,1] #normalize interactions
}
X1 <- t(t(X1)-colMeans(X1)) #demean everything
P1 <- ncol(X1)

X2 <- as.matrix(data[, names(data) %in% loci,with=F]) # 17 of 30 genotypes after r2 elimination
X2 <- t(t(X2)-colMeans(X2)) #demean

V <- 4 #random effects: focal ID, maternal ID, observer, year x group
Z <- data[,cbind(as.numeric(factor(Focal_ID)),
                 merge(data[,.(Focal_ID)],pedigree[,.(Focal_ID,DAM)])[,as.numeric(factor(DAM))],
                 as.numeric(factor(Observer)),
                 as.numeric(factor(paste0(Group,Year))))]
K <-  apply(Z,2,function(x)length(unique(x))) # number of unique focal IDs

nu <- 4 # degrees of freedom

param <- list(N=N, P1=P1, P2=P2, D=D, L=L, V=V, K=K, Y=Y, X1=X1, X2=X2, Z=Z, nu=nu)

#library(rstan)
#mordreg <- stan_model("~/code/OrdRegMix/mordreg.stan")
#fit <- stan(file="~/code/OrdRegMix/mordreg.stan", data = param, iter = 300, warmup = 100, chains = 1, pars = c("u_raw", "u", "eta","lambda_raw"), include = F)

load("~/Dropbox/Pedigree and Life-History Data/pedigreeKW2016.RData")
A <- 2*kinship2::kinship(bigped$id,dadid=bigped$sire,momid=bigped$dam)
A <- A[match(unique(data$Focal_ID),rownames(A)),match(unique(data$Focal_ID),rownames(A))]
LA <- model.matrix( ~ 0 + Focal_ID,data=data) %*% t(chol(A))
param$R <- ncol(LA)
param$L_A <- LA
#constrainedfit <- stan(file = 'constrainedmodel.stan', data = param, iter = 4000, warmup = 2000, chains = 1, pars = c("u_raw", "u", "eta"), include = F)
# library(shinystan)
# shinyfit <- as.shinystan(fit)
# deploy_shinystan(shinyfit, appName = "morebehaviors")
# groomgive <- plot(fit, pars = selectparams1, main = "Effect Sizes GroomGIVE", fill_color = "green4", xlab = "Effect size")
# groomgive + labs(pars = c("Provide grooming", "Receive grooming", "Initiate approach", "Being appproached", "Passive contact", "Non contact aggression"))
