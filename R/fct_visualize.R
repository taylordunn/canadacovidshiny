#' ggplot2 theme.
#'
#' @noRd
theme_canadacovid <- function(base_size = 16, base_family = "roboto",
                              base_grey = "grey85") {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(size = ggplot2::rel(1.0),
                                         face = "bold"),
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
  sysfonts::font_add_google("Roboto Condensed", "roboto")
  showtext::showtext_auto()

  ggplot2::theme_set(theme_canadacovid())
}

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
    "tests" = "#F3B460", "positivity_rate" = "#F3B460",
    "hospitalizations" = "#F19C67",
    "criticals" = "#EE835D",
    "fatalities" = "#E26355",
    "recoveries" = "#90be6d",
    "vaccinations" = "#43aa8b",
    "boosters_1" = "#577590",
    "vaccinated" = "#43aa8b",
    "percent_vaccinated" = "#43aa8b",
    "percent_boosters_1" = "#577590"
  )

#' Icons for the variables.
#'
#' @noRd
var_icons <-
  list(
    "cases" = icon("virus"),
    "tests" = icon("vial"),
    "hospitalizations" = icon("hospital"),
    "criticals" = icon("procedures"),
    "fatalities" = icon("skull"),
    "recoveries" = icon("virus-slash"),
    "vaccinations" = icon("syringe"),
    "boosters_1" = icon("syringe"),
    "vaccinated" = icon("syringe"),
    "percent_vaccinated" = icon("shield-virus"),
    "percent_boosters_1" = icon("shield-virus")
  )
var_labels <- list(
  "cases" = "Cases",
  "hospitalizations" = "Hospitalizations",
  "criticals" = "Criticals",
  "fatalities" = "Fatalities",
  "recoveries" = "Recoveries",
  "vaccinations" = "Vaccine doses",
  "boosters_1" = "Boosters",
  "vaccinated" = "People fully vaccinated",
  "percent_vaccinated" = "Percent fully vaccinated",
  "percent_boosters_1" = "Percent boosted",
  "tests" = "Tests administered",
  "positivity_rate" = "Positive test rate"
)

change_plot_vars <- var_labels[c("cases", "hospitalizations", "criticals",
                                "fatalities", "recoveries", "vaccinations",
                                "boosters_1", "vaccinated",
                                "tests")]
total_plot_vars <- var_labels[c("cases", "hospitalizations", "criticals",
                                "fatalities", "recoveries", "vaccinations",
                                "boosters_1", "vaccinated",
                                "percent_vaccinated", "percent_boosters_1",
                                "tests", "positivity_rate")]
# In order to be used for in `shiny::selectInput`, reverse the names/values
change_plot_vars <- setNames(names(change_plot_vars), change_plot_vars)
total_plot_vars <- setNames(names(total_plot_vars), total_plot_vars)

#' Plot change over time.
#'
#' @param reports The reports data from a single province (or overall).
#' @param var One of the counts in the reports data.
#' @param rolling_window Number of days to average over.
#' @param log_var Plot on a log 10 scale.
#' @param per_1000 Plot per 1000 people (requires numeric `population`).
#' @param population The population of the province (or overall).
#'
#' @noRd
#' @importFrom rlang sym .data
plot_change <- function(
  reports,
  var = c("cases", "hospitalizations", "criticals", "fatalities", "recoveries",
          "vaccinations", "boosters_1", "vaccinated", "tests"),
  rolling_window = 7, log_var = FALSE, per_1000 = FALSE, population = NULL,
  min_date = NULL, max_date = NULL
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
    dplyr::filter(dplyr::across(change_var_rolling_avg, ~ !is.na(.x)))

  if (per_1000 & !is.null(population)) {
    reports <- reports %>%
      dplyr::mutate(
        dplyr::across(change_var_rolling_avg, ~ 1000 * .x / population)
      )
    p_title <- paste0(var_labels[var], " per 1000 people",
                      " (", rolling_window, "-day rolling average)")
  } else {
    p_title <- paste0(var_labels[var],
                      " (", rolling_window, "-day rolling average)")
  }

  latest_val <- reports %>%
    dplyr::filter(date == max(date)) %>%
    dplyr::pull(change_var_rolling_avg) %>%
    round(1)
  latest_val_label <- glue::glue(
    "<b style='color:{var_color}'>{latest_val}</b>"
  )

  p <- reports %>%
    ggplot2::ggplot(ggplot2::aes(x = date, y = !!sym(change_var_rolling_avg))) +
    ggplot2::geom_line(size = 1, color = var_color) +
    ggplot2::geom_point(data = . %>% dplyr::filter(date == max(date)),
               size = 2, color = var_color) +
    ggplot2::labs(
      title = p_title, y = NULL, x = NULL
    ) +
    ggplot2::scale_x_date(expand = ggplot2::expansion(mult = c(0, 0.01))) +
    theme_canadacovid() +
    # Note that the secondary axis will not render if using plotly
    ggplot2::theme(axis.text.y.right = ggtext::element_markdown())

  if (log_var) {
    p <- p + ggplot2::scale_y_log10(
      sec.axis = ggplot2::sec_axis(~ ., breaks = latest_val,
                                   labels = latest_val_label)
    )
  } else {
    p <- p + ggplot2::scale_y_continuous(
      sec.axis = ggplot2::sec_axis(~ ., breaks = latest_val,
                                   labels = latest_val_label)
    )
  }

  if (!is.null(min_date) & !is.null(max_date)) {
    p <- p + ggplot2::coord_cartesian(xlim = c(min_date, max_date))
  }

  p
}

