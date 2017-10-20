#' Get values on the efficient frontier
#'
#' \code{get_frontier} identifies and extracts the \code{x} and \code{y} values
#' that fall along the efficient frontier.
#'
#' @param data A data frame
#' @param x Numeric vector of values
#' @param y Numeric vector of values
#' @param quadrant Depending on which direction on each axes defines "better",
#' it places the frontier in the appropriate quadrant.
#'
#' @return A Kraljic purchasing matrix plot
#'
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
#' kraljic_matrix(psc2, x_SAVF_score, y_SAVF_score)
#'
#' @export

get_frontier <- function(data, x, y, quadrant = c("top.right", "bottom.right",
                                            "bottom.left", "top.left")) {
  z <- cbind(x, y)
  quadrant <- match.arg(quadrant)
  if (quadrant == "top.right") {
    zz <- z[order(z[, 1L], z[, 2L], decreasing = TRUE), ]
    zz[which(!duplicated(cummax(zz[, 2L]))), ]
  } else if (quadrant == "bottom.right") {
    zz <- z[order(z[, 1L], z[, 2L], decreasing = TRUE), ]
    zz[which(!duplicated(cummin(zz[, 2L]))), ]
  } else if (quadrant == "bottom.left") {
    zz <- z[order(z[, 1L], z[, 2L], decreasing = FALSE), ]
    zz[which(!duplicated(cummin(zz[, 2L]))), ]
  } else {
    zz <- z[order(z[, 1L], z[, 2L], decreasing = FALSE), ]
    zz[which(!duplicated(cummax(zz[, 2L]))), ]
  }
}



