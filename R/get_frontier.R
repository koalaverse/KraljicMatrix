#' Compute the Pareto Optimal Frontier
#'
#' Extract the points that make up the Pareto frontier from a set of data.
#'
#' @param data A data frame.
#'
#' @param x A numeric vector.
#'
#' @param y A numeric vector.
#'
#' @param quadrant Chararacter string specifying which quadrant the frontier
#' should appear in. Default is \code{"top.right"}.
#'
#' @param decreasing Logical value indicating whether the data returned is in
#' decreasing or ascending order (ordered by \code{x} and then \code{y}).
#' Default is decreasing order.
#'
#' @return A data frame containing the data points that make up the efficient
#' frontier.
#'
#' @seealso \code{\link{geom_frontier}} for plotting the Pareto front
#'
#' @examples
#'
#' # default will find the Pareto optimal observations in top right quadrant
#' get_frontier(mtcars, mpg, wt)
#'
#' # the output can be in descending or ascending order
#' get_frontier(mtcars, mpg, wt, decreasing = FALSE)
#'
#' # use quadrant parameter to change how you define the efficient frontier
#' get_frontier(airquality, Ozone, Temp, quadrant = 'top.left')
#'
#' get_frontier(airquality, Ozone, Temp, quadrant = 'bottom.right')
#'
#' @export
get_frontier <- function(data, x, y,
                         quadrant = c("top.right", "bottom.right",
                                      "bottom.left", "top.left"),
                         decreasing = TRUE) {
  if (!is.data.frame(data)) {
    stop(deparse(substitute(x)), " is not a data frame.")
  }

  x_col <- deparse(substitute(x))
  y_col <- deparse(substitute(y))
  z <- data[, c(x_col, y_col)]
  z <- stats::na.omit(z)

  if (!is.numeric(z[[x_col]]) | !is.numeric(z[[y_col]])) {
    stop("both x and y must be numeric variables")
  }

  quadrant <- match.arg(quadrant)
  if (quadrant == "top.right") {
    zz <- z[order(z[, 1L], z[, 2L], decreasing = TRUE), ]
    zz <- zz[which(!duplicated(cummax(zz[, 2L]))), ]
    zz[order(zz[, 1L], zz[, 2L], decreasing = decreasing), ]
  } else if (quadrant == "bottom.right") {
    zz <- z[order(z[, 1L], z[, 2L], decreasing = TRUE), ]
    zz <- zz[which(!duplicated(cummin(zz[, 2L]))), ]
    zz <- zz[which(!duplicated(zz[, 1L])), ]
    zz[order(zz[, 1L], zz[, 2L], decreasing = decreasing), ]
  } else if (quadrant == "bottom.left") {
    zz <- z[order(z[, 1L], z[, 2L], decreasing = FALSE), ]
    zz <- zz[which(!duplicated(cummin(zz[, 2L]))), ]
    zz[order(zz[, 1L], zz[, 2L], decreasing = decreasing), ]
  } else {
    zz <- z[order(z[, 1L], z[, 2L], decreasing = FALSE), ]
    zz <- zz[which(!duplicated(cummax(zz[, 2L]))), ]
    zz <- zz[order(zz[, 1L], zz[, 2L], decreasing = TRUE), ]
    zz <- zz[which(!duplicated(zz[, 1L])), ]
    zz[order(zz[, 1L], zz[, 2L], decreasing = decreasing), ]
  }
}
