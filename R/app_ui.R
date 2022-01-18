#' The application UI
#'
#' @param request Internal parameter for `shiny`.
#'     DO NOT REMOVE.
#' @import shiny shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    dashboardPage(
      dashboardHeader(title = "Canadian COVID-19 Dashboard"),
      dashboardSidebar(
        sidebarMenu(
          menuItem("Overall", tabName = "overall", icon = icon("dashboard")),
          menuItem("Alberta", tabName = "ab"),
          menuItem("British Columbia", tabName = "bc"),
          menuItem("Manitoba", tabName = "mb"),
          menuItem("New Brunswick", tabName = "nb", icon = icon("th")),
          menuItem("Newfoundland and Labrador", tabName = "nl"),
          menuItem("Northwest Territories", tabName = "nt"),
          menuItem("Nova Scotia", tabName = "ns", icon = icon("th")),
          menuItem("Nunavut", tabName = "nu"),
          menuItem("Ontario", tabName = "on"),
          menuItem("Prince Edward Island", tabName = "pe"),
          menuItem("Quebec", tabName = "qc"),
          menuItem("Saskatchewan", tabName = "sk"),
          menuItem("Yukon", tabName = "yt"),
          menuItem("Source code", icon = icon("file-code-o"),
                   href = "https://github.com/taylordunn/canadacovidshiny")
        )
      ),
      dashboardBody(
        tabItems(
          tabItem(
            tabName = "overall",
            mod_daily_counts_ui("overall")
          ),
          tabItem(
            tabName = "ab",
            mod_last_updated_ui("ab"),
            mod_daily_counts_ui("ab")
          ),
          tabItem(
            tabName = "bc",
            mod_last_updated_ui("bc"),
            mod_daily_counts_ui("bc")
          ),
          tabItem(
            tabName = "mb",
            mod_daily_counts_ui("mb")
          ),
          tabItem(
            tabName = "nb",
            mod_daily_counts_ui("nb")
          ),
          tabItem(
            tabName = "nl",
            mod_daily_counts_ui("nl")
          ),
          tabItem(
            tabName = "ns",
            mod_daily_counts_ui("ns")
          ),
          tabItem(
            tabName = "nt",
            mod_daily_counts_ui("nt")
          ),
          tabItem(
            tabName = "nu",
            mod_daily_counts_ui("nu")
          ),
          tabItem(
            tabName = "on",
            mod_daily_counts_ui("on")
          ),
          tabItem(
            tabName = "pe",
            mod_daily_counts_ui("pe")
          ),
          tabItem(
            tabName = "qc",
            mod_daily_counts_ui("qc")
          ),
          tabItem(
            tabName = "sk",
            mod_daily_counts_ui("sk")
          ),
          tabItem(
            tabName = "yt",
            mod_daily_counts_ui("yt")
          )
        )
      )
    )
  )
}

#' Add external resources to the application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www", app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "canadacovidshiny"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
