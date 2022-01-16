test_that("register_github_board works", {
  board <- register_github_board()
  expect_cl
  expect_s3_class(board, "pins_board_github")

  summary_overall_info <- pins::pin_info("summary_overall", "github")
  expect_equal(summary_overall_info$cols, 22)
  expect_equal(summary_overall_info$rows, 1)
})
