#ifndef CONTRACTR_INJECT_HPP
#define CONTRACTR_INJECT_HPP

#include <R.h>
#include <Rinternals.h>

extern SEXP R_DotCallSym;
extern SEXP R_TrueValue;
extern SEXP R_FalseValue;
extern SEXP R_DelayedAssign;

extern "C" {

/* .check_call calls */

SEXP get_type_check_function();
SEXP get_type_check_function_wrapper();
SEXP set_type_check_function(SEXP, SEXP);
SEXP reset_type_check_function();
SEXP create_check_type_call(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
SEXP inject_type_check(SEXP, SEXP, SEXP, SEXP);
SEXP log_insertion(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
SEXP check_type(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
SEXP environment_name(SEXP);

SEXP Rf_deparse1(SEXP, Rboolean, int);
}

#endif /* CONTRACTR_INJECT_HPP */
