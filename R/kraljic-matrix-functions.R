#' Kraljic matrix plotting function
#'
#' \code{kraljic_matrix} plots each product or service in the Kraljic purchasing
#' matrix based on the attribute value score of \code{x} and \code{y}
#'
#' @param data A data frame
#' @param x Numeric vector of values
#' @param y Numeric vector of values with compatible dimensions to \code{x}
#'
#' @return A Kraljic purchasing matrix plot
#'
#' @seealso
#'
#' \code{\link{SAVF_score}} for computing the exponential single attribute value
#' score for \code{x} and \code{y}
#'
#' @examples
#'
#' Given the following \code{x} and \code{y} attribute values we can plot each
#' product or service in the purchasing matrix:
#'
#' # to add a new variable while preserving existing data
#' library(dplyr)
#'
#' psc2 <- psc %>%
#'   mutate(x_SAVF_score = SAVF_score(x_attribute, 1, 5, .653),
#'          y_SAVF_score = SAVF_score(y_attribute, 1, 10, .7))
#'
#' kraljic_matrix(psc2, x_SAVF_score, y_SAVF_score)
#'
#' @export

kraljic_matrix <- function(data, x, y){

  # return error if x or y are not numeric values
  x_col <- data[[deparse(substitute(x))]]
  y_col <- data[[deparse(substitute(y))]]

  if(!is.numeric(x_col) | !is.numeric(y_col)){
    stop("data for both column inputs must be numeric", call. = FALSE)
  }

  # plot Kraljic Matrix
  ggplot2::ggplot(data, ggplot2::aes_string(deparse(substitute(x)), deparse(substitute(y)))) +
    ggplot2::geom_point() +
    ggplot2::geom_vline(xintercept = .5) +
    ggplot2::geom_hline(yintercept = .5) +
    ggplot2::coord_cartesian(xlim = c(0,1), ylim = c(0,1)) +
    ggplot2::scale_x_reverse()
}
