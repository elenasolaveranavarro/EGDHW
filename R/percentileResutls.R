#' Totals and shares by percentiles
#'
#' Compute distributional wealth estimates by percentile group. Wrapper function
#' that applies the percentiles function across all deciles
#' (or custom percentile breakdowns) to provide a complete distributional analysis.
#'
#' @param x Variable of interest for which to calculate distributional results
#' @param ord Ordering variable used to rank observations
#' @param weight Survey weight variable
#' @param data Data frame containing the microdata
#' @param breakdown  Numeric vector defining percentile breaks. Default creates deciles

percentileResults <- function(x, ord, weight, data, breakdown = seq(0, 1, by = 0.1)) {
  res <- list("total"=c(rep(NA,(length(breakdown)-1))),"share"=c(rep(NA,(length(breakdown)-1))))
  for (i in 2:length(breakdown)) {
    result <- percentiles(x = {{x}}, ord = {{ord}}, weight = {{weight}}, xUp = breakdown[i - 1], xLow = breakdown[i],data = data)

    res$total[i - 1] <- result$total
    res$share[i - 1] <- result$share
  }
  return((res))
}
