#' Compute the Pareto Frontier
#'
#' Extract the points that make up the pareto frontier from a set of data.
#'
#' @param x A data frame.
#'
#' @param which.cols If \code{x} is a data frame, then which columns to use in
#' computing the efficient frontier.
#'
#' @param quadrant Chararacter string specifying which quadrant the frontier
#' should appear in. Default is \code{"top.right"}.
#'
#' @return A data frame containing the data points that make up the efficient
#' frontier.
#'
#' @export
get_frontier <- function(x, which.cols = 1:2,
                         quadrant = c("top.right", "bottom.right",
                                      "bottom.left", "top.left")) {
  if (!is.data.frame(x)) {
    stop(deparse(substitute(x)), " is not a data frame.")
  }
  if (length(which.cols) != 2) {
    stop("which.cols should be a vector of length 2.")
  }
  if (is.character(which.cols)) {
    if (!all(which.cols %in% names(x))) {
      stop("Specified columns could not be found in ", deparse(substitute(x)),
           ".")
    }
  }
  z <- x[which.cols]
  quadrant <- match.arg(quadrant)
  res <- if (quadrant == "top.right") {
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
  as.data.frame(res)  # return a data frame
}
