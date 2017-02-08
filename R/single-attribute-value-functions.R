#' Single attribute value function
#'
#' \code{SAVF_score} computes the exponential single attribute value score of \code{x}
#'
#' @param x Numeric vector of values to score
#' @param x_low Lower bound anchor point (can be different than \code{min(x)})
#' @param x_high Upper bound anchor point (can be different than \code{max(x)})
#' @param rho Exponential constant for the value function
#'
#' @return A vector of the same length as \code{x} with the exponential single attribute value scores
#'
#' @seealso
#'
#' \code{\link{SAVF_plot}} for plotting single attribute scores
#'
#' \code{\link{SAVF_preferred_rho}} for identifying the preferred rho
#'
#' @examples
#'
#' # The single attribute x is bounded between 1 and 5 and follows an exponential
#' # utility curve with rho = .653
#'
#' x <- runif(10, 1, 5)
#' x
#' ## [1] 2.964853 1.963182 1.223949 1.562025 4.381467 2.286030 3.071066
#' ## [8] 4.470875 3.920913 4.314907
#'
#' SAVF_score(x, x_low = 1, x_high = 5, rho = .653)
#' ## [1] 0.7800556 0.5038275 0.1468234 0.3315217 0.9605856 0.6131944 0.8001003
#' ## [8] 0.9673124 0.9189685 0.9553165
#'
#' @export

SAVF_score <- function(x, x_low, x_high, rho){

  # return error if x_low is not less than x_high
  if(x_low >= x_high){
    stop("`x_low` must be less than `x_high`", call. = FALSE)
  }

  # return error if rho is not a single value
  if (length(rho) != 1) {
    stop("`rho` must be a numeric value of length 1", call. = FALSE)
  }

  # generate SAVF values
  value <- (1 - exp(-rho * (x - x_low))) / (1 - exp(-rho * (x_high - x_low)))

  # return values
  return(value)

}


#' Identify preferred rho
#'
#' \code{SAVF_preferred_rho} computes the preferred rho that minimizes the
#' squared error between subject matter input desired values and exponentially
#' fitted scores
#'
#'
#' @param desired_x Elicited input x value(s)
#' @param desired_v Elicited value score related to elicited input value(s)
#' @param x_low Lower bound anchor point (can be different than \code{min(x)})
#' @param x_high Upper bound anchor point (can be different than \code{max(x)})
#' @param rho_low Lower bound of the exponential constant search space for a best fit value function
#' @param rho_high Upper bound of the exponential constant search space for a best fit value function
#'
#' @return A single element vector that represents the rho value that best fits the exponential utility function to the desired inputs
#'
#' @seealso
#'
#' \code{\link{SAVF_plot_rho_error}} for plotting the rho squared error terms
#'
#' \code{\link{SAVF_score}} for computing the exponential single attribute value score
#'
#' @examples
#'
#' # Given the single attribute x is bounded between 1 and 5 and the subject matter experts
#' # prefer x values of 3, 4, & 5 provide a utility score of .75, .90 & 1.0 respectively, we
#' # can search for a rho value between 0-1 that provides the best fit utility function:
#'
#' SAVF_preferred_rho(desired_x = c(3, 4, 5),
#'                    desired_v = c(.75, .9, 1),
#'                    x_low = 1,
#'                    x_high = 5,
#'                    rho_low = 0,
#'                    rho_high = 1)
#'
#' @export
SAVF_preferred_rho <- function(desired_x, desired_v, x_low, x_high, rho_low = 0, rho_high = 1){

  # return error if x_low is not less than x_high
  if(x_low >= x_high){
    stop("`x_low` must be less than `x_high`", call. = FALSE)
  }

  # return error if rho_low is not less than rho_high
  if(rho_low >= rho_high){
    stop("`rho_low` must be less than `rho_high`", call. = FALSE)
  }

  # compute sequence of rho values
  rho <- seq(rho_low, rho_high, by = (rho_high - rho_low) / 10000)
  rho <- rho[rho != 0]

  # compute deltas between preferred and fitted values
  delta <- sapply(rho, function(x) sum((SAVF_score(desired_x, x_low, x_high, x) - desired_v)^2))

  # return rho that produces smallest error
  true_rho <- rho[which(delta == min(delta))]

  # return values
  return(true_rho)

}

