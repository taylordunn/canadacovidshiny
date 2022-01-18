#' last_updated UI function
#'
#' @description A shiny module to display when the data has last been updated.
#'
#' @param id,input,output,session Internal parameters for `shiny`.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_last_updated_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(
      title = span(icon("info-circle"), "Data last updated"),
      #solidHeader = TRUE,
      collapsible = TRUE, width = 12,
      textOutput(ns("last_updated"))
    )
  )
}

#' last_updated server function
#'
#' @noRd
#'
#' @importFrom rlang .env
mod_last_updated_server <- function(id, provinces) {
  #d <- reactive(provinces() %>% dplyr::filter(province == toupper(id)))

  moduleServer(id, function(input, output, session) {
    #output$last_updated <- renderUI({
    output$last_updated <- renderText({
      d <- provinces() %>% dplyr::filter(code == .env$id)

      paste0(
        "Data from the province last updated at ",
        d$updated_at, " (status: ", d$data_status, ")"
      )
    })
  })
}

## To be copied in the UI
# mod_last_updated_ui("last_updated_ui_1")

## To be copied in the server
# mod_last_updated_server("last_updated_ui_1")
