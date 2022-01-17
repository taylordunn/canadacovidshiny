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
mod_summary_row_server <- function(id, summary_data) {
  #stopifnot(is.reactive(data))

  moduleServer(id, function(input, output, session) {
    cases_text <- reactive(summary_data()$change_case)
    hospitalizations_text <- reactive(data()$change_hospitalizations)

    output$cases <- renderValueBox({
      valueBox(
        "Cases", cases_text(), icon = icon("virus")
      )
    })

    output$hospitalizations <- renderValueBox({
      valueBox(
        "Hospitalizations", hospitalizations_text(),
        icon = icon("virus")
      )
    })
  })
}

## To be copied in the UI
# mod_summary_row_ui("summary_row_ui_1")

## To be copied in the server
# mod_summary_row_server("summary_row_ui_1")
