#' summary_row UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for `shiny`.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList fluidRow
#' @importFrom shinydashboard valueBoxOutput
mod_summary_row_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      valueBoxOutput(ns("cases")),
      valueBoxOutput(ns("hospitalizations"))
      #valueBoxOutput(ns("fatalities"))
    )
  )
}

#' summary_row Server Functions
#'
#' @noRd
#'
#' @importFrom shinydashboard renderValueBox
mod_summary_row_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    #ns <- session$ns
    data <- reactive(summary_overall)

    output$cases <- renderValueBox({
      valueBox(
        "Cases", data()$change_cases, icon = icon("virus")
      )
    })

    output$hospitalizations <- renderValueBox({
      valueBox(
        "Hospitalizations", data()$change_hospitalizations,
        icon = icon("virus")
      )
    })
  })
}

## To be copied in the UI
# mod_summary_row_ui("summary_row_ui_1")

## To be copied in the server
# mod_summary_row_server("summary_row_ui_1")
