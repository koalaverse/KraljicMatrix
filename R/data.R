#' Product and service contracts
#'
#' A dataset containing a single value score for the x attribute (i.e. supply risk)
#' and y attribute (i.e. profit impact) of 200 product and service contracts (PSC).
#' The variables are as follows:
#'
#' @format A tibble with 200 rows and 3 variables:
#' \describe{
#'   \item{PSC}{Contract identifier for each product and service}
#'   \item{x_attribute}{x attribute score, from 1 (worst) to 5 (best) in .01 increments}
#'   \item{y_attribute}{y attribute score, from 1 (worst) to 10 (best) in .01 increments}
#' }
#'
"psc"
