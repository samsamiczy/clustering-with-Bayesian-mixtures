# Bayesian Mixture Models for cluster analysis of breast tumours

 This is a part of my undegraduate dissertation submitted at University of Southampton. 
 
 I have looked at applications of Bayesian Mixture Models to probablistic clustering, I have also learnt theory behind Markov Chain Monte Carlo methods (Metropolis-Hastings and Gibbs sampler).
 
 I used a Bayesian statistics package (R, mixAK [3]) and seaborn (Python) for some visualizations.
 The data set comes from UCI Machine Learning repository [2]. 
 
## Bayesian Mixture Models

 Graphical models are used in probabilistic machine learning to express conditional dependence between random variables. I was studying Bayesian approach to Gaussian Mixture Models where mixture weights and parameters are itself random variables, hence priors put on them in the model (grey squares):
 
 ![graphicalmodel-](https://user-images.githubusercontent.com/57573839/98443181-a1502480-2101-11eb-8ea4-85f3248be926.JPG)
 
 Model can be also represented by the sampling:
 
 ![samplings](https://user-images.githubusercontent.com/57573839/98443212-dd838500-2101-11eb-8a6a-b6645dc3eda3.JPG)
 
 In mixture models we assume that the population consists of sub-populations and we aim to find parameters of these. Using Bayes formula we can obtain an expression proportional to the posterior by calculating the product of a prior belief and likelihood.
 
 ![posterior](https://user-images.githubusercontent.com/57573839/98443193-be84f300-2101-11eb-90c4-83296e92e25e.JPG)

However, we can't calculate normalization constant analytically as it is a multidimensional integral. Since we know posterior up to the constant, we can judge whether a given paramter is probable or not. This is where MCMC methods come in. The idea behind the algorithm is to set up a Markov Chain which has a unique stationary distribution matching our posterior. We do this by setting up a condition that results in the chain taking more steps in regions of high probability. There are many MCMC, I focused on Metropolis-Hastings and Gibbs Sampler - which can be seen as a special case of MH and was finally used for estimation in this project. 

 ![mh](https://user-images.githubusercontent.com/57573839/98443511-9b5b4300-2103-11eb-8ecf-c37832fdb48c.JPG)


There are different tricks to optimize the sampling, such as burn-in period, different starting points (we run into the problem of local minima just like in other optimizer such as Stochastic Gradient Descent) or thinning. 
 
![gs](https://user-images.githubusercontent.com/57573839/98443546-d1002c00-2103-11eb-8189-77bd3d3ccf30.JPG)

## EDA

FNA biopsy technique uses a very thin needle to remove a sample of cells from an area in the body (a tumor in this case) to further investigate with a microscope. 
The data comes from digitalized images taken from a camera attached to the microscope. An 8-bit-per-pixel grey scale image was used for image analysis. Firstly,
a researcher defined boundaries of a cell nuclei by hand (using computer mouse), such approximations of boundaries were then corrected by an active contour model
known in the literature as "snake" until theresearcher was satisfied with the result (see [1] for more details of the process).

![cellts](https://user-images.githubusercontent.com/57573839/98443225-f2f8af00-2101-11eb-9394-a80dedeaf2a5.JPG)

Ten features were then calculated for each cell in the image. Then standard error, mean and worst (mean of three highest values in the image) were calculated. The features were
calculated so that higher value of a given feature indicated higher risk of malignant cell. 

#### Examples of contours for calculating symmetry of cell and concavity.
![cellss](https://user-images.githubusercontent.com/57573839/86353709-f964af00-bc67-11ea-9ba6-edbd80140429.jpg)

As noted in [1], a sample (image) is classified as malignant if any of the cells is malignant. Therefore we should put an emphasis on 'worst' values, if these values are very high for a given sample, it's probable that the sample is malignant. 

Due to the nature of computing features, some of them are highly correlated, let's see which ones!

#### Correlations for extreme values.
![worst_col](https://user-images.githubusercontent.com/57573839/86380986-11025e80-bc8d-11ea-818b-232806323051.JPG)

Now we can see pairplot of extreme values and compare it to the one from means, let's see which one is more predictable.

#### Pairplots for extreme values and means.
![worst_pairplot](https://user-images.githubusercontent.com/57573839/86376096-ced61e80-bc86-11ea-9c22-da3b21254c41.jpg)

As we can see, only a couple of features clearly indicate some difference for diffferent levels of class variable diagnosis. 

These features are describing area, perimeter, radius and concavity of cells. We can see that extreme values provide more insights as distributions are different for benign/malignant cases, this is suggested by [1].

#### Box and swarm plots for extreme values.
![box_m](https://user-images.githubusercontent.com/57573839/86377756-047c0700-bc89-11ea-8d31-49ca1e240903.jpg)
![swarm_w](https://user-images.githubusercontent.com/57573839/86377772-0a71e800-bc89-11ea-97eb-401f485f42d7.jpg)

Let's see some tools to visualize all extreme values at once.

 A popular technique for visualization high-dimensional data is Principal Component Analysis or PCA, described in 30s by Karl Pearson, it finds new axis that maximize variance.
 Here is the PCA applied to 'worst' features with labels for two labels of diagnosis.
 
#### Visualization with PCA.

![pca_diag](https://user-images.githubusercontent.com/57573839/86445695-1c986880-bd13-11ea-8d01-4f15ffd86853.png)

We see similar trend, maybe clustering behaviour is not very much visible, but one class is more densly placed then the other.
Let's now use R package mixAK to see how Bayesian Mixture Model performs on this data set. I will use a few number of components (here fixed) to see if maybe come other clusters are formed.

#### Results of BMM cluster analysis. 
![plot1](https://user-images.githubusercontent.com/57573839/86454331-5f603d80-bd1f-11ea-987d-43d40cd48aef.png)
![plot2](https://user-images.githubusercontent.com/57573839/86454340-5ff8d400-bd1f-11ea-8b36-7a9cacb0a4d1.png)
![plot3](https://user-images.githubusercontent.com/57573839/86454341-60916a80-bd1f-11ea-8b81-62083123a1b8.png)

For K = 2 components, the two clusters are very much the same as in previous PCA plot. Hence, the model did a great job. It was trained with Gibbs sampler for I = 5000 iterations and B = 500 burn-in. Chain resulting in smaller DIC (deviance information criterion) was chosen and plotted. Different values of delta were used (hyperparameter on Dirichlet prior). Generally, the model shows 2-3 visible clusters. 

Another technique that has proven to be very useful for visualizing clustering problems is t-Stochastic Neighbour Embedding or t-SNE.

### Visualization with t-SNE.
![t-sne](https://user-images.githubusercontent.com/57573839/86388045-5e35fe80-bc94-11ea-8cb5-547dc3300f6b.jpg)

As we can see, t-SNE visualized the data set clearly marking two clusters for class variable diagnosis.

### References

[1] Street, W. N., Wolberg, W. H., and Mangasarian, O. L. Nuclear feature extraction forbreast tumor diagnosis. InBiomedical 
image processing and biomedical visualization(1993), vol. 1905, International Society for Optics and Photonics, pp. 861–870.

[2] Dua, D., and Graff, C. UCI Machine Learning Repository.http://archive.ics.uci.edu/ml, 2017.

[3] Based, L. M. M. I. M., Komárek, C. A. A., and Komárek, M. A. Package ‘mixak’

### Thanks for your attention :)

