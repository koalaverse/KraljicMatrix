#' Multi-attribute value function
#'
#' \code{MAVF_score} computes the multi-attribute value score of \code{x} and \code{y}
#' given their respective weights
#'
#' @param x Numeric vector of values
#' @param y Numeric vector of values with compatible dimensions to \code{x}
#' @param x_wt Swing weight for \code{x}
#' @param y_wt Swing weight for \code{y}
#'
#' @return A vector of the same length as \code{x} and \code{y} with the multi-attribute value scores
#'
#' @seealso
#'
#' \code{\link{MAVF_sensitivity}} to perform sensitivity analysis with a range of \code{x} and \code{y} swing weights
#'
#' \code{\link{SAVF_score}} for computing the exponential single attribute value score
#'
#' @examples
#'
#' # Given the following \code{x} and \code{y} attribute values with \code{x} and
#' # \code{y} swing weight values of 0.65 and 0.35 respectively, we can compute
#' # the multi-attribute utility score:
#'
#' x_attribute <- c(0.92, 0.79, 1.00, 0.39, 0.68, 0.55, 0.73, 0.76, 1.00, 0.74)
#' y_attribute <- c(0.52, 0.19, 0.62, 1.00, 0.55, 0.52, 0.53, 0.46, 0.61, 0.84)
#'
#' MAVF_score(x_attribute, y_attribute, x_wt = .65, y_wt = .35)
#'
#'
#' @export

MAVF_score <- function(x, y, x_wt, y_wt){

  # return error if x and y are different lengths
  if(length(x) != length(y)){
    stop("`x` and `y` must be the same length", call. = FALSE)
  }

  # return error if x or y weights are not a single value
  if (length(x_wt) != 1 | length(y_wt) != 1) {
    stop("x and y weights must be numeric values of length 1", call. = FALSE)
  }

  x * x_wt + y * y_wt + (1 - x_wt - y_wt) * x * y

}

#' Multi-attribute value function sensitivity analysis
#'
#' \code{MAVF_sensitivity} computes summary statistics for multi-attribute value
#' scores of \code{x} and \code{y} given a range of swing weights for each attribute
#'
#' @param data A data frame
#' @param x Variable from data frame to represent \code{x} attribute values
#' @param y Variable from data frame to represent \code{y} attribute values
#' @param x_wt_min Lower bound anchor point for \code{x} attribute swing weight
#' @param x_wt_max Upper bound anchor point for \code{x} attribute swing weight
#' @param y_wt_min Lower bound anchor point for \code{y} attribute swing weight
#' @param y_wt_max Upper bound anchor point for \code{y} attribute swing weight
#'
#' @return A data frame with added variables consisting of sensitivity analysis
#' summary statistics for each product or service (row).
#'
#' @details The sensitivity analysis performs a Monte Carlo simulation with 1000
#' trials for each product or service (row). Each trial randomly selects a weight
#' from a uniform distribution between the lower and upper bound weight parameters
#' and calculates the mult-attribute utility score. From these trials, summary
#' statistics for each product or service (row) are calculated and reported for
#' the final output.
#'
#' @seealso
#'
#' \code{\link{MAVF_score}} for computing the multi-attribute value score of \code{x} and \code{y}
#' given their respective weights
#'
#' \code{\link{SAVF_score}} for computing the exponential single attribute value score
#'
#' @examples
#'
#' # Given the following data frame that contains \code{x} and \code{y} attribute
#' # values for each product or service contract, we can compute how the range of
#' # swing weights for each \code{x} and \code{y} attribute influences the multi-
#' # attribute value score.
#'
#' df <- data.frame(contract = 1:10,
#'                  x_attribute = c(0.92, 0.79, 1.00, 0.39, 0.68, 0.55, 0.73, 0.76, 1.00, 0.74),
#'                  y_attribute = c(0.52, 0.19, 0.62, 1.00, 0.55, 0.52, 0.53, 0.46, 0.61, 0.84))
#'
#' MAVF_sensitivity(df, x_attribute, y_attribute, .55, .75, .25, .45)
#'
#' @export

MAVF_sensitivity <- function(data, x, y, x_wt_min, x_wt_max, y_wt_min, y_wt_max){

  # return error if x_wt_min is not less than x_wt_max
  if(x_wt_min >= x_wt_max){
    stop("`x_wt_min` must be less than `x_wt_max`", call. = FALSE)
  }

  # return error if y_wt_min is not less than y_wt_max
  if(y_wt_min >= y_wt_max){
    stop("`y_wt_min` must be less than `y_wt_max`", call. = FALSE)
  }

  # create random wts
  x_wt <- stats::runif(1000, min = x_wt_min, max = x_wt_max)
  y_wt <- stats::runif(1000, min = y_wt_min, max = y_wt_max)
  w_wt <- 1 - x_wt - y_wt

  # return error if x or y columns are not in data frame
  if(!deparse(substitute(x)) %in% names(data) | !deparse(substitute(y)) %in% names(data)) {
    stop("`x` and `y` must both be a variable of the supplied data frame", call. = FALSE)
  }

  # parse out vectors from data
  x_col <- data[[deparse(substitute(x))]]
  y_col <- data[[deparse(substitute(y))]]

  # create vectors to fill
  Min. <- vector(mode = "numeric", length = nrow(data))
  `1st Qu.` <- vector(mode = "numeric", length = nrow(data))
  Median <- vector(mode = "numeric", length = nrow(data))
  Mean <- vector(mode = "numeric", length = nrow(data))
  `3rd Qu.` <- vector(mode = "numeric", length = nrow(data))
  Max. <- vector(mode = "numeric", length = nrow(data))
  Range <- vector(mode = "numeric", length = nrow(data))

  # loop through to compute values for each x y pair
  for(i in 1:nrow(data)){
    s <- summary(x_col[i] * x_wt + y_col[i] * y_wt + (1 - x_wt - y_wt) * x_col[i] * y_col[i])
    Min.[i] <- s[1]
    `1st Qu.`[i] <- s[2]
    Median[i] <- s[3]
    Mean[i] <- s[4]
    `3rd Qu.`[i] <- s[5]
    Max.[i] <- s[6]
    Range[i] <- s[6] - s[1]
  }

  # add new columns
  data$MAVF_Min <- Min.
  data$MAVF_1st_Q <- `1st Qu.`
  data$MAVF_Median <- Median
  data$MAVF_Mean <- Mean
  data$MAVF_3rd_Q <- `3rd Qu.`
  data$MAVF_Max <- Max.
  data$MAVF_Range <- Range


  # return data
  data

}

