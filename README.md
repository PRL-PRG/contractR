<!-- badges: start -->
[![R-CMD-check](https://github.com/PRL-PRG/contractr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PRL-PRG/contractr/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/PRL-PRG/contractr/branch/master/graph/badge.svg)](https://codecov.io/gh/PRL-PRG/contractr)
[![r-universe](https://prl-prg.r-universe.dev/contractr/badges/version)](https://prl-prg.r-universe.dev/contractr)
[![mutator](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2FPRL-PRG%2Fcontractr%2Fgh-pages%2Fmutation-score.json)](https://github.com/PRL-PRG/contractr/actions/workflows/mutation-testing.yaml)
<!-- badges: end -->

# contractr

`contractr` adds run-time type contracts to R functions. You annotate a
function with a type declaration; `contractr` injects assertions that check the
arguments and the return value against that type every time the function is
called, warning (or erroring, depending on the configured severity) whenever a
value does not conform.

Types are written in the [tastr](https://github.com/PRL-PRG/tastr) type-declaration
language.

## Installation

`contractr` is published on the PRL-PRG r-universe:

```r
install.packages("contractr", repos = "https://prl-prg.r-universe.dev")
```

To install from source you need a C++17 compiler. The
[tastr](https://github.com/PRL-PRG/tastr) type library is bundled as a git
submodule and built automatically at install time, so clone recursively:

```sh
git clone --recurse-submodules https://github.com/PRL-PRG/contractr
R CMD INSTALL contractr
```

## Usage

```r
library(contractr)

greet <- function(name) paste("hi", name)

# require a double argument and a character result
insert_contract(greet, "<double> => character")

greet(42)      # ok
greet("bob")   # contract violation: parameter 'name' expected double, actual character
```

You can also check or infer a value's type directly:

```r
check_type(2L, "double")   # TRUE
infer_type(c(1.0, 2.0))    # "double[]"
```

