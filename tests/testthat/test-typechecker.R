test_that("contract for `double` is enforced correctly", {

    # TODO: this block is unfinished and skipped for now. Before re-enabling:
    #   - define the missing helpers `create_tuple()` and `create_struct()`
    #     (see helper-typechecker.R alongside create_list/create_s4/create_weakref)
    #   - fill in the `???` placeholder expected type for the missing-argument case
    #   - verify the list/tuple/struct expected type names against current tastr output
    skip("unfinished: missing helpers (create_tuple/create_struct) and placeholders")

    fun <- function(x) if (missing(x)) 3L else x

    insert_contract(fun, "<double> => double", pkg_name = ".GlobalEnv")

################################################################################
##    double
################################################################################

    typecheck(fun) %>%
      apply_arguments(2.0) %>%
      expect_contract_violations(0)

################################################################################
## integer
################################################################################

    typecheck(fun) %>%
      apply_arguments(integer()) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "integer[]") %>%
      expect_ret_contract_violation("double", "integer[]")

    typecheck(fun) %>%
      apply_arguments(c(2L, 3L)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "integer[]") %>%
      expect_ret_contract_violation("double", "integer[]")

    typecheck(fun) %>%
      apply_arguments(c(32L, NA_integer_)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "^integer[]") %>%
      expect_ret_contract_violation("double", "^integer[]")

################################################################################
## character
################################################################################

    typecheck(fun) %>%
      apply_arguments(character()) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "character[]") %>%
      expect_ret_contract_violation("double", "character[]")

    typecheck(fun) %>%
      apply_arguments("2") %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "character") %>%
      expect_ret_contract_violation("double", "character")

    typecheck(fun) %>%
      apply_arguments(c("2", "3")) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "character[]") %>%
      expect_ret_contract_violation("double", "character[]")

    typecheck(fun) %>%
      apply_arguments(NA_character_) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "^character") %>%
      expect_ret_contract_violation("double", "^character")

    typecheck(fun) %>%
      apply_arguments(c("32", NA_character_)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "^character[]") %>%
      expect_ret_contract_violation("double", "^character[]")

################################################################################
## complex
################################################################################

    typecheck(fun) %>%
      apply_arguments(complex()) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "complex[]") %>%
      expect_ret_contract_violation("double", "complex[]")

    typecheck(fun) %>%
      apply_arguments(2+2i) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "complex") %>%
      expect_ret_contract_violation("double", "complex")

    typecheck(fun) %>%
      apply_arguments(c(2+1i, 3+3i)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "complex[]") %>%
      expect_ret_contract_violation("double", "complex[]")

    typecheck(fun) %>%
      apply_arguments(NA_complex_) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "^complex") %>%
      expect_ret_contract_violation("double", "^complex")

    typecheck(fun) %>%
      apply_arguments(c(3 + 2i, NA_complex_)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "^complex[]") %>%
      expect_ret_contract_violation("double", "^complex[]")

################################################################################
## logical
################################################################################

    typecheck(fun) %>%
      apply_arguments(logical()) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "logical[]") %>%
      expect_ret_contract_violation("double", "logical[]")

    typecheck(fun) %>%
      apply_arguments(c(TRUE, FALSE)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "logical[]") %>%
      expect_ret_contract_violation("double", "logical[]")

    typecheck(fun) %>%
      apply_arguments(c(TRUE, na_logical_)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "^logical[]") %>%
      expect_ret_contract_violation("double", "^logical[]")

################################################################################
## raw
################################################################################

    typecheck(fun) %>%
      apply_arguments(raw()) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "raw[]") %>%
      expect_ret_contract_violation("double", "raw[]")

    typecheck(fun) %>%
      apply_arguments(as.raw(40)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "raw") %>%
      expect_ret_contract_violation("double", "raw")

    typecheck(fun) %>%
      apply_arguments(as.raw(c(32, 45))) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "raw[]") %>%
      expect_ret_contract_violation("double", "raw[]")

################################################################################
## environment
################################################################################

    typecheck(fun) %>%
      apply_arguments(new.env()) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "environment") %>%
      expect_ret_contract_violation("double", "environment")

################################################################################
## expression
################################################################################

    typecheck(fun) %>%
      apply_arguments(expression(1 + 2)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "expression") %>%
      expect_ret_contract_violation("double", "expression")

################################################################################
## language
################################################################################

    typecheck(fun) %>%
      apply_arguments(quote(1 + 2)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "class<call>") %>%
      expect_ret_contract_violation("double", "class<call>")

################################################################################
## symbol
################################################################################

    typecheck(fun) %>%
      apply_arguments(as.symbol("x")) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "class<name>") %>%
      expect_ret_contract_violation("double", "class<name>")

################################################################################
## pairlist
################################################################################

    typecheck(fun) %>%
      apply_arguments(pairlist(1, 2, 3)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "pairlist") %>%
      expect_ret_contract_violation("double", "pairlist")

################################################################################
## s4
################################################################################

    typecheck(fun) %>%
      apply_arguments(create_s4()) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "class<Person>") %>%
      expect_ret_contract_violation("double", "class<Person>")

################################################################################
## weakref
################################################################################

    typecheck(fun) %>%
      apply_arguments(create_weakref()) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "weakref") %>%
      expect_ret_contract_violation("double", "weakref")

################################################################################
## missing
################################################################################

    typecheck(fun) %>%
      apply_arguments() %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "???") %>%
      expect_ret_contract_violation("double", "integer")


################################################################################
## null
################################################################################

    typecheck(fun) %>%
      apply_arguments(NULL) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "null") %>%
      expect_ret_contract_violation("double", "null")

################################################################################
## list
################################################################################

    typecheck(fun) %>%
      apply_arguments(create_list(6)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "list<character>") %>%
      expect_ret_contract_violation("double", "list<character>")

################################################################################
## tuple
################################################################################

    typecheck(fun) %>%
      apply_arguments(create_tuple(2)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "tuple<character, character>") %>%
      expect_ret_contract_violation("double", "tuple<character, character>")

################################################################################
## struct
################################################################################

    typecheck(fun) %>%
      apply_arguments(create_struct(2)) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "struct<`name`: double, `name`: double>") %>%
      expect_ret_contract_violation("double", "struct<`name`: double, `name`: double>")

################################################################################
## closure
################################################################################

    typecheck(fun) %>%
      apply_arguments(function(x, y) {
          x + y
      }) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "any => any") %>%
      expect_ret_contract_violation("double", "any => any")

################################################################################
## builtin
################################################################################

    typecheck(fun) %>%
      apply_arguments(max) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "any => any") %>%
      expect_ret_contract_violation("double", "any => any")

################################################################################
## special
################################################################################

    typecheck(fun) %>%
      apply_arguments(`if`) %>%
      expect_contract_violations(2) %>%
      expect_arg_contract_violation(1, "double", "any => any") %>%
      expect_ret_contract_violation("double", "any => any")

})
