
<!-- README.md is generated from README.Rmd. Please edit that file -->

# centralisedapproach

<!-- badges: start -->

<!-- badges: end -->

The goal of centralisedapproach is to provide the tools to produce
distributional household wealth estimates in line with the OECD
centralised approach. It also allows to generate figures to visualize
the main results.

## Installation

You can install the development version of centralisedapproach from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools") #install devtools if not installed
library(devtools)
devtools::install_github("elenasolaveranavarro/EGDHW")
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>       ✔  checking for file 'C:\Users\Sola-veranavarro_E\AppData\Local\Temp\RtmpwnXDQM\remotes51b86d214010\elenasolaveranavarro-EGDHW-ce6b7a7/DESCRIPTION'
#>       ─  preparing 'centralisedapproach':
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>       ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>       ─  building 'centralisedapproach_0.0.0.9000.tar.gz'
#>      
#> 
```

## Step 1: importing national accounts data

This is a basic example which shows you how to load the macro totals
from OECD data explorer for a given country and year.

``` r
library(centralisedapproach)

## Define the country for the analysis (ISO-2, lowercase, for Luxembourg Wealth Study)
country <- "ESP"

## Set the year for analysis. This will be the year for the national accounts and either the year or interpolated year for the survey
year <- 2022

# Working directory
# setwd("...")

# # Use the egdhwNationalAccountsTotals to retrieve the macro data
# var_name <- paste0(country,"_",year) 
# assign(var_name, egdhwNationalAccountsTotals(country,"S1M", year, consolidated = FALSE))
# 
# # Merge predefined dataframe to have all the relevant variable/code pairs
# nationalAccounts <- nationalAccounts %>%
#   left_join(get(paste0(country,"_",year)), by = c("codes" = "series"), copy = TRUE) %>%  
#   mutate(values = OBS_VALUE) %>%
#   select(name, codes, values)
```

## Step 2: compute distributional estimates in LISSY

Access to the LWS microdata is only granted in the online server LISSY.
As such, the script to generate distributional household estimates needs
to be run in LISSY.

Note that we perform certain adjustments to better capture the wealth
distribution. Since the wealthiest households tend to be
underrepresented in survey data, we use a selectivity correction model
to account for this missing households in the micro totals. For more
details, see ParetoGrilli (need to insert link)

``` r
#matching()
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

## Step 3: Visualization

<img src="man/figures/README-pressure-1.png" width="100%" />
