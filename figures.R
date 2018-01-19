param <- param_all
fit <- fit_all

lambda <- extract(fit,pars="lambda",permuted=T)$lambda
#behnames <- ordered(behaviors,levels=behaviors[param$D:1])
behnames <- c("Groom (give)","Groom (rec)",
              "Passive Contact","Approach (give)","Approach (rec)",
              "ContactAgg (give)", "ContactAgg (rec)",
              "NoncontactAgg (give)","NoncontactAgg (rec)")

#locinames <- c(paste("OXTR",1:3),paste("AVPR1a",1:5),paste("AVPR1b",1:4))
locinames <- colnames(param$X2)
locinames <- str_replace(locinames,"_",":")
locinames <- ordered(locinames,levels=locinames[length(locinames):1])

behnames <- ordered(behnames,levels=behnames[param$D:1])
iter <- nrow(lambda)
locieff <- data.table(lambda=exp(lambda)-1,
           iter=1:iter,
           locus=rep(locinames,each=iter),
           behavior=rep(behnames,each=iter*param$P2))

effplt <- locieff[,.(mu=mean(lambda),lb=quantile(lambda,0.025),
           ub=quantile(lambda,0.975),lbi=quantile(lambda,0.1),ubi=quantile(lambda,0.9)),
        by=c("locus","behavior")]

ggplot(effplt,aes(x=mu,y=locus)) + geom_point() + geom_errorbarh(aes(xmin=lb,xmax=ub),height=0,size=.25) +
  geom_errorbarh(aes(xmin=lbi,xmax=ubi),height=0,size=1) + facet_wrap( ~ behavior,nrow = 3) +
  ylab("SNV") + geom_vline(xintercept=0,size=0.1) + scale_x_continuous("Odds % change",labels = scales::percent)

coeffnames <- c("Male","Age",expression(Age^2),"Rank",expression(Rank^2),"Male x Age",expression("Male x Age"^2),"Male x Rank",expression("Male x"))
if (ncol(param$X1)<length(coeffnames)) coeffnames <- coeffnames[2:5]

betadat <- data.table(beta=extract(fit,pars="beta",permuted=T)$beta,
                   iter=1:iter,
                   coeff=rep(ordered(colnames(param$X1),levels=colnames(param$X1)[param$P1:1]),each=iter),
                   behavior=rep(behnames,each=iter*param$P1))
betadat[,beta:=exp(beta)-1]
betaplt <- betadat[,.(mu=mean(beta),lb=quantile(beta,0.025),
                      ub=quantile(beta,0.975),lbi=quantile(beta,0.1),ubi=quantile(beta,0.9)),
                   by=c("coeff","behavior")]
ggplot(betaplt,aes(x=mu,y=coeff)) + geom_point() + 
  geom_errorbarh(aes(xmin=lb,xmax=ub),height=0,size=.25) + facet_wrap( ~ behavior,scales = "free_x") + 
  geom_errorbarh(aes(xmin=lbi,xmax=ubi),height=0,size=1) + geom_vline(xintercept=0,size=0.1) + ylab("") + 
  scale_x_continuous("Odds % change",labels=scales::percent) + scale_y_discrete("Covariate",labels = coeffnames[param$P1:1])
# penviro <- ggplot(betaplt[coeff %in% colnames(param$X1)[c(6:11)]],aes(x=mu,y=behavior)) + geom_point() + 
#   geom_errorbarh(aes(xmin=lb,xmax=ub),height=0,size=.25) + facet_wrap( ~ coeff,scales = "free_x") + 
#   geom_errorbarh(aes(xmin=lbi,xmax=ubi),height=0,size=1) + geom_vline(xintercept=0,size=0.1) + ylab("") + xlab("Regression coefficient")

# library(cowplot)
# plot_grid(pdemo,penviro,labels = c("a","b"),scale=1.0,nrow = 2)

r2dat <- plot(fit,pars="r2")$data
r2dat$params <- ordered(behaviors,levels=behaviors[D:1])
ggplot(r2dat,aes(x=mean,y=params)) + geom_point() + geom_errorbarh(aes(xmin=ll,xmax=hh),height=0,size=.25) +
  geom_errorbarh(aes(xmin=l,xmax=h),height=0,size=1) + 
  ylab("Behavior") + xlab("R2")



##heritability-ish
inddiff <- extract(fit,pars="sigma_u")[[1]][,1,]
geneff <- extract(fit,pars="sigma_g")[[1]]
mateff <- extract(fit,pars="sigma_u")[[1]][,2,]
denom <- geneff^2 + inddiff^2 + mateff^2 + pi^2/3
ph2dat <- data.table(s2h2=as.vector((geneff^2 + inddiff^2 + mateff^2)/denom),
                     h2=as.vector(geneff^2/denom),
                     s2=as.vector(inddiff^2/denom),
                     m2 = as.vector(mateff^2/denom),
                     iter=1:iter,
                     behavior=rep(behnames,each=iter))
ph2dat <- melt(ph2dat,id.vars = c("behavior","iter"))
ph2plt <- ph2dat[,.(mu=mean(value),lb=quantile(value,0.025),
                     ub=quantile(value,0.975),lbi=quantile(value,0.1),ubi=quantile(value,0.9)),
                  by=c("behavior","variable")]
ggplot(ph2plt,aes(y=mu,x=behavior,color=variable)) + geom_point(position=position_dodge(width=0.5)) + geom_errorbar(aes(ymin=lb,ymax=ub),width=0,size=.25,position=position_dodge(width=0.5)) +
  geom_errorbar(aes(ymin=lbi,ymax=ubi),width=0,size=1,position=position_dodge(width=0.5)) +
  scale_y_continuous("Proportion of variance",labels=scales::percent) + xlab("") + 
  scale_color_discrete("",labels=c("Total","Additive Genetic","Permanent\nEnvironment","Maternal")) + coord_flip()

n <- 169
X2lamb <- array(dim=c(n,iter,param$D))
for (i in 1:param$D) X2lamb[,,i] <- (param$X2 %*% t(extract(fit_all,pars="lambda")$lambda[,,i])) %>% apply(2,unique)
geff <- apply(X2lamb,c(2,3),function(x) mean(x^2))
colMeans(geff/(geneff+geff))
apply(geff/(denom+geff),2,quantile,probs=c(0.025,0.975))
