#ifndef CONTRACTR_UTILITIES_HPP
#define CONTRACTR_UTILITIES_HPP

#include <Rinternals.h>
#include <string>
#include <functional>
#include <vector>

extern SEXP R_TrueValue;
extern SEXP R_FalseValue;

extern SEXP DotCallSym;
extern SEXP DelayedAssign;
extern SEXP SystemDotFile;
extern SEXP PackageSymbol;

extern SEXPTYPE MISSINGSXP;

extern const std::string UNDEFINED_STRING_VALUE;

extern "C" {

void initialize_globals();

char* copy_c_string(const char* source);

SEXPTYPE type_of_sexp(SEXP value);

std::string sexptype_to_string(SEXPTYPE type);

SEXP environment_name(SEXP env);

SEXP lang7(SEXP s, SEXP t, SEXP u, SEXP v, SEXP w, SEXP x, SEXP y);

SEXP lang8(SEXP s, SEXP t, SEXP u, SEXP v, SEXP w, SEXP x, SEXP y, SEXP z);

SEXP lang9(SEXP r,
           SEXP s,
           SEXP t,
           SEXP u,
           SEXP v,
           SEXP w,
           SEXP x,
           SEXP y,
           SEXP z);

SEXP lang10(SEXP q,
            SEXP r,
            SEXP s,
            SEXP t,
            SEXP u,
            SEXP v,
            SEXP w,
            SEXP x,
            SEXP y,
            SEXP z);

SEXP lang11(SEXP p,
            SEXP q,
            SEXP r,
            SEXP s,
            SEXP t,
            SEXP u,
            SEXP v,
            SEXP w,
            SEXP x,
            SEXP y,
            SEXP z);

SEXP list7(SEXP s, SEXP t, SEXP u, SEXP v, SEXP w, SEXP x, SEXP y);

SEXP list8(SEXP s, SEXP t, SEXP u, SEXP v, SEXP w, SEXP x, SEXP y, SEXP z);

SEXP list9(SEXP r,
           SEXP s,
           SEXP t,
           SEXP u,
           SEXP v,
           SEXP w,
           SEXP x,
           SEXP y,
           SEXP z);

SEXP list10(SEXP q,
            SEXP r,
            SEXP s,
            SEXP t,
            SEXP u,
            SEXP v,
            SEXP w,
            SEXP x,
            SEXP y,
            SEXP z);

SEXP delayed_assign(SEXP variable,
                    SEXP value,
                    SEXP eval_env,
                    SEXP assign_env,
                    SEXP rho);

SEXP system_file(SEXP path);

SEXP lookup_value(SEXP rho, SEXP value_sym, bool evaluate = false);

std::vector<std::string> get_class_names(SEXP object);

bool has_class(SEXP object, const std::string& class_name);

bool is_data_frame(SEXP object);

void set_class(SEXP object, const std::string& class_name);

void set_names(SEXP object,
               int size,
               const std::function<std::string(int index)>& get_element);

void set_row_names(SEXP object,
                   int size,
                   const std::function<std::string(int index)>& get_element);

SEXP create_character_vector(
    int size,
    const std::function<std::string(int index)>& get_element);

SEXP create_logical_vector(int size,
                           const std::function<bool(int index)>& get_element);

SEXP create_integer_vector(int size,
                           const std::function<int(int index)>& get_element);

SEXP create_data_frame(const std::vector<SEXP> columns,
                       const std::vector<std::string>& names);

SEXP create_dot_call(SEXP function, SEXP arguments);

SEXP create_assert_contract_call(SEXP arguments);

SEXP create_list(const std::vector<SEXP>& values,
                 const std::vector<std::string>& names);
}

#endif /* CONTRACTR_UTILITIES_HPP */
