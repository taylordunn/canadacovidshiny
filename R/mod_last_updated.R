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
      textOutput(ns("last_updated")),
      actionButton(ns("check_updated"), "Check for new data")
    )
  )
}

#' last_updated server function
#'
#' @noRd
#'
#' @importFrom rlang .env
mod_last_updated_server <- function(id, provinces, reports) {
  moduleServer(id, function(input, output, session) {
    output$last_updated <- renderText({
      d <- provinces() %>% dplyr::filter(code == .env$id)

      paste0(
        "Data from the province last updated at ",
        d$updated_at, " (status: ", d$data_status, ")"
      )
    })

    observeEvent(input$check_updated, {
      provinces_new <- canadacovid::get_provinces()

      # Compare the `updated_at` timestamps to determine which provinces have
      #  been updated
      provinces_updated <- provinces_new %>%
        dplyr::anti_join(provinces(), by = c("code", "updated_at")) %>%
        dplyr::pull(code)

      if (length(provinces_updated) > 0) {
        provinces(provinces_new)

        # Update the reports of all the new data
        for (p in provinces_updated) {
          reports[[p]](canadacovid::get_reports(province = p))
        }
        # Update the overall data
        reports$overall(canadacovid::get_reports("overall"))
      }
    })
  })
}

