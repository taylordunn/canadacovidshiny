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
          menuItem("New Brunswick", tabName = "nb", icon = icon("th")),
          menuItem("Source code", icon = icon("file-code-o"),
                   href = "https://github.com/taylordunn/canadacovidshiny")
        )
      ),
      dashboardBody(
        tabItems(
          # First tab content
          tabItem(
            tabName = "overall",
            mod_summary_row_ui("overall"),
            fluidRow(
              #mod_change_box_ui("nova_scotia"),
              #box(plotOutput("plot1", height = 250)),
              box(
                title = "Controls",
                sliderInput("slider", "Number of observations:", 1, 100, 50)
              )
            )
          ),

          # Second tab content
          tabItem(tabName = "widgets",
                  h2("Widgets tab content")
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
