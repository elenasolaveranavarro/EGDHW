#' Percentiles
#'
#' Calculate distributional results for all percentiles. Here we focus on deciles
#' but the percentiles breakdown can be customised. The ordering variable can also be selected
#'
#' Note: raking by ordering variable is computed separately for each multiple imputation.
#' Some households may thus be classified in different percentiles depending on
#' the implicate.
#'
#' @param x Variable of interest for which to calculate decile statistics
#' @param ord Ordering variable used to rank observations.
#' @param weight Survey weight variable
#' @param xUp Upper bound of the Cumulative Distribution Function for a given group. It begins at 0
#' @param xLow Lower bound of the Cumulative Distirbution Function for a given group. It ends at 1 and should be in the range [xUp, 1]
#' @param data Data frame containing the microdata
#' @param imp Survey variable indicating the implicate number from multiple imputation. If not specified, default sets to 1
#'
#' @return a list: total micro value by percentile, relative share owned by each group,
#' and number of households in each percentile
#'
#' @export


percentiles <- function(x, ord, weight, xUp, xLow, data, imp) {

  if (xLow < xUp) {
    message("xUp is the upper bound of the CDF, meaning it begins at 0.
            xLow should therefore be in the range [xUp,1].
            The values have been swapped.")
    temp <- xLow
    xLow <- xUp
    xUp <- temp
  }

  # Check imp parameter. If the user does not specify a multiple imputation variable,
  # we assume that there is only one implicate.
  if (missing(imp)) {
    message("Multiple imputation variable not selected, default set to one implicate")
    data <- data %>%
      mutate(.x = {{x}}, .ord = {{ord}}, .wgt = {{weight}}, .imp = 1)
  } else {
    data <- data %>%
      mutate(.x = {{x}}, .ord = {{ord}}, .wgt = {{weight}}, .imp = {{imp}})
  }

  # Cumulative weight percentiles for each implicate
  results <- data %>%
    dplyr::select(.imp, .x, .ord, .wgt) %>%
    dplyr::group_by(.imp) %>%
    dplyr::group_modify(~ {
      df <- .x %>% arrange(desc(.ord)) # ranking by ordering variable
      sumW <- sum(df$.wgt, na.rm = TRUE) # store total weights
      df$wPercentile <- df$.wgt / sumW # share of total weights
      df$wPercentileShare <- cumsum(df$wPercentile) # share of total weights

      # Make dataframe of the percentile of interest for each implicate
      Upp <- if (xUp <= min(df$wPercentileShare)) 1 else
        which.min(abs(df$wPercentileShare - xUp))
      Low <- if (xLow >= max(df$wPercentileShare)) nrow(df) else
        which.min(abs(df$wPercentileShare - xLow))

      sub_df <- df[Upp:Low, ]

      # Compute key estimates: (1) micrototal for each decile/ group and implicate,
      # (2) micrototal for the entire implicate, (3) decile/ group shares for each item,
      # (4) number of households by decile/ group (sum of the survey weights)
      total_within <- sum(sub_df$.x * sub_df$.wgt, na.rm = TRUE)
      total_full <- sum(df$.x * df$.wgt, na.rm = TRUE)
      shares_dec <- total_within / total_full
      wgt <- sum(sub_df$.wgt, na.rm = TRUE)

      tibble(total_dec = total_within, total_micro = total_full, shares_dec, wgt)
    }) %>%
    dplyr::summarise(total = mean(total_dec), micro = mean(total_micro),
                     nhh = mean(wgt), share = mean(shares_dec), .groups = "drop")

  return(list("total" = results$total, "share" = results$share,
              "household" = results$nhh))
}
