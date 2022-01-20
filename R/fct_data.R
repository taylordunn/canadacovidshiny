#' Register the pins board
#'
#' The `pins::board_register_github()` function requires a GitHub personal
#' access token be available through `gitcreds`.
#'
#' @noRd
#' @importFrom pins board_register_github
register_github_board <- function() {
  pins::board_register_github(
    name = "github", repo = "taylordunn/canadacovidshiny", path = "data/pins",
    token = Sys.getenv("GITHUB_PAT")
  )
}

#' The list of two-letter province codes
#'
#' @noRd
province_codes <- list(
  "Alberta" = "AB", "British Columbia" = "BC", "Manitoba" = "MB",
  "New Brunswick" = "NB", "Newfoundland and Labrador" = "NL",
  "Northwest Territories" = "NT", "Nova Scotia" = "NS",
  "Nunavut" = "NU", "Ontario" = "ON", "Prince Edward Island" = "PE",
  "Quebec" = "QC", "Saskatchewan" = "SK", "Yukon" = "YT"
)

#' The list of time zones for each province
#'
#' @noRd
province_timezones <- list(
  "AB" = "Canada/Mountain", "BC" = "Canada/Pacific", "MB" = "Canada/Central",
  "NB" = "Canada/Atlantic", "NL" = "Canada/Newfoundland",
  "NT" = "Canada/Mountain", "NS" = "Canada/Atlantic",
  "NU" = "Canada/Central", "ON" = "Canada/Eastern", "PE" = "Canada/Atlantic",
  "QC" = "Canada/Eastern", "SK" = "Canada/Saskatchewan", "YT" = "Canada/Yukon",
  "overall" = "Canada/Eastern"
)

#' Reads in the province data from pins board
#'
#' @return A data frame.
#'
#' @importFrom pins pin_get
read_provinces <- function() {
  pins::pin_get("provinces", board = "github")
}

#' Reads in the summary data from pins board
#'
#' @param split One of "overall" (aggregated counts across Canada) or "province"
#'   (splits counts by province/territory).
#'
#' @return A data frame.
#'
#' @importFrom pins pin_get
read_summary <- function(split = c("overall", "province")) {
  split <- match.arg(split)
  pins::pin_get(paste0("summary_", split), board = "github")
}

#' Reads in the reports data from pins board
#'
#' @param choice if `NULL`, reads in all of the reports and returns a list.
#'   Otherwise, one of "overall" or a province code ("AB", "BC", etc.).
#'
#' @return A single data frame, or a named list of data frames (if `choice`
#'   is `NULL`).
#'
#' @importFrom purrr map
#' @importFrom pins pin_get
read_reports <- function(choice = NULL) {
  # The possible choices are "overall" or lowercase province codes
  choices <- c("overall", tolower(province_codes))

  if (is.null(choice)) {
    purrr::map(
      choices,
      ~ pins::pin_get(paste0("reports_", .x), board = "github")
    ) %>%
      setNames(choices)
  } else {
    choice <- match.arg(tolower(choice), choices = choices)

    pins::pin_get(paste0("reports_", choice), board = "github")
  }
}

#' Reads in the reports data from pins board
#'
#' @param data The data to save to the pin board.
#' @param name The name to give the data.
#'
#' @importFrom pins pin
write_data <- function(data, name) {
  pins::pin(data, name = name, board = "github")
}
