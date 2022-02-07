#' total_plot UI function
#'
#' @description A shiny module to plot the total in a single variable
#'   over time.
#'
#' @param id,input,output,session Internal parameters for `shiny`.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_total_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("total_plot"), height = 200)
  )
}

#' total_plot server function
#'
#' @noRd
mod_total_plot_server <- function(id, reports_data, var) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$total_plot <- renderPlot({
      plot_total(reports_data(), var, rolling_window = 7)
    })
  })
}

#' total_plot UI function
#'
#' @noRd
#' @importFrom plotly renderPlotly ggplotly
mod_total_plot_box_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(
      title = span(icon("chart-area"), "Total over time"),
      collapsible = TRUE, width = 6,
      plotly::plotlyOutput(ns("total_plot_1"), height = 250),
      plotly::plotlyOutput(ns("total_plot_2"), height = 250),
      plotly::plotlyOutput(ns("total_plot_3"), height = 250),
      fluidRow(
        column(3,
          selectInput(ns("total_var_top"), label = "Top",
                      selected = "hospitalizations", choices = total_plot_vars),
          selectInput(ns("total_var_mid"), label = "Middle",
                      selected = "criticals", choices = total_plot_vars),
          selectInput(ns("total_var_bot"), label = "Bottom",
                      selected = "deaths", choices = total_plot_vars)
        ),
        column(6,
          sliderInput(ns("total_rolling_window"),
                      label = "Rolling average (days)",
                      value = 7, min = 1, max = 30, step = 1, ticks = FALSE),
          dateRangeInput(ns("total_date_range"), label = c("Date range"),
                         start = "2020-01-25", min = "2020-01-25")
        ),
        column(3,
          checkboxInput(ns("total_per_1000"), label = "Per 1000 people", FALSE),
        )
      )
    )
  )
}

#' total_plot server function
#'
#' @noRd
#' @importFrom plotly renderPlotly ggplotly
mod_total_plot_box_server <- function(id, reports_data, population) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    data <- reactive(
      reports_data() %>%
        dplyr::mutate(percent_vaccinated = total_vaccinated / population(),
                      percent_boosters_1 = total_boosters_1 / population())
    )

    output$total_plot_1 <- plotly::renderPlotly({
      plot_total(
        data(), input$total_var_top,
        rolling_window = input$total_rolling_window,
        per_1000 = input$total_per_1000, population = population(),
        min_date = input$total_date_range[1],
        max_date = input$total_date_range[2]
      ) %>% plotly::ggplotly()
    })
    output$total_plot_2 <- plotly::renderPlotly({
      plot_total(
        data(), input$total_var_mid,
        rolling_window = input$total_rolling_window,
        per_1000 = input$total_per_1000, population = population(),
        min_date = input$total_date_range[1],
        max_date = input$total_date_range[2]
      ) %>% plotly::ggplotly()
    })
    output$total_plot_3 <- plotly::renderPlotly({
      plot_total(
        data(), input$total_var_bot,
        rolling_window = input$total_rolling_window,
        per_1000 = input$total_per_1000, population = population(),
        min_date = input$total_date_range[1],
        max_date = input$total_date_range[2]
      ) %>% plotly::ggplotly()
    })
  })
}
