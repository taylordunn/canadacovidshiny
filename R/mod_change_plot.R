#' change_plot UI function
#'
#' @description A shiny module to plot the change in a single variable
#'   over time.
#'
#' @param id,input,output,session Internal parameters for `shiny`.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_change_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("change_plot"), height = 200)
  )
}

#' change_plot server function
#'
#' @noRd
mod_change_plot_server <- function(id, reports_data, var) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    browser()

    output$change_plot <- renderPlot({
      plot_change(reports_data(), var, rolling_window = 7)
    })
  })
}

#' change_plot UI function
#'
#' @noRd
mod_change_plot_box_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(
      title = span(icon("chart-line"), "Change per day"),
      collapsible = TRUE, width = 6,
      plotOutput(ns("change_plot_1"), height = 150),
      plotOutput(ns("change_plot_2"), height = 150),
      plotOutput(ns("change_plot_3"), height = 150)
    )
  )
}

#' change_plot server function
#'
#' @noRd
mod_change_plot_box_server <- function(id, reports_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$change_plot_1 <- renderPlot({
      plot_change(reports_data(), "cases", rolling_window = 7)
    })
    output$change_plot_2 <- renderPlot({
      plot_change(reports_data(), "hospitalizations", rolling_window = 7)
    })
    output$change_plot_3 <- renderPlot({
      plot_change(reports_data(), "criticals", rolling_window = 7)
    })
  })
}
