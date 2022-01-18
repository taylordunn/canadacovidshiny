#' The application server-side
#'
#' @param input,output,session Internal parameters for `shiny`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom purrr map walk
#' @noRd
app_server <- function(input, output, session) {
  provinces <- reactive(read_provinces())
  reports_overall <- reactive(read_reports("overall"))

  reports_province <- purrr::map(
    province_codes, ~ reactive(read_reports(.x))
  ) %>%
    setNames(province_codes)

  mod_daily_counts_server("overall", reports_overall)

  purrr::walk(
    province_codes,
    ~{
      mod_last_updated_server(.x, provinces)
      mod_daily_counts_server(.x, reports_province[[.x]])
    }
  )
}
