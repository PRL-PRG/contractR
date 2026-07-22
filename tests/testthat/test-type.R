# NOTE: the signature-manipulation helpers (combine_sigs, minimize_signature,
# minimize_list_of_sigs, sig_distance) are intentionally not exercised here --
# they currently segfault when several tastr objects are collected together
# (a double-free in the external-pointer finalizers, tracked separately).

test_that("parse_type builds a tastr object and validates input", {
    ft <- parse_type("(double, character) => logical")
    expect_s3_class(ft, "tastr")

    expect_error(parse_type(c("a", "b")))
    expect_error(parse_type(1))
})

test_that("is_function_type / is_class_type discriminate type kinds", {
    ft <- parse_type("(double) => logical")
    ct <- parse_type("class<data.frame>")

    expect_true(is_function_type(ft))
    expect_false(is_class_type(ft))

    expect_true(is_class_type(ct))
    expect_false(is_function_type(ct))

    # both predicates require a tastr object
    expect_error(is_function_type("double"))
    expect_error(is_class_type("double"))
})

test_that("get_classes returns the declared class names", {
    ct <- parse_type("class<data.frame>")
    expect_identical(get_classes(ct), "data.frame")
    expect_error(get_classes("data.frame"))
})

test_that("get_parameter_type indexes return (0) then parameters (1..n)", {
    ft <- parse_type("(double, character) => logical")

    expect_identical(format(get_parameter_type(ft, 0L)), "logical")  # return
    expect_identical(format(get_parameter_type(ft, 1L)), "double")   # 1st param
    expect_identical(format(get_parameter_type(ft, 2L)), "character") # 2nd param

    expect_error(get_parameter_type(ft, 0))    # not an integer
    expect_error(get_parameter_type(ft, -1L))  # negative
    expect_error(get_parameter_type("x", 0L))  # not a tastr
})

test_that("is_subtype returns a logical and requires tastr operands", {
    ft <- parse_type("(double) => logical")
    expect_type(is_subtype(ft, ft), "logical")
    expect_error(is_subtype(ft, "logical"))
})

test_that("format/print round-trip a tastr type to its source syntax", {
    ft <- parse_type("(double, character) => logical")
    expect_identical(format(ft), "(double, character) => logical")
    expect_output(print(ft), "(double, character) => logical", fixed = TRUE)
})
