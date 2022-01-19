#' The application server-side
#'
#' @param input,output,session Internal parameters for `shiny`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom purrr map walk
#' @noRd
app_server <- function(input, output, session) {
  board <- register_github_board()
  set_plotting_defaults()

  provinces <- reactiveVal(read_provinces())

  reports <- purrr::map(
    c("overall", province_codes),
    ~ reactiveVal(read_reports(.x))
  ) %>%
    setNames(c("overall", province_codes))

  mod_daily_counts_server("overall", reports$overall)
  mod_change_plot_server("overall", reports$overall)
  purrr::walk(
    province_codes,
    ~{
      mod_last_updated_server(.x, provinces, reports)
      mod_daily_counts_server(.x, reports[[.x]])
      #mod_change_plot_server(.x, reports[[.x]])
    }
  )
}
