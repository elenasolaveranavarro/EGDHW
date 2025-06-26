#' Sociodemographics by percentiles
#'
#' Number of people and households within each percentile range. Useful for understanding whether
#' the percentile breakdown indeed forms groups of the same size
#'
#' @param x Variable of interest. Default selects number of household members `nhhmem`
#' @param ord Ordering variable used to rank observations
#' @param weight Survey weight variable
#' @param data Data frame containing the microdata
#' @param breakdown  Numeric vector defining percentile breaks. Default creates deciles

socdemResults <- function(x = nhhmem, ord, weight, data, breakdown = seq(0, 1, by = 0.1)) {
  res <- list("person"=c(rep(NA,(length(breakdown)-1))),"households"=c(rep(NA,(length(breakdown)-1))))

  for (i in 2:length(breakdown)) {
    result <- percentiles(x = {{x}}, ord = {{ord}}, weight = {{weight}}, xUp = breakdown[i - 1], xLow = breakdown[i], data = data)

    res$person[i - 1] <- result$total  # total number of people
    res$households[i - 1] <- result$household # total weight = number of households
  }

  return(res)
}
