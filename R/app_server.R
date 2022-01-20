#' The application server-side
#'
#' @param input,output,session Internal parameters for `shiny`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom purrr map walk set_names
#' @noRd
app_server <- function(input, output, session) {
  board <- register_github_board()
  set_plotting_defaults()

  provinces <- reactiveVal(read_provinces())
  # Get current population of each province
  population_data <- purrr::map(
    purrr::set_names(c(province_codes, "overall")),
    function(p) {
      if (p == "overall") {
        reactiveVal(sum(provinces()$population))
      } else {
        reactiveVal({
          provinces() %>% dplyr::filter(code == p) %>% dplyr::pull(population)
        })
      }
    }
  )

  reports <- purrr::map(
    purrr::set_names(c(province_codes, "overall")),
    ~ reactiveVal(read_reports(.x))
  )

  mod_daily_counts_server("overall", reports$overall)
  mod_change_plot_box_server("overall",
                             reports$overall, population_data$overall)

  purrr::walk(
    province_codes,
    function(p) {
      mod_last_updated_server(p, provinces, reports)
      mod_daily_counts_server(p, reports[[p]])
      mod_change_plot_box_server(p, reports[[p]], population_data[[p]])
    }
  )
}
