#' Get values on the efficient frontier
#'
#' \code{get_frontier} identifies and extracts the \code{x} and \code{y} values
#' that fall along the user defined efficient frontier.
#'
#' @param data A data frame
#' @param x Numeric vector of values
#' @param y Numeric vector of values
#' @param quadrant Depending on which direction on each axes defines "better",
#' it places the frontier in the appropriate quadrant.
#'
#' @return A data frame with the efficient frontier observations
#'
#' @examples
#'
#' # Given the following \code{x} and \code{y} attribute values we can plot each
#' # product or service in the purchasing matrix:
#' library(dplyr)
#'
#' psc2 <- mutate(psc, x_SAVF_score = SAVF_score(x_attribute, 1, 5, .653),
#'                     y_SAVF_score = SAVF_score(y_attribute, 1, 10, .7))
#'
#' get_frontier(psc2, x_SAVF_score, y_SAVF_score)
#'
#' @export

get_frontier <- function(data, x, y, quadrant = c("top.right", "bottom.right",
                                            "bottom.left", "top.left")) {
  # create subsetted data frame
  x_col <- deparse(substitute(x))
  y_col <- deparse(substitute(y))
  z <- data[, c(x_col, y_col)]

  # check that x and y are numeric inputs
  if(!is.numeric(z[[x_col]]) | !is.numeric(z[[y_col]])){
    stop("data for both column inputs must be numeric", call. = FALSE)
  }

  # extract efficient frontier points
  quadrant <- match.arg(quadrant)
  if (quadrant == "top.right") {

    # order data frame
    zz <- z[order(z[[x_col]], z[[y_col]], decreasing = TRUE), ]

    # identify the efficient frontier & remove duplicates
    frontier <- which(cummax(zz[y_col]) <= zz[y_col])
    frontier <- frontier[!duplicated(zz[frontier, ])]

    # return efficient frontier values
    zz[frontier, ]

  } else if (quadrant == "bottom.right") {

    # order data frame
    zz <- z[order(z[[x_col]], z[[y_col]], decreasing = TRUE), ]

    # identify the efficient frontier & remove duplicates
    frontier <- which(cummin(zz[y_col]) >= zz[y_col])
    frontier <- frontier[!duplicated(zz[frontier, ])]

    # return efficient frontier values
    zz[frontier, ]

  } else if (quadrant == "bottom.left") {

    # order data frame
    zz <- z[order(z[[x_col]], z[[y_col]], decreasing = FALSE), ]

    # identify the efficient frontier & remove duplicates
    frontier <- which(cummin(zz[y_col]) >= zz[y_col])
    frontier <- frontier[!duplicated(zz[frontier, ])]

  } else {
    zz <- z[order(z[, 1L], z[, 2L], decreasing = FALSE), ]
    zz[which(!duplicated(cummax(zz[, 2L]))), ]
  }
}


