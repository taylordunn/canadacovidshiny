#' COVID-19 report
#'
#' A data frame containing aggregated reports over time for COVID-19 in Canada.
#' Reports consist of the following counts:
#' cases, fatalities, tests, hospitalizations, criticals, recoveries,
#' vaccinations, and boosters.
#' The data was retrieved from the Canadian COVID-19 tracker on 2022-01-13 via
#' the `canadacovid` package and the `get_reports()` function.
#'
#' @format A tibble with 720 rows and 22 variables.
#'
#' @source \url{https://api.covid19tracker.ca/}
"overall_report"
