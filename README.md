# kraljicMatrix


`kraljicMatrix` is an R package for implementing the Kraljic's (1983)[^kraljic] approach to strategically analyze a firm’s purchasing portfolio.  It has two main goals:

- Apply single and multi-attribute utility functions to rank-order products and services based on managerial preferences
- Align each product and service within Kraljic's purchasing matrix based on managerial preferences


## Installation

You can install `kraljicMatrix` two ways.

- Using the latest released version from CRAN:

```
install.packages("kraljicMatrix")
```

- Using the latest development version from GitHub:

```
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}

devtools::install_github("bradleyboehmke/kraljicMatrix")
```

## Learning kraljicMatrix

To get started with `kraljicMatrix`, read the intro vignette: `vignette("kraljic", package = "kraljicMatrix")`.  This provides a thorough introduction to the functions provided in the package.  For deeper understanding behind the integration of single and multi-attribute utility thoery with the Kraljic Portfolio Matrix for strategic purchasing, read this [paper](https://www.dropbox.com/s/izxw97rjcu8e2t6/Article%20Submitted%20-%20Revised%20%282016-12-13.docx?dl=0).




[^kraljic]: Kraljic, P. (1983). Purchasing must become supply management. Harvard Business Review, 61(5), 109-117.
