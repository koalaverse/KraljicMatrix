#' Pipe functions
#'
#' Like dplyr, KraljicMatrix also uses the pipe function, \code{\%>\%} to turn
#' function composition into a series of imperative statements.
#'
#' @importFrom magrittr %>%
#' @name %>%
#' @rdname pipe
#' @export
#' @param lhs,rhs An R object and a function to apply to it
#' @examples
#'
#' # given the following \code{psc2} data set
#' psc2 <- dplyr::mutate(psc, x_SAVF_score = SAVF_score(x_attribute, 1, 5, .653),
#'                            y_SAVF_score = SAVF_score(y_attribute, 1, 10, .7))
#'
#' # you can use the pipe operator to re-write the following:
#' kraljic_matrix(psc2, x_SAVF_score, y_SAVF_score)
#'
#' # as
#' psc2 %>% kraljic_matrix(x_SAVF_score, y_SAVF_score)
NULL
