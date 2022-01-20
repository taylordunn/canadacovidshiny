#' For UI element colors, we are restricted to a select few colors.
#' See `?shinydashboard::validColors`
#'
#' @noRd
var_colors_ui <-
  list(
    "cases" = "yellow",
    "hospitalizations" = "orange",
    "criticals" = "orange",
    "fatalities" = "red",
    "recoveries" = "green",
    "vaccinations" = "light-blue",
    "boosters_1" = "blue"
  )

#' The list of colors for plotting associated with the different variables.
#'
#' @noRd
var_colors_pastel <-
  list(
    "cases" = "#F3B460",
    "hospitalizations" = "#F19C67",
    "criticals" = "#EE835D",
    "fatalities" = "#E26355",
    "recoveries" = "#90be6d",
    "vaccinations" = "#43aa8b",
    "boosters_1" = "#577590"
  )

#' Icons for the variables.
#'
#' @noRd
var_icons <-
  list(
    "cases" = icon("virus"),
    "hospitalizations" = icon("hospital"),
    "criticals" = icon("procedures"),
    "fatalities" = icon("skull"),
    #"recoveries" = icon("hand-holding-medical"),
    "recoveries" = icon("virus-slash"),
    "vaccinations" = icon("syringe"),
    "boosters_1" = icon("syringe"),
    #"boosters_1" = icon("syringe")
    "boosters_1" = icon("shield-virus")
  )

#' ggplot2 theme.
#'
#' @noRd
theme_canadacovid <- function(base_size = 16, base_family = "roboto",
                              base_grey = "grey85") {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(face = "bold"),
      axis.title = ggplot2::element_text(face = "bold"),
      strip.text = ggplot2::element_text(face = "bold",
                                         size = ggplot2::rel(0.8), hjust = 0),
      strip.background = ggplot2::element_rect(fill = base_grey, color = NA),
      legend.title = ggplot2::element_text(face = "bold")
    )
}

#' Load the font and set the ggplot2 theme.
#'
#' @noRd
set_plotting_defaults <- function() {
  # sysfonts::font_add_google("Roboto Condensed", "roboto")
  # showtext::showtext_auto()

  ggplot2::theme_set(theme_canadacovid())
}


#' Plot change over time.
#'
#' @param reports The reports data from a single province (or overall)
#' @param var One of
#'
#' @noRd
#' @importFrom rlang sym
plot_change <- function(
  reports,
  var = c("cases", "hospitalizations", "criticals", "fatalities", "recoveries",
          "vaccinations", "boosters_1"),
  rolling_window = 7
) {
  var <- match.arg(var)
  var_color <- var_colors_pastel[[var]]
  change_var <- paste0("change_", var)
  change_var_rolling_avg <- paste0(change_var, "_rolling_avg")

  reports <- reports %>%
    dplyr::mutate(
      dplyr::across(change_var,
                    ~ RcppRoll::roll_mean(.x, n = rolling_window,
                                          align = "right", fill = NA),
             .names = "{.col}_rolling_avg")
    ) %>%
    dplyr::filter(dplyr::across(change_var_rolling_avg, ~ !is.na(.)))

  latest_val <- reports %>%
    dplyr::filter(date == max(date)) %>%
    dplyr::pull(change_var_rolling_avg) %>%
    round(1)
  latest_val_label <- glue::glue(
    "<b style='color:{var_color}'>{latest_val}</b>"
  )

  reports %>%
    ggplot2::ggplot(ggplot2::aes(x = date, y = !!sym(change_var_rolling_avg))) +
    ggplot2::geom_line(size = 1, color = var_color) +
    ggplot2::geom_point(data = . %>% dplyr::filter(date == max(date)),
               size = 2, color = var_color) +
    ggplot2::labs(
      title = paste0(stringr::str_to_sentence(var),
                     " (", rolling_window, "-day rolling average)"),
      y = NULL, x = NULL
    ) +
    ggplot2::scale_y_continuous(
      sec.axis = ggplot2::sec_axis(~ ., breaks = latest_val,
                                   labels = latest_val_label)
    ) +
    ggplot2::scale_x_date(expand = ggplot2::expansion(mult = c(0, 0.01))) +
    theme_canadacovid(base_family = "") +
    ggplot2::theme(axis.text.y.right = ggtext::element_markdown())
}