#' Plot the rho squared error terms
#'
#' \code{SAVF_plot_rho_error} plots the squared error terms for the rho search
#' space to illustrate the preferred rho that minimizes the squared error
#' between subject matter desired values and exponentially fitted scores
#'
#' @param desired_x Elicited input x value(s)
#' @param desired_v Elicited value score related to elicited input value(s)
#' @param x_low Lower bound anchor point (can be different than \code{min(x)})
#' @param x_high Upper bound anchor point (can be different than \code{max(x)})
#' @param rho_low Lower bound of the exponential constant search space for a best fit value function
#' @param rho_high Upper bound of the exponential constant search space for a best fit value function
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 aes
#'
#' @return A plot that visualizes the squared error terms for the rho search space
#'
#' @seealso
#'
#' \code{\link{SAVF_preferred_rho}} for identifying the preferred rho value
#'
#' \code{\link{SAVF_score}} for computing the exponential single attribute value score
#'
#' @examples
#'
#' # Given the single attribute x is bounded between 1 and 5 and the subject matter experts
#' # prefer x values of 3, 4, & 5 provide a utility score of .75, .90 & 1.0 respectively, we
#' # can visualize the error terms for rho values between 0-1:
#'
#' SAVF_plot_rho_error(desired_x = c(3, 4, 5),
#'                     desired_v = c(.75, .9, 1),
#'                     x_low = 1,
#'                     x_high = 5,
#'                     rho_low = 0,
#'                     rho_high = 1)
#'
#' @export
SAVF_plot_rho_error <- function(desired_x, desired_v, x_low, x_high, rho_low = 0, rho_high = 1){

  # return error if x_low is not less than x_high
  if(x_low >= x_high){
    stop("`x_low` must be less than `x_high`", call. = FALSE)
  }

  # return error if rho_low is not less than rho_high
  if(rho_low >= rho_high){
    stop("`rho_low` must be less than `rho_high`", call. = FALSE)
  }

  # compute sequence of rho values
  rho <- seq(rho_low, rho_high, by = (rho_high - rho_low) / 10000)
  rho <- rho[rho != 0]

  # compute deltas between preferred and fitted values
  delta <- sapply(rho, function(x) sum((SAVF_score(desired_x, x_low, x_high, x) - desired_v)^2))

  # return rho that produces smallest error
  true_rho <- rho[which(delta == min(delta))]

  # plot value
  df <- data.frame(rho = rho, delta = delta)
  ggplot2::ggplot(df, ggplot2::aes(rho, delta)) +
    ggplot2::geom_line() +
    ggplot2::geom_point(ggplot2::aes(true_rho, min(delta)), shape = 23, size = 2, fill = "white")

}


#' Plot the single attribute value curve
#'
#' \code{SAVF_plot} plots the single attribute value curve along with the
#' subject matter desired values for comparison
#'
#' @param desired_x Elicited input x value(s)
#' @param desired_v Elicited value score related to elicited input value(s)
#' @param x_low Lower bound anchor point (can be different than \code{min(x)})
#' @param x_high Upper bound anchor point (can be different than \code{max(x)})
#' @param rho Exponential constant for the value function
#'
#' @return A plot that visualizes the single attribute value curve along with the
#' subject matter desired values for comparison
#'
#' @seealso
#'
#' \code{\link{SAVF_plot_rho_error}} for plotting the rho squared error terms
#'
#' \code{\link{SAVF_score}} for computing the exponential single attribute value score
#'
#' @examples
#'
#' # Given the single attribute x is bounded between 1 and 5 and the subject matter experts
#' # prefer x values of 3, 4, & 5 provide a utility score of .75, .90 & 1.0 respectively,
#' # the preferred rho is 0.54. We can visualize this value function:
#'
#' SAVF_plot(desired_x = c(3, 4, 5),
#'           desired_v = c(.75, .9, 1),
#'           x_low = 1,
#'           x_high = 5,
#'           rho = 0.54)
#'
#' @export

SAVF_plot <- function(desired_x, desired_v, x_low, x_high, rho){

  # return error if x_low is not less than x_high
  if(x_low >= x_high){
    stop("`x_low` must be less than `x_high`", call. = FALSE)
  }

  # return error if rho is not a single value
  if (length(rho) != 1) {
    stop("`rho` must be a numeric value of length 1", call. = FALSE)
  }

  # create string of x values
  x <- seq(x_low, x_high, by = (x_high - x_low) / 1000)
  v <- SAVF_score(x, x_low, x_high, rho)

  # create data frames to plot
  df <- data.frame(x = x, v = v)
  desired <- data.frame(x = desired_x, v = desired_v)

  ggplot2::ggplot(df, ggplot2::aes(x, v)) +
    ggplot2::geom_line() +
    ggplot2::geom_point(data = desired, ggplot2::aes(x, v), shape = 23, size = 2, fill = "white")

}
