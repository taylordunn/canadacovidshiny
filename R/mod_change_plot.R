#' change_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_change_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(plotOutput("cases"))
  )
}

#' change_plot Server Functions
#'
#' @noRd
mod_change_plot_server <- function(id, reports) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$cases <- renderPlot({
      plot_change(reports(), var = id, rolling_window = 7)
    })
  })
}
