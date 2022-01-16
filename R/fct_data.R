#' Register the pins board
#'
#' The `pins::board_register_github()` function requires a GitHub personal
#' access token be available through `gitcreds`.
#'
#' @noRd
#' @importFrom pins board_register_github
register_github_board <- function() {
  pins::board_register_github(
    name = "github", repo = "taylordunn/canadacovidshiny", path = "data/pins"
  )
}
