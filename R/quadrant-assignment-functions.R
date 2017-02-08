#' Kraljic quadrant assignment function
#'
#' \code{kraljic_quadrant} assigns the Kraljic purchasing matrix quadrant based
#' on the attribute value score of \code{x} and \code{y}
#'
#' @param x Numeric vector of values
#' @param y Numeric vector of values with compatible dimensions to \code{x}
#'
#' @return A vector of the same length as \code{x} and \code{y} with the relevant
#' Kraljic quadrant name
#'
#' @seealso
#'
#' \code{\link{SAVF_score}} for computing the exponential single attribute value
#' score for \code{x} and \code{y}
#'
#' @examples
#'
#' # Given the following \code{x} and \code{y} attribute values  we can determine
#' # which quadrant each product or service falls in:
#'
#' # to add a new variable while preserving existing data
#' library(dplyr)
#'
#' psc2 <- psc %>%
#'   mutate(x_SAVF_score = SAVF_score(x_attribute, 1, 5, .653),
#'          y_SAVF_score = SAVF_score(y_attribute, 1, 10, .7))
#'
#' psc2 %>%
#'   mutate(quadrant = kraljic_quadrant(x_SAVF_score, y_SAVF_score))
#'
#' @export

kraljic_quadrant <- function(x, y){

  ifelse(x > .5 & y >= .5, "Leverage",
         ifelse(x > .5 & y < .5, "Non-critical",
                ifelse(x <= .5 & y >= .5, "Strategic",
                       ifelse(x < .5 & y < .5, "Bottleneck", NA))))

}
