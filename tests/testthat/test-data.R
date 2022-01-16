test_that("register_github_board works", {
  board <- register_github_board()
  expect_s3_class(board, "pins_board_github")

  summary_overall_info <- pins::pin_info("summary_overall", "github")
  expect_equal(summary_overall_info$cols, 22)
  expect_equal(summary_overall_info$rows, 1)
})

test_that("read_summary works", {
  board <- register_github_board()

  summary_overall <- read_summary("overall")
  expect_equal(nrow(summary_overall), 1)
  expect_equal(ncol(summary_overall), 22)

  summary_province <- read_summary("province")
  expect_equal(nrow(summary_province), 13)
  expect_equal(ncol(summary_province), 23)
})

test_that("read_reports works", {
  board <- register_github_board()

  reports <- read_reports()
  expect_equal(names(reports), c("overall", tolower(province_codes)))

  reports_ns <- read_reports(choice = "NS")
  expect_equal(unique(reports_ns$province), "NS")
  expect_equal(ncol(reports_ns), 23)

})
