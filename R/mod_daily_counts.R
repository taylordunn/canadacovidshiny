#' daily_counts UI function
#'
#' @description A shiny module. Shows the latest data (cases, hospitalizations,
#'   criticals, fatalities, vaccinations, and boosters).
#'
#' @param id,input,output,session Internal parameters for `shiny`.
#' @param reports_data The day-to-day reports data frame, either overall or for
#'   a single province.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList fluidRow icon span
#' @importFrom shinydashboard box valueBoxOutput
mod_daily_counts_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(
      title = span(icon("table"), "Daily counts"),
      collapsible = TRUE, width = 12,
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
#' @noRd
#'
#' @importFrom shinydashboard renderValueBox valueBox
#' @importFrom dplyr filter
#' @importFrom scales comma
mod_daily_counts_server <- function(id, reports_data) {
  # Get the most recent numbers
  data <- reactive(reports_data() %>% dplyr::filter(date == max(date)))

  moduleServer(id, function(input, output, session) {
    #ns <- session$ns
    cases_text <- reactive(
      paste0(scales::comma(data()$change_cases), " (",
             scales::comma(data()$total_cases), ")")
    )
    hospitalizations_text <- reactive(
      paste0(scales::comma(data()$change_hospitalizations), " (",
             scales::comma(data()$total_hospitalizations), ")")
    )
    criticals_text <- reactive(
      paste0(scales::comma(data()$change_criticals), " (",
             scales::comma(data()$total_criticals), ")")
    )
    fatalities_text <- reactive(
      paste0(scales::comma(data()$change_fatalities), " (",
             scales::comma(data()$total_fatalities), ")")
    )
    vaccinations_text <- reactive(
      paste0(scales::comma(data()$change_vaccinations), " (",
             scales::comma(data()$total_vaccinations), ")")
    )
    boosters_1_text <- reactive(
      paste0(scales::comma(data()$change_boosters_1), " (",
             scales::comma(data()$total_boosters_1), ")")
    )

    output$cases <- renderValueBox({
      valueBox(
        cases_text(), "Cases (active)", icon = icon("virus")
      )
    })
    output$hospitalizations <- renderValueBox({
      valueBox(
        hospitalizations_text(), "Hospitalizations (total)",
        icon = icon("hospital")
      )
    })
    output$criticals <- renderValueBox({
      valueBox(
        criticals_text(), "Criticals (total)", icon = icon("procedures")
      )
    })
    output$fatalities <- renderValueBox({
      valueBox(
        fatalities_text(), "Fatalities (total)", icon = icon("coffin")
      )
    })
    output$vaccinations <- renderValueBox({
      valueBox(
        vaccinations_text(), "Vaccinations (total)", icon = icon("syringe")
      )
    })
    output$boosters_1 <- renderValueBox({
      valueBox(
        boosters_1_text(), "Boosters (total)", icon = icon("syringe")
      )
    })
  })
}
