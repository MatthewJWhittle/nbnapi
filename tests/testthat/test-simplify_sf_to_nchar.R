
test_that("simplify sf text works", {
  expect_equal(nchar(st_as_text(simplify_sf_to_nchar(north_yorkshire$geometry, char = 1000))) <= 1000, TRUE)
})
expect
