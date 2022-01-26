#' daily_counts UI function
#'
#' @description A shiny module. Shows the latest data (cases, hospitalizations,
#'   criticals, fatalities, vaccinations, and boosters).
#'
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
#'
#' @importFrom shiny NS tagList fluidRow icon span
#' @importFrom shinydashboard box valueBoxOutput
mod_daily_counts_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(
      title = span(icon("table"), "Daily counts"),
      collapsible = TRUE, width = 9,
      valueBoxOutput(ns("cases")),
      valueBoxOutput(ns("hospitalizations")),
      valueBoxOutput(ns("criticals")),
      valueBoxOutput(ns("fatalities")),
      valueBoxOutput(ns("vaccinations")),
      valueBoxOutput(ns("boosters_1"))
    )
  )
}

#' daily_counts server function
#'
#' @param reports_data The day-to-day reports data frame, either overall or for
#'   a single province.
#' @noRd
#'
#' @importFrom shinydashboard renderValueBox valueBox
#' @importFrom dplyr filter mutate
#' @importFrom scales comma
#' @importFrom purrr map walk
mod_daily_counts_server <- function(id, reports_data) {
  # Get the most recent numbers
  data <- reactive(
    reports_data() %>%
      dplyr::filter(date == max(date))
  )
  vars <- c("cases", "hospitalizations", "criticals", "fatalities",
            "vaccinations", "boosters_1")
  var_labels <- list(
    "cases" = "Cases (estimated active)",
    "hospitalizations" = "Hospitalizations (total)",
    "criticals" = "Criticals (total)",
    "fatalities" = "Fatalities (total)",
    "vaccinations" = "Vaccinations (total)",
    "boosters_1" = "Boosters (total)"
  )
  var_counts <- purrr::map(
    vars,
    function(var) {
      reactive({
        primary_count <- scales::comma(data()[[paste0("change_", var)]])
        if (var == "cases") {
          # Report current active cases instead of cumulative
          secondary_count <- scales::comma(data()[["total_active"]])
        } else {
          secondary_count <- scales::comma(data()[[paste0("total_", var)]])
        }
        paste0(primary_count, " (", secondary_count, ")")
      })
    }
  ) %>%
    stats::setNames(vars)


  moduleServer(id, function(input, output, session) {
    purrr::walk(
      vars,
      function(var) {
        output[[var]] <- renderValueBox({
          valueBoxCustom(
            var_counts[[var]](),
            subtitle = var_labels[[var]],
            background = var_colors_pastel[[var]],
            icon = var_icons[[var]]
          )
        })
      })
  })
}
