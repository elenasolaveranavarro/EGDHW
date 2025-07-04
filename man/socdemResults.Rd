% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/socdemResults.R
\name{socdemResults}
\alias{socdemResults}
\title{Sociodemographics by percentiles}
\usage{
socdemResults(x = nhhmem, ord, weight, data, breakdown = seq(0, 1, by = 0.1))
}
\arguments{
\item{x}{Variable of interest. Default selects number of household members \code{nhhmem}}

\item{ord}{Ordering variable used to rank observations}

\item{weight}{Survey weight variable}

\item{data}{Data frame containing the microdata}

\item{breakdown}{Numeric vector defining percentile breaks. Default creates deciles}
}
\description{
Number of people and households within each percentile range. Useful for understanding whether
the percentile breakdown indeed forms groups of the same size
}
