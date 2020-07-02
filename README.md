# Bayesian Mixture Models for cluster analysis of breast tumours

 This project was a part of my undegraduate dissertation. I have looked at applications of Bayesian Mixture Models to probablistic clustering of breast tumours.
 I have also learnt theory behind Markov Chain Monte Carlo methods and Gibbs sampler in particular. 
 
 I have used Python (seaborn) for Exploratory Data Analysis (EDA) and visualization. The data then was imported into R where I have used a package for Bayesian statistics (mixAK) 
 to perform cluster analysis.
 
## EDA

FNA biopsy technique uses a very thin needle to remove a sample of cells from an area in the body (a tumor in this case) to further investigate with a microscope. 
The data comes from digitalized images taken from a camera attached to the microscope. An 8-bit-per-pixel grey scale image was used for image analysis. Firstly,
a researcher defined boundaries of a cell nuclei by hand (using computer mouse), such approximations of boundaries were then corrected by an active contour model
known in the literature as "snake" until theresearcher was satisfied with the result (see [1] for more details of the process).

Ten features were then calculated for each cell in the image. Then standard error, mean and worst (mean of three highest values in the image) were calculated. The features were
calculated so that higher value of a given feature indicated higher risk of malignant cell. 



### References

[1] Street, W. N., Wolberg, W. H., and Mangasarian, O. L. Nuclear feature extraction forbreast tumor diagnosis. InBiomedical 
image processing and biomedical visualization(1993), vol. 1905, International Society for Optics and Photonics, pp. 861–870.


