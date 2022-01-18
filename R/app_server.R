#' The application server-side
#'
#' @param input,output,session Internal parameters for `shiny`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  provinces <- reactive(read_provinces())
  reports_overall <- reactive(read_reports("overall"))
  reports_ab <- reactive(read_reports("AB"))
  reports_bc <- reactive(read_reports("BC"))
  reports_mb <- reactive(read_reports("MB"))
  reports_nb <- reactive(read_reports("NB"))
  reports_nl <- reactive(read_reports("NL"))
  reports_ns <- reactive(read_reports("NS"))
  reports_nt <- reactive(read_reports("NT"))
  reports_on <- reactive(read_reports("ON"))
  reports_pe <- reactive(read_reports("PE"))
  reports_qc <- reactive(read_reports("QC"))
  reports_sk <- reactive(read_reports("SK"))
  reports_yt <- reactive(read_reports("YT"))

  mod_daily_counts_server("overall", reports_overall)

  mod_last_updated_server("ab", provinces)
  mod_daily_counts_server("ab", reports_ab)

  mod_last_updated_server("bc", provinces)
  mod_daily_counts_server("bc", reports_bc)

  mod_last_updated_server("bc", provinces)
  mod_daily_counts_server("mb", reports_mb)

  mod_daily_counts_server("nb", reports_nb)
  mod_daily_counts_server("nl", reports_nl)
  mod_daily_counts_server("ns", reports_ns)
  mod_daily_counts_server("nt", reports_nt)
  mod_daily_counts_server("on", reports_on)
  mod_daily_counts_server("pe", reports_pe)
  mod_daily_counts_server("qc", reports_qc)
  mod_daily_counts_server("sk", reports_sk)
  mod_daily_counts_server("yt", reports_yt)
}
