#' A custom value box
#'
#' A slightly adapted `shinydashboard::valueBox` function which allows for
#' other colors (besides the `shinydashboard::validColors`).
#' Credit goes to [this user on the RStudio forum](https://community.rstudio.com/t/shinydashboard-custom-box-colors-to-match-brand/14147/5).
#'
#' @param value The value to display in the box. Usually a number or short text.
#' @param subtitle Subtitle text.
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param color A color for the box.
#' @param href An optional URL to link to.
valueBoxCustom <- function(value, subtitle, icon = NULL, color = "white",
                           background = "aqua", width = 4, href = NULL) {
  # validateColor(color)
  # if (!is.null(icon)) shinydashboard::tagAssert(icon, type = "i")

  style <- paste0("color: ", color, "; background-color: ", background, ";")
  boxContent <- div(
    class = "small-box", style = style,
    div(
      class = "inner", h3(value), p(subtitle)
    ),
    if (!is.null(icon)) div(class = "icon-large", icon)
  )

  if (!is.null(href)) {
    boxContent <- a(href = href, boxContent)
  }

  div(
    class = if (!is.null(width)) paste0("col-sm-", width),
    boxContent
  )
}

pin_changed_time <- function(name, board, extract = NULL) {
  pin_path <- pins::board_pin_get(pins::board_get(board), name, extract = extract)
  pin_files <- file.path(pin_path, dir(pin_path))

  max(file.info(pin_files)[, "mtime"])
}
