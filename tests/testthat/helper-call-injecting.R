test_injection <- function(desc, code) {
  on.exit({
    .injected_functions <<- new.env(parent=emptyenv())
  })
  test_that(desc, code)
}

expect_type_assertion <- function(f) {
  expect_true(has_contract(f))
}
