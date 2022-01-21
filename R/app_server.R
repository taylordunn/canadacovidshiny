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

  #provinces <- reactiveVal(read_provinces())
  provinces <- reactivePoll(10000, session,
    checkFunc = function() {
      message("Checking provinces.")
      canadacovid::get_provinces() %>% pull(updated_at)
    },
    valueFunc = function() {
      message("Reading and writing provinces table.")
      provinces <- canadacovid::get_provinces()
      write_data(provinces, "provinces")
      provinces
    }
  )

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

  # Whenever provinces is updated, check for new reports
  observeEvent(provinces(), {
    message("Checking for updated province reports...")

    provinces_updated_at <- provinces() %>%
      dplyr::pull(updated_at, name = code)
    provinces_updated_at <-
      c(provinces_updated_at, overall = max(provinces_updated_at))

    purrr::iwalk(reports,
      function(report, p) {
        report_updated_at <- report() %>% dplyr::pull(last_updated) %>% unique()
        if (report_updated_at != provinces_updated_at[[p]]) {
          message("Updating ", p, " (", report_updated_at, ")")

          if (p == "overall") {
            reports[[p]](canadacovid::get_reports(split = "overall"))
          } else {
            reports[[p]](canadacovid::get_reports(province = p))
          }
          #write_data(reports[[p]](), paste0("reports_", p))
        }
      }
    )
  })

  # mod_daily_counts_server("overall", reports$overall)
  # mod_change_plot_box_server("overall",
  #                            reports$overall, population_data$overall)

  purrr::walk(
    c(province_codes, "overall"),
    function(p) {
      mod_last_updated_server(p, provinces, reports)
      mod_daily_counts_server(p, reports[[p]])
      mod_change_plot_box_server(p, reports[[p]], population_data[[p]])
    }
  )
}
