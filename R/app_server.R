#' The application server-side
#'
#' @param input,output,session Internal parameters for `shiny`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })

  summary_overall <- reactive(read_summary(split = "overall"))
  summary_province <- reactive(read_summary(split = "province"))
  # summary_overall <- read_summary(split = "overall")
  # summary_province <- read_summary(split = "province")

  mod_summary_row_server("overall", summary_overall())
  #mod_summary_row_server("nb", summary_province)
}
