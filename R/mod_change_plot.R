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

    output$change_plot <- renderPlot({
      plot_change(reports_data(), var, rolling_window = 7)
    })
  })
}

#' change_plot UI function
#'
#' @noRd
#' @importFrom plotly renderPlotly ggplotly
mod_change_plot_box_ui <- function(id) {
  ns <- NS(id)
  tagList(
    box(
      title = span(icon("chart-line"), "Change per day"),
      collapsible = TRUE, width = 6,
      plotly::plotlyOutput(ns("change_plot_1"), height = 250),
      plotly::plotlyOutput(ns("change_plot_2"), height = 250),
      plotly::plotlyOutput(ns("change_plot_3"), height = 250),
      fluidRow(
        column(3,
          selectInput(ns("change_var_top"), label = "Top",
                      selected = "cases", choices = change_plot_vars),
          selectInput(ns("change_var_mid"), label = "Middle",
                      selected = "hospitalizations", choices = change_plot_vars),
          selectInput(ns("change_var_bot"), label = "Bottom",
                      selected = "criticals", choices = change_plot_vars)
        ),
        column(6,
          sliderInput(ns("change_rolling_window"),
                      label = "Rolling average (days)",
                      value = 7, min = 1, max = 30, step = 1, ticks = FALSE),
          dateRangeInput(ns("change_date_range"), label = c("Date range"),
                         start = "2020-01-25", min = "2020-01-25")
        ),
        column(3,
          checkboxInput(ns("change_per_1000"), label = "Per 1000 people", FALSE),
        )
      )
    )
  )
}

#' change_plot server function
#'
#' @noRd
#' @importFrom plotly renderPlotly ggplotly
mod_change_plot_box_server <- function(id, reports_data, population) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$change_plot_1 <- plotly::renderPlotly({
      plot_change(
        reports_data(), input$change_var_top,
        rolling_window = input$change_rolling_window,
        per_1000 = input$change_per_1000, population = population(),
        min_date = input$change_date_range[1],
        max_date = input$change_date_range[2]
      ) %>% plotly::ggplotly() %>% plotly_config()
    })
    output$change_plot_2 <- plotly::renderPlotly({
      plot_change(
        reports_data(), input$change_var_mid,
        rolling_window = input$change_rolling_window,
        per_1000 = input$change_per_1000, population = population(),
        min_date = input$change_date_range[1],
        max_date = input$change_date_range[2]
      ) %>% plotly::ggplotly() %>% plotly_config()
    })
    output$change_plot_3 <- plotly::renderPlotly({
      plot_change(
        reports_data(), input$change_var_bot,
        rolling_window = input$change_rolling_window,
        per_1000 = input$change_per_1000, population = population(),
        min_date = input$change_date_range[1],
        max_date = input$change_date_range[2]
      ) %>% plotly::ggplotly() %>% plotly_config()
    })
  })
}