#' Plot total/cumulative over time.
#'
#' @param reports The reports data from a single province (or overall).
#' @param var One of the counts in the reports data.
#' @param rolling_window Number of days to average over.
#' @param log_var Plot on a log 10 scale.
#' @param per_1000 Plot per 1000 people (requires numeric `population`).
#' @param population The population of the province (or overall).
#'
#' @noRd
#' @importFrom rlang sym .data
plot_total <- function(
  reports,
  var = c("cases", "hospitalizations", "criticals", "fatalities", "recoveries",
          "vaccinations", "boosters_1", "vaccinated",
          "percent_vaccinated", "percent_boosters_1",
          "tests", "positivity_rate"),
  rolling_window = 7, log_var = FALSE, per_1000 = FALSE, population = NULL,
  min_date = NULL, max_date = NULL
) {
  var <- match.arg(var)
  var_color <- var_colors_pastel[[var]]
  if (var %in% c("cases", "hospitalizations", "criticals", "fatalities",
                 "recoveries", "vaccinations", "boosters_1", "vaccinated",
                 "tests")) {
    total_var <- paste0("total_", var)
  } else {
    total_var <- var
  }
  total_var_rolling_avg <- paste0(total_var, "_rolling_avg")

  reports <- reports %>%
    dplyr::mutate(
      dplyr::across(total_var,
                    ~ RcppRoll::roll_mean(.x, n = rolling_window,
                                          align = "right", fill = NA),
             .names = "{.col}_rolling_avg")
    ) %>%
    dplyr::filter(dplyr::across(total_var_rolling_avg, ~ !is.na(.x)))

  if (per_1000 & !is.null(population)) {
    reports <- reports %>%
      dplyr::mutate(
        dplyr::across(total_var_rolling_avg, ~ 1000 * .x / population)
      )
    p_title <- paste0(var_labels[var], " per 1000 people",
                      " (", rolling_window, "-day rolling average)")
  } else {
    p_title <- paste0(var_labels[var],
                      " (", rolling_window, "-day rolling average)")
  }

  latest_val <- reports %>%
    dplyr::filter(date == max(date)) %>%
    dplyr::pull(total_var_rolling_avg) %>%
    round(1)
  latest_val_label <- glue::glue(
    "<b style='color:{var_color}'>{latest_val}</b>"
  )

  p <- reports %>%
    ggplot2::ggplot(ggplot2::aes(x = date, y = !!sym(total_var_rolling_avg))) +
    ggplot2::geom_ribbon(
      ggplot2::aes(ymin = 0, ymax = !!sym(total_var_rolling_avg)),
      fill = var_color, alpha = 0.5
    ) +
    ggplot2::geom_line(size = 1, color = var_color) +
    ggplot2::geom_point(data = . %>% dplyr::filter(date == max(date)),
               size = 2, color = var_color) +
    ggplot2::labs(
      title = p_title, y = NULL, x = NULL
    ) +
    ggplot2::scale_x_date(expand = ggplot2::expansion(mult = c(0, 0.01))) +
    theme_canadacovid() +
    # Note that the secondary axis will not render if using plotly
    ggplot2::theme(axis.text.y.right = ggtext::element_markdown())

  if (log_var) {
    p <- p + ggplot2::scale_y_log10(
      sec.axis = ggplot2::sec_axis(~ ., breaks = latest_val,
                                   labels = latest_val_label)
    )
  } else {
    p <- p + ggplot2::scale_y_continuous(
      sec.axis = ggplot2::sec_axis(~ ., breaks = latest_val,
                                   labels = latest_val_label)
    )
  }

  if (!is.null(min_date) & !is.null(max_date)) {
    p <- p + ggplot2::coord_cartesian(xlim = c(min_date, max_date))
  }

  p
}

plotly_config <- function(p) {
  plotly::config(
    p,
    modeBarButtonsToRemove = c("toImage", "select2d", "lasso2d",
                               "zoomIn2d", "zoomOut2d", "resetScale2d",
                               "hoverClosestCartesian",
                               "hoverCompareCartesian"))
}
