test_injection("into a function", {
  f <- function(a, b) a + b

  n <- contractr:::get_injected_function_count()

  insert_contract(f, "<int, int> => int", fun_name = "f", pkg_name = "mypkg")

  expect_equal(contractr:::get_injected_function_count(), n + 1)

  expect_true(has_contract(f))

  remove_contract(f)

  expect_equal(contractr:::get_injected_function_count(), n)

  expect_false(has_contract(f))

})

test_injection("into an environment", {
  e <- new.env(parent=emptyenv())
  e$f <- function(x) x
  e$g <- function(y) y
  e$h <- sin

  n <- contractr:::get_injected_function_count()

  expect_silent(insert_environment_contract(e, "e", FALSE))

  expect_equal(contractr:::get_injected_function_count(), n)

  expect_false(has_contract(e$f))
  expect_false(has_contract(e$g))
  expect_false(has_contract(e$h))
  expect_identical(e$h, sin)
})

test_injection("into a package", {
  # This test builds and installs the bundled TestPackage fixture via
  # devtools::install(), which drives pak. pak aborts when R_USER_CACHE_DIR is
  # unset -- which is the case inside R CMD check (r-lib CI sets NOT_CRAN=true,
  # so skip_on_cran() does NOT skip here) and under covr. Guard on the actual
  # failure condition so the test still runs under an interactive
  # devtools::test(), where the cache dir is set.
  skip_on_covr()
  skip_if_not_installed("devtools")
  skip_if_not_installed("withr")
  if (!nzchar(Sys.getenv("R_USER_CACHE_DIR"))) {
    skip("devtools::install() drives pak, which needs R_USER_CACHE_DIR (unset under R CMD check / CI)")
  }

  withr::with_temp_libpaths({
      devtools::install("TestPackage", quick=TRUE)
      library(TestPackage)

      set_type_declaration(foo1,
                           "any => any",
                           package_name = "TestPackage",
                           function_name = "foo1")

      insert_package_contract("TestPackage")

      expect_true(has_contract(foo1))

      expect_false(has_contract(TestPackage:::bar))
  })
})
