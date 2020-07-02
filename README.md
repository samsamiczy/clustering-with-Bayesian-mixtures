# Bayesian Mixture Models for cluster analysis of breast tumours

 This project was a part of my undegraduate dissertation. I have looked at applications of Bayesian Mixture Models to probablistic clustering of breast tumours.
 I have also learnt theory behind Markov Chain Monte Carlo methods and Gibbs sampler in particular. 
 
 I have used Python (seaborn) for Exploratory Data Analysis (EDA) and visualization. The data then was imported into R where I have used a package for Bayesian statistics (mixAK) to perform cluster analysis.
 
## EDA

FNA biopsy technique uses a very thin needle to remove a sample of cells from an area in the body (a tumor in this case) to further investigate with a microscope. 
The data comes from digitalized images taken from a camera attached to the microscope. An 8-bit-per-pixel grey scale image was used for image analysis. Firstly,
a researcher defined boundaries of a cell nuclei by hand (using computer mouse), such approximations of boundaries were then corrected by an active contour model
known in the literature as "snake" until theresearcher was satisfied with the result (see [1] for more details of the process).

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

![mean_pairplot](https://user-images.githubusercontent.com/57573839/86381219-5a52ae00-bc8d-11ea-9fbd-bd24db331ce0.jpg)

As we can see, only a couple of features clearly indicate some difference for diffferent levels of class variable diagnosis. 

These features are describing area, perimeter, radius and concavity of cells. Moreover, now we can see that extreme values provide more insights as distributions are different for benign/malignant cases.

#### Box and swarm plots for extreme values.
![box_m](https://user-images.githubusercontent.com/57573839/86377756-047c0700-bc89-11ea-8d31-49ca1e240903.jpg)
![swarm_w](https://user-images.githubusercontent.com/57573839/86377772-0a71e800-bc89-11ea-97eb-401f485f42d7.jpg)

Let's see some tools to visualize all extreme values at once.

 A popular technique for visualization high-dimensional data is Principal Component Analysis or PCA, described in 30s by Karl Pearson, it finds new axis that maximize variance.
### Visualization with PCA.



One of the techniques that has been very useful for such problem is t-Stochastic Neighbour Embedding or t-SNE.

### Visualization with t-SNE.
![t-sne](https://user-images.githubusercontent.com/57573839/86388045-5e35fe80-bc94-11ea-8cb5-547dc3300f6b.jpg)


### References

[1] Street, W. N., Wolberg, W. H., and Mangasarian, O. L. Nuclear feature extraction forbreast tumor diagnosis. InBiomedical 
image processing and biomedical visualization(1993), vol. 1905, International Society for Optics and Photonics, pp. 861–870.


