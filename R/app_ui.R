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
      dashboardHeader(title = "Canadian COVID-19 Dashboard",
                      titleWidth = 450),
      dashboardSidebar(
        sidebarMenu(
          menuItem("Overall", tabName = "overall"),
          menuItem("Alberta", tabName = "AB"),
          menuItem("British Columbia", tabName = "BC"),
          menuItem("Manitoba", tabName = "MB"),
          menuItem("New Brunswick", tabName = "NB"),
          menuItem("Newfoundland and Labrador", tabName = "NL"),
          menuItem("Northwest Territories", tabName = "NT"),
          menuItem("Nova Scotia", tabName = "NS"),
          menuItem("Nunavut", tabName = "NU"),
          menuItem("Ontario", tabName = "ON"),
          menuItem("Prince Edward Island", tabName = "PE"),
          menuItem("Quebec", tabName = "QC"),
          menuItem("Saskatchewan", tabName = "SK"),
          menuItem("Yukon", tabName = "YT"),
          menuItem("Source code", icon = icon("file-code-o"),
                   href = "https://github.com/taylordunn/canadacovidshiny")
        )
      ),
      dashboardBody(
        tabItems(
          tabItem(
            tabName = "overall",
            mod_last_updated_ui("overall"),
            mod_daily_counts_ui("overall"),
            mod_change_plot_box_ui("overall")
          ),
          tabItem(
            tabName = "AB",
            mod_last_updated_ui("AB"),
            mod_daily_counts_ui("AB"),
            mod_change_plot_box_ui("AB")
          ),
          tabItem(
            tabName = "BC",
            mod_last_updated_ui("BC"),
            mod_daily_counts_ui("BC"),
            mod_change_plot_box_ui("BC")
          ),
          tabItem(
            tabName = "MB",
            mod_last_updated_ui("MB"),
            mod_daily_counts_ui("MB"),
            mod_change_plot_box_ui("MB")
          ),
          tabItem(
            tabName = "NB",
            mod_last_updated_ui("NB"),
            mod_daily_counts_ui("NB"),
            mod_change_plot_box_ui("NB")
          ),
          tabItem(
            tabName = "NL",
            mod_last_updated_ui("NL"),
            mod_daily_counts_ui("NL"),
            mod_change_plot_box_ui("NL")
          ),
          tabItem(
            tabName = "NS",
            mod_last_updated_ui("NS"),
            mod_daily_counts_ui("NS"),
            mod_change_plot_box_ui("NS")
          ),
          tabItem(
            tabName = "NT",
            mod_last_updated_ui("NT"),
            mod_daily_counts_ui("NT"),
            mod_change_plot_box_ui("NT")
          ),
          tabItem(
            tabName = "NU",
            mod_last_updated_ui("NU"),
            mod_daily_counts_ui("NU"),
            mod_change_plot_box_ui("NU")
          ),
          tabItem(
            tabName = "ON",
            mod_last_updated_ui("ON"),
            mod_daily_counts_ui("ON"),
            mod_change_plot_box_ui("ON")
          ),
          tabItem(
            tabName = "PE",
            mod_last_updated_ui("PE"),
            mod_daily_counts_ui("PE"),
            mod_change_plot_box_ui("PE")
          ),
          tabItem(
            tabName = "QC",
            mod_last_updated_ui("QC"),
            mod_daily_counts_ui("QC"),
            mod_change_plot_box_ui("QC")
          ),
          tabItem(
            tabName = "SK",
            mod_last_updated_ui("SK"),
            mod_daily_counts_ui("SK"),
            mod_change_plot_box_ui("SK")
          ),
          tabItem(
            tabName = "YT",
            mod_last_updated_ui("YT"),
            mod_daily_counts_ui("YT"),
            mod_change_plot_box_ui("YT")
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
