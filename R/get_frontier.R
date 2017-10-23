#' Compute the Pareto Frontier
#'
#' Extract the points that make up the pareto frontier from a set of data.
#'
#' @param x A data frame or numeric vector.
#'
#' @param y A numeric vector.
#'
#' @param quadrant Chararacter string specifying which quadrant the frontier
#' should appear in. Default is \code{"top.right"}.
#'
#' @return A data frame containing the data points that make up the efficient
#' frontier.
#'
#' @export
get_frontier <- function(x, y, quadrant = c("top.right", "bottom.right",
                                            "bottom.left", "top.left")) {
  UseMethod("get_frontier")
}


#' @rdname get_frontier
#'
#' @export
get_frontier.data.frame <- function(x, y,
                                    quadrant = c("top.right", "bottom.right",
                                                 "bottom.left", "top.left"))
{
  get_frontier.default(x[[1L]], x[[2L]], quadrant = quadrant)
}


#' @rdname get_frontier
#'
#' @export
get_frontier.default <- function(x, y, quadrant = c("top.right", "bottom.right",
                                                    "bottom.left", "top.left"))
{
  z <- cbind(x, y)
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
