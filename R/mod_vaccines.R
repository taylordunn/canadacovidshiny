#' vaccines UI function
#'
#' @description A shiny module. Shows the latest data for vaccinations and
#'   boosters
#'
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
#'
#' @importFrom shiny NS tagList fluidRow icon span
#' @importFrom shinydashboard box valueBoxOutput
mod_vaccines_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(
      title = span(icon("table"), "Vaccinations"),
      collapsible = TRUE, width = 4,
      fluidRow(valueBoxOutput(ns("vaccinated"), width = 6),
               valueBoxOutput(ns("percent_vaccinated"), width = 6)),
      fluidRow(valueBoxOutput(ns("boosters_1"), width = 6),
               valueBoxOutput(ns("percent_boosters_1"), width = 6)),
    )
  )
}

#' vaccines server function
#'
#' @param reports_data The day-to-day reports data frame, either overall or for
#'   a single province.
#' @noRd
#'
#' @importFrom shinydashboard renderValueBox valueBox
#' @importFrom dplyr filter mutate
#' @importFrom scales comma
#' @importFrom purrr map walk
mod_vaccines_server <- function(id, reports_data, population) {
  data <- reactive(
    reports_data() %>%
      # Get the most recent numbers
      dplyr::filter(date == max(date)) %>%
      dplyr::mutate(percent_vaccinated = total_vaccinated / population(),
                    percent_boosters_1 = total_boosters_1 / population())
  )
  vars <- c("vaccinated", "percent_vaccinated",
            "boosters_1", "percent_boosters_1")
  var_labels <- list(
    "vaccinated" = "People vaccinated (2+ doses)",
    "percent_vaccinated" = "Percentage vaccinated (2+ doses)",
    "boosters_1" = "Booster doses administed",
    "percent_boosters_1" = "Percentage boosted"
  )
  var_counts <- purrr::map(
    vars,
    function(var) {
      reactive({
        if (var %in% c("percent_vaccinated", "percent_boosters_1")) {
          scales::percent(data()[[var]], 0.01)
        } else {
          scales::comma(data()[[paste0("total_", var)]])
        }
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
