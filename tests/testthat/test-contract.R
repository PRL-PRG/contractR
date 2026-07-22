test_that("get_contracts / clear_contracts start empty", {
    old <- get_severity(); on.exit(set_severity(old), add = TRUE)
    set_severity("silence")

    clear_contracts()
    ct <- get_contracts()
    expect_s3_class(ct, "data.frame")
    expect_equal(nrow(ct), 0)
})

test_that("capture_contracts returns the value and the captured contracts", {
    old <- get_severity(); on.exit(set_severity(old), add = TRUE)
    set_severity("silence")
    clear_contracts()

    f <- function(x) if (missing(x)) 3L else x
    insert_contract(f, "<double> => double", pkg_name = ".GlobalEnv")

    # an integer argument violates <double>: one arg + one return contract
    cap <- capture_contracts(f(2L))

    expect_named(cap, c("result", "contracts"))
    expect_equal(cap$result, 2L)
    expect_s3_class(cap$contracts, "data.frame")
    expect_equal(nrow(cap$contracts), 2)

    # separate = TRUE (default) does not leak into the global set
    expect_equal(nrow(get_contracts()), 0)
})

test_that("capture_contracts(separate = FALSE) accumulates into the global set", {
    old <- get_severity(); on.exit(set_severity(old), add = TRUE)
    set_severity("silence")
    clear_contracts()

    f <- function(x) if (missing(x)) 3L else x
    insert_contract(f, "<double> => double", pkg_name = ".GlobalEnv")

    capture_contracts(f(2L), separate = FALSE)
    expect_equal(nrow(get_contracts()), 2)

    clear_contracts()
    expect_equal(nrow(get_contracts()), 0)
})

test_that("capture_contracts validates the separate flag", {
    expect_error(capture_contracts(1, separate = "yes"))
    expect_error(capture_contracts(1, separate = c(TRUE, FALSE)))
})

test_that("ignore_contracts evaluates code without recording contracts", {
    old <- get_severity(); on.exit(set_severity(old), add = TRUE)
    set_severity("silence")
    clear_contracts()

    f <- function(x) if (missing(x)) 3L else x
    insert_contract(f, "<double> => double", pkg_name = ".GlobalEnv")

    expect_equal(ignore_contracts(f(5L)), 5L)
    expect_equal(nrow(get_contracts()), 0)
})
