#' Matching
#'
#' Computes coverage ratios and Gini coefficients across multiple imputations.
#'
#' @param micro Vector or variable representing the microdata values
#' @param weight Survey weight variable for population scaling
#' @param macro String name of the corresponding macroeconomic aggregate variable
#' @param stage String indicating the data processing stage. Must be one of:
#'   "initial", "adjusted", "imputed", "aligned", "pareto", "pareto_aligned"
#'
#' This function performs two key calculations
#' 1. **Coverage Ratio**: Compares the weighted sum of microdata to the
#'    corresponding macroeconomic total. Perfect alignment gives a ratio of 1.
#'
#' 2. **Gini Coefficient**: Measures inequality in the distribution using
#'    the bias-corrected weighted Gini coefficient.
#'
#' Both figures are calculated for each imputation separately, then averaged
#' to account for imputation uncertainty. Results are stored in the global object
#' `output`
#'
#' @return the micro variable chosen

matching <- function(micro, weight, macro, stage) {
  if (!(stage %in% c("initial", "adjusted", "imputed", "aligned", "pareto", "pareto_aligned"))) {
    stop("Invalid stage input.")
  }
  df <- micro
  # Coverage ratios for given micro-macro items
  coverage <- dh %>%
    mutate(micro_weighted = (micro * weight)) %>%
    group_by(inum) %>%
    dplyr::summarise(micrototal = sum(micro_weighted, na.rm = TRUE), .groups = "drop") %>%
    dplyr::summarise(coverage = mean(micrototal)/ get(macro))

  # Gini coefficients for given micro-macro items
  gini <- dh %>%
    group_by(inum) %>%
    dplyr::summarise(gini_int = weighted.gini(micro, w = weight)[["bcwGini"]], .groups = "drop") %>%
    dplyr::summarise(gini = mean(gini_int))

  # store into matrix
  output[["coverage"]][stage, macro] <<- coverage$coverage
  output[["gini"]][stage, macro] <<- gini$gini

  return(df)
}
