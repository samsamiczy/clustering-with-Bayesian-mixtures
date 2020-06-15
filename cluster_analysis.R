library("mixAK")
library("factoextra")

df=read.csv("cancer_df.csv")
df= df[,3:12]

#Calculate PCA

tumour_PCA = prcomp(df, scale=FALSE) 
a = summary(tumour_PCA)
tumour_PC = as.data.frame(tumour_PCA$x)

png('cumulative_pca.png')
plot(a$importance[3, 1:10], ylab = "Cumulative variance", xlab="Number of components", 
     type = "o", main = "Variance explained by PCA.")
dev.off()

p = data.frame(matrix("", ncol = 1, nrow = 569))
p2 = data.frame(matrix("", ncol = 1, nrow = 569))

#Specify the parameters

keep = 400
burnin = 0
thin = 1

prior1 = list()
posterior1 = list()

prior2 = list()
posterior2 = list()

prior3 = list()
posterior3 = list()

for(parameter_delta in c(0.8, 1, 100))
{
  if(parameter_delta==0.8)
  {
    png('plot1.png')
  }
  if(parameter_delta==1)
  {
    png('plot2.png')
  }
  if(parameter_delta==10)
  {
    png('plot3.png')
  }
  
  layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
  for(K in c(2, 3, 5, 10))
  {
    #SPECIFY THE RUN
    
    set.seed(555)
    init = list(K=K)
    nMCMC <- c(burn=burnin, keep=keep, info=1000, thin=thin)
    Prior <- list(priorK = "fixed", Kmax = K, delta = parameter_delta)
    
    #RUN
    
    fit <- NMixMCMC(y0=df, prior = Prior, nMCMC = nMCMC, init=init)
    print(fit)
    
    #GET COMPONENT ALLOCATIONS
    p[[K]] <- NMixPlugDA(fit[[1]], df)
    p2[[K]] <- NMixPlugDA(fit[[2]], df)
    
    dic1=round(fit[[1]]$DIC$DIC)
    dic2=round(fit[[2]]$DIC$DIC)
    
    clusters = p[[K]]$component
    clusters2 = p2[[K]]$component
  
    
    if(fit[[1]]$DIC$DIC < fit[[2]]$DIC$DIC)
    {
      plot(tumour_PC$PC1, tumour_PC$PC2, main = c("First chain, number of components: ", K, "Parameter delta: ", parameter_delta), xlab="PC1", ylab="PC2")
      
      points(tumour_PC[clusters==1,]$PC1, tumour_PC[clusters==1,]$PC2, col="yellow", pch=19)
      points(tumour_PC[clusters==2,]$PC1, tumour_PC[clusters==2,]$PC2, col="orange", pch=19)
      points(tumour_PC[clusters==3,]$PC1, tumour_PC[clusters==3,]$PC2, col="blue", pch=19)
      points(tumour_PC[clusters==4,]$PC1, tumour_PC[clusters==4,]$PC2, col="black", pch=19)
      points(tumour_PC[clusters==5,]$PC1, tumour_PC[clusters==5,]$PC2, col="grey", pch=19)
      points(tumour_PC[clusters==6,]$PC1, tumour_PC[clusters==6,]$PC2, col="palevioletred3", pch=19)
      points(tumour_PC[clusters==7,]$PC1, tumour_PC[clusters==7,]$PC2, col="cyan", pch=19)
      points(tumour_PC[clusters==8,]$PC1, tumour_PC[clusters==8,]$PC2, col="palegreen", pch=19)
      points(tumour_PC[clusters==9,]$PC1, tumour_PC[clusters==9,]$PC2, col="orchid", pch=19)
      points(tumour_PC[clusters==10,]$PC1, tumour_PC[clusters==10,]$PC2, col="palevioletred4", pch=19)
      legend("bottomright", legend=c(dic1))
      legend("bottomleft", legend=c(fit[[1]]$nMCMC[1:3]))
      
      if(parameter_delta==1)
      {
        prior2[[K]] = fit[[1]]$prior
        posterior2[[K]] = fit[[1]]
      }
      if(parameter_delta==0.8)
      {
        prior1[[K]] = fit[[1]]$prior
        posterior1[[K]] = fit[[1]]
      }
      if(parameter_delta==10)
      {
        prior3[[K]] = fit[[1]]$prior
        posterior3[[K]] = fit[[1]]
      }
      
    }
    else
    {
      plot(tumour_PC$PC1, tumour_PC$PC2, main = c("Second chain, number of components: ", K, "Parameter delta: ", parameter_delta), xlab="PC1", ylab="PC2")
      
      points(tumour_PC[clusters2==1,]$PC1, tumour_PC[clusters2==1,]$PC2, col="yellow", pch=19)
      points(tumour_PC[clusters2==2,]$PC1, tumour_PC[clusters2==2,]$PC2, col="orange", pch=19)
      points(tumour_PC[clusters2==3,]$PC1, tumour_PC[clusters2==3,]$PC2, col="blue", pch=19)
      points(tumour_PC[clusters2==4,]$PC1, tumour_PC[clusters2==4,]$PC2, col="black", pch=19)
      points(tumour_PC[clusters2==5,]$PC1, tumour_PC[clusters2==5,]$PC2, col="grey", pch=19)
      points(tumour_PC[clusters2==6,]$PC1, tumour_PC[clusters2==6,]$PC2, col="palevioletred3", pch=19)
      points(tumour_PC[clusters2==7,]$PC1, tumour_PC[clusters2==7,]$PC2, col="cyan", pch=19)
      points(tumour_PC[clusters2==8,]$PC1, tumour_PC[clusters2==8,]$PC2, col="palegreen", pch=19)
      points(tumour_PC[clusters2==9,]$PC1, tumour_PC[clusters2==9,]$PC2, col="orchid", pch=19)
      points(tumour_PC[clusters2==10,]$PC1, tumour_PC[clusters2==10,]$PC2, col="palevioletred4", pch=19)
      legend("bottomright", legend=c(dic2))
      legend("bottomleft", legend=c(fit[[2]]$nMCMC[1:3]))
      
      if(parameter_delta==1)
      {
        prior2[[K]] = fit[[2]]$prior
        posterior2[[K]] = fit[[2]]
      }
      if(parameter_delta==0.8)
      {
        prior1[[K]] = fit[[2]]$prior
        posterior1[[K]] = fit[[2]]
      }
      if(parameter_delta==10)
      {
        prior3[[K]] = fit[[2]]$prior
        posterior3[[K]] = fit[[2]]
      }
    }
  }
  dev.off()
}
