test_that("register_github_board works", {
  board <- register_github_board()
  expect_s3_class(board, "pins_board_github")

  reports_overall_info <- pins::pin_info("reports_overall", "github")
  expect_equal(reports_overall_info$cols, 25)
})

test_that("read_reports works", {
  board <- register_github_board()

  reports <- read_reports()
  expect_equal(names(reports), c("overall", tolower(province_codes)))

  reports_ns <- read_reports(choice = "NS")
  expect_equal(unique(reports_ns$province), "NS")
  expect_equal(ncol(reports_ns), 26)
})
