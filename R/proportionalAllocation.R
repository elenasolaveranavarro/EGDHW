#' Proportional Allocation
#'
#' @description
#' Adjusts microdata values to align with macroeconomic totals using proportional
#' scaling within each multiple imputation.
#'
#' The function groups data for each implicate. Then, it:
#'
#' 1. Calculates the weighted total of the microdata variable
#' 2. Scales each observation proportionally so the weighted total matches the macro
#' target, preserving the relative distribution of the original microdata
#'
#' @details
#' The notation .x and .w in dplyr creates new columns in the dataframe with the
#' names from those objects
#'
#'
#' @param x: Vector or variable containing the microdata values to be scaled
#' @param macro_value: Scalar value representing the macroeconomic aggregate target.
#'   If NA, the function returns normalized shares (proportions summing to 1)
#' @param weight: Survey weight variable
#' @param data: Data frame containing the micro data
#'
#' @return scaled data for each multiple imputation
#'
#' @export

proportionalAllocation <- function(x, macro_value, weight, data) {
  data <- data %>%
    mutate(.x = x, .w = weight) %>%  # keep inputs inside data
    group_by(inum) %>%
    mutate(
      allocated = if (!is.na(macro_value)) {
        macro_value * .x / sum(.x * .w, na.rm = TRUE)
      } else {
        .x / sum(.x * .w, na.rm = TRUE)
      }
    ) %>%
    ungroup()

  return(data$allocated)
}
