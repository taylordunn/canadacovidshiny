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

  plot_vars <- c("cases", "hospitalizations", "criticals")
  # purrr::iwalk(
  #   plot_vars,
  #   ~mod_change_plot_server(paste0("overall_", .y), reports$overall, .x)
  # )

  purrr::walk(
    province_codes,
    function(p) {
      mod_last_updated_server(p, provinces, reports)
      mod_daily_counts_server(p, reports[[p]])
      #mod_change_plot_box_server(p, reports[[p]])
      # purrr::iwalk(
      #   plot_vars,
      #   ~mod_change_plot_server(paste(p, .y, sep = "_"), reports[[p]], .x)
      # )
    }
  )
  mod_change_plot_box_server("NS", reports[["NS"]])
}
