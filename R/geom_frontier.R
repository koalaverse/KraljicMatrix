#' Get values on the efficient frontier
#'
#' \code{get_frontier} identifies and extracts the \code{x} and \code{y} values
#' that fall along the user defined efficient frontier. The efficient frontier
#' can be defined by a combination of large \code{x} and large \code{y} values,
#' large \code{x} and small \code{y} values, small \code{x} and large \code{y}
#' values, or small \code{x} and small \code{y} values.
#'
#' @param data A data frame
#' @param x Numeric vector of values
#' @param y Numeric vector of values
#' @param quadrant Depending on which direction on each axes defines "better",
#' it places the frontier in the appropriate quadrant. For example, if large
#' \code{x} and large \code{y} values are considered "better" then the default
#' "top.right" is appropriate.  If small \code{x} and small \code{y} are
#' considered "better" then "bottom.left" is appropriate.
#' @param decreasing logical. Should the sort order be increasing or decreasing?
#'
#' @return A data frame with the efficient frontier observations.
#'
#' @seealso
#'
#' \code{\link{geom_frontier}} for plotting the efficient frontier.
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

get_frontier <- function(data, x, y,
                         quadrant = c("top.right", "bottom.right",
                                            "bottom.left", "top.left"),
                         decreasing = TRUE) {
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
    frontier <- cummax(zz[y_col])
    frontier <- which(!duplicated(frontier))

    # return efficient frontier values
    zz <- zz[frontier, ]
    zz[order(zz[[x_col]], zz[[y_col]], decreasing = decreasing), ]

  } else if (quadrant == "bottom.right") {

    # order data frame
    zz <- z[order(z[[x_col]], z[[y_col]], decreasing = TRUE), ]

    # identify the efficient frontier for y values & remove duplicates
    frontier <- cummin(zz[y_col])
    frontier <- which(!duplicated(frontier))

    # return efficient frontier values
    zz <- zz[frontier, ]

    # remove any duplicate x values
    zz <- zz[order(zz[[y_col]], zz[[x_col]], decreasing = FALSE), ]
    frontier_x <- cummax(zz[x_col])
    frontier_x <- which(!duplicated(frontier_x))

    # return efficient frontier values in appropriate order
    zz <- zz[frontier_x, ]
    zz[order(zz[[x_col]], zz[[y_col]], decreasing = decreasing), ]

  } else if (quadrant == "bottom.left") {

    # order data frame
    zz <- z[order(z[[x_col]], z[[y_col]], decreasing = FALSE), ]

    # identify the efficient frontier & remove duplicates
    frontier <- cummin(zz[y_col])
    frontier <- which(!duplicated(frontier))

    # return efficient frontier values
    zz <- zz[frontier, ]
    zz[order(zz[[x_col]], zz[[y_col]], decreasing = decreasing), ]

  } else {

    # order data frame
    zz <- z[order(z[[x_col]], z[[y_col]], decreasing = FALSE), ]

    # identify the efficient frontier & remove duplicates
    frontier <- cummax(zz[y_col])
    frontier <- which(!duplicated(frontier))

    # return efficient frontier values
    zz <- zz[frontier, ]

    # remove any duplicate x values
    zz <- zz[order(zz[[y_col]], zz[[x_col]], decreasing = TRUE), ]
    frontier_x <- cummin(zz[x_col])
    frontier_x <- which(!duplicated(frontier_x))

    # return efficient frontier values in descending order
    zz <- zz[frontier_x, ]
    zz[order(zz[[x_col]], zz[[y_col]], decreasing = decreasing), ]
  }
}


#' Plot values on the efficient frontier with a ggplot2 object
#'
#' \code{geom_frontier} plots the \code{x} and \code{y} values
#' that fall along the user defined efficient frontier. The efficient frontier
#' can be defined by a combination of large \code{x} and large \code{y} values,
#' large \code{x} and small \code{y} values, small \code{x} and large \code{y}
#' values, or small \code{x} and small \code{y} values.
#'
#' @param mapping Set of aesthetic mappings created by \code{aes()} or
#'   \code{aes()}. If specified and `inherit.aes = TRUE` (the
#'   default), it is combined with the default mapping at the top level of the
#'   plot. You must supply `mapping` if there is no plot mapping.
#' @param data The data to be displayed in this layer. There are three
#'    options:
#'
#'    If `NULL`, the default, the data is inherited from the plot
#'    data as specified in the call to `ggplot()`.
#'
#'    A `data.frame`, or other object, will override the plot
#'    data. All objects will be fortified to produce a data frame. See
#'    [fortify()] for which variables will be created.
#'
#'    A `function` will be called with a single argument,
#'    the plot data. The return value must be a `data.frame.`, and
#'    will be used as the layer data.
#' @param x Numeric vector of values
#' @param y Numeric vector of values
#' @param quadrant Depending on which direction on each axes defines "better",
#' it places the frontier in the appropriate quadrant. For example, if large
#' \code{x} and large \code{y} values are considered "better" then the default
#' "top.right" is appropriate.  If small \code{x} and small \code{y} are
#' considered "better" then "bottom.left" is appropriate.
#' @param direction direction of stairs: 'vh' for vertical then horizontal, or
#' 'hv' for horizontal then vertical
#' @param ... other arguments passed on to layer. These are often aesthetics,
#' used to set an aesthetic to a fixed value, like `color = "red"` or `size = 3`.
#'
#' @section Aesthetics:
#'
#' `geom_frontier` understands the following aesthetics:
#'     \enumerate{
#'       \item \code{x}:
#'       \item \code{y}:
#'       \item \code{alpha}:
#'       \item \code{color}:
#'       \item \code{linetype}:
#'       \item \code{Size}:
#'     }
#'
#' @seealso
#'
#' \code{\link{geom_frontier}} for identifying and extracting the observations that
#' lie along the efficient frontier.
#'
#' @examples
#'
#' @rdname geom_frontier

geom_frontier <- function(mapping = NULL, data = NULL, stat = "identity",
                          position = "identity", direction = "vh",
                          na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomFrontier,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      direction = direction,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomFrontier <- ggproto("GeomFrontier", GeomStep,
                        setup_data = function(data, direction = "hv") {
                          data <- get_frontier(data, x, y)
                          data$PANEL = 1
                          data$group = -1
                          data[order(data$PANEL, data$group, data$x), ]
                        }
)
