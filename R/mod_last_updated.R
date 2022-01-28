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
      solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = 12,
      fluidRow(
        column(4,
          htmlOutput(ns("last_updated")),
        )
      )
    )
  )
}

#' last_updated server function
#'
#' @noRd
#'
#' @importFrom rlang .env .data
#' @importFrom dplyr filter anti_join pull
#' @importFrom canadacovid get_provinces get_reports
#' @importFrom lubridate with_tz
mod_last_updated_server <- function(id, provinces, reports) {
  moduleServer(id, function(input, output, session) {
    output$last_updated <- renderUI({
      if (id == "overall") {
        d_prov <- ""
      } else {
        d_prov <- provinces() %>% dplyr::filter(code == .env$id) %>%
          dplyr::pull(.data$updated_at) %>%
          lubridate::with_tz(tzone = province_timezones[[id]]) %>%
          format(usetz = TRUE)
        d_prov <- paste0(
          "Data from the province was last reported at: ", d_prov, ".<br>"
        )
      }

      d_api <- reports[[id]]() %>%
        dplyr::pull(.data$last_updated) %>%
        unique() %>%
        lubridate::with_tz(tzone = province_timezones[[id]]) %>%
        format(usetz = TRUE)

      HTML(paste0(
        d_prov,
        "Data from the API was last updated at: ", d_api, "."
      ))
    })
  })
}

