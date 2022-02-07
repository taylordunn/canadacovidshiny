#' The application server-side
#'
#' @param input,output,session Internal parameters for `shiny`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom purrr map walk set_names
#' @importFrom rlang .data
#' @noRd
app_server <- function(input, output, session) {
  board <- register_github_board()
  set_plotting_defaults()

  provinces <- pins::pin_reactive("provinces", board = "github",
                                  interval = 60 * 60 * 1000)

  # Get current population of each province
  population_data <- purrr::map(
    purrr::set_names(c(province_codes, "overall")),
    function(p) {
      if (p == "overall") {
        reactive(sum(provinces()$population))
      } else {
        reactive({
          provinces() %>%
            dplyr::filter(code == p) %>%
            dplyr::pull(.data$population)
        })
      }
    }
  )

  reports <- purrr::map(
    purrr::set_names(c(province_codes, "overall")),
    function(province_code) {
      pins::pin_reactive(paste0("reports_", tolower(province_code)),
                         board = "github", interval = 60 * 60 * 1000)
    }
  )
  purrr::walk(
    c(province_codes, "overall"),
    function(p) {
      mod_last_updated_server(p, provinces, reports)
      mod_daily_counts_server(p, reports[[p]])
      mod_vaccines_server(p, reports[[p]], population_data[[p]])
      mod_change_plot_box_server(p, reports[[p]], population_data[[p]])
      mod_total_plot_box_server(p, reports[[p]], population_data[[p]])
    }
  )
}
