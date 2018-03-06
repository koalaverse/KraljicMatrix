[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/KraljicMatrix)](https://cran.r-project.org/package=KraljicMatrix)
[![Travis-CI Build Status](https://travis-ci.org/koalaverse/KraljicMatrix.svg?branch=master)](https://travis-ci.org/koalaverse/KraljicMatrix) 
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/8v0nlr960py4pklw?svg=true)](https://ci.appveyor.com/project/bradleyboehmke/kraljicmatrix) [![codecov](https://codecov.io/gh/koalaverse/KraljicMatrix/branch/master/graph/badge.svg)](https://codecov.io/gh/koalaverse/KraljicMatrix)
[![status](http://joss.theoj.org/papers/10.21105/joss.00170/status.svg)](http://joss.theoj.org/papers/10.21105/joss.00170)
[![Downloads](http://cranlogs.r-pkg.org/badges/KraljicMatrix)](http://cranlogs.r-pkg.org/badges/KraljicMatrix)
[![Total Downloads](http://cranlogs.r-pkg.org/badges/grand-total/KraljicMatrix)](http://cranlogs.r-pkg.org/badges/grand-total/KraljicMatrix)


# KraljicMatrix <img src="tools/kraljicmatrix_logo.png" align="right" width="120" height="139" />
 
`KraljicMatrix` is an R package for implementing Kraljic's (1983)[^kraljic] approach to strategically analyze a firm’s purchasing portfolio.  It has two main goals:

- Apply single and multi-attribute utility functions to rank-order products and services based on managerial preferences
- Align each product and service within Kraljic's purchasing matrix based on managerial preferences


## Installation

You can install `KraljicMatrix` two ways.

- Using the latest released version from CRAN:

```
install.packages("KraljicMatrix")
```

- Using the latest development version from GitHub:

```
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}

devtools::install_github("koalaverse/KraljicMatrix")
```

## Learning kraljicMatrix

To get started with `KraljicMatrix`, read the intro vignette: `vignette("kraljic", package = "KraljicMatrix")`.  This provides a thorough introduction to the functions provided in the package.  For deeper understanding behind the integration of single and multi-attribute utility thoery with the Kraljic Portfolio Matrix for strategic purchasing, read this [paper](https://www.dropbox.com/s/izxw97rjcu8e2t6/Article%20Submitted%20-%20Revised%20%282016-12-13.docx?dl=0).




[^kraljic]: Kraljic, P. (1983). Purchasing must become supply management. Harvard Business Review, 61(5), 109-117.
