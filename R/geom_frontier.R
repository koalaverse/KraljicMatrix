#' @keywords internal
StatFrontier <- ggplot2::ggproto("StatFrontier", ggplot2::Stat,
  required_aes = c("x", "y"),
  compute_group = function(data, scales, params, quadrant = "top.right") {
    get_frontier.default(x = data$x, y = data$y, quadrant = quadrant)
  }
)


#' Plotting the Efficient Frontier
#'
#' The frontier geom is used to overlay the efficient frontier on a scatterplot.
#'
#' @param mapping Set of aesthetic mappings created by \code{aes} or
#' \code{aes_}. If specified and \code{inherit.aes = TRUE} (the default), it is
#' combined with the default mapping at the top level of the plot. You must
#' supply mapping if there is no plot mapping.
#'
#' @param data The data to be displayed in this layer.
#'
#' @param position Position adjustment, either as a string, or the result of a
#' call to a position adjustment function.
#'
#' @param na.rm If \code{FALSE}, the default, missing values are removed with a
#' warning. If \code{TRUE}, missing values are silently removed.
#'
#' @param show.legend Logical. Should this layer be included in the legends?
#' \code{NA}, the default, includes if any aesthetics are mapped. \code{FALSE}
#' never includes, and \code{TRUE} always includes.
#'
#' @param inherit.aes If \code{FALSE}, overrides the default aesthetics, rather
#' than combining with them. This is most useful for helper functions that
#' define both data and aesthetics and shouldn't inherit behaviour from the
#' default plot specification, e.g. borders.
#'
#' @param geom Use to override the default connection between
#' \code{geom_frontier} and \code{stat_frontier}.
#'
#' @param quadrant See \code{\link{get_frontier}}.
#'
#' @param ... Other arguments passed on to \code{layer}. These are often
#' aesthetics, used to set an aesthetic to a fixed value, like
#' \code{color = "red"} or \code{size = 3}. They may also be parameters to the
#' paired \code{geom}/\code{stat}.
#'
#' @rdname geom_frontier
#'
#' @export
geom_frontier <- function(mapping = NULL, data = NULL, position = "identity",
                          na.rm = FALSE, show.legend = NA, inherit.aes = TRUE,
                          ...) {
  ggplot2::layer(
    stat = StatFrontier, geom = ggplot2::GeomStep, data = data, mapping = mapping,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}


#' @rdname geom_frontier
#'
#' @export
stat_frontier <- function(mapping = NULL, data = NULL, geom = "step",
                          position = "identity", na.rm = FALSE,
                          show.legend = NA, inherit.aes = TRUE,
                          quadrant = "top.right", ...) {
  ggplot2::layer(
    stat = StatFrontier, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(quadrant = quadrant, ...)
  )
}
