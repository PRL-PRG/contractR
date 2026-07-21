#!/bin/sh
# Build the tastr static library that contractr links against.
#
# tastr is vendored as a git submodule at the package root. This script makes
# sure the submodule is checked out and then builds just the static library and
# its headers (build/lib/libtastr.a, build/include/tastr/...). It is idempotent:
# if the library already exists it does nothing, so it is safe to call from both
# the r-universe `.prepare` hook and the top-level `configure` script.
set -e

PKG_ROOT=$(cd "$(dirname "$0")/.." && pwd)
TASTR_DIR="$PKG_ROOT/tastr"
LIB="$TASTR_DIR/build/lib/libtastr.a"

# Nothing to do if the library is already built.
if [ -f "$LIB" ]; then
    echo "contractr: tastr already built ($LIB)"
    exit 0
fi

# Make sure the submodule sources are present.
if [ ! -f "$TASTR_DIR/Makefile" ]; then
    if [ -f "$PKG_ROOT/.gitmodules" ] && command -v git >/dev/null 2>&1; then
        echo "contractr: initialising tastr submodule..."
        (cd "$PKG_ROOT" && git submodule update --init --recursive tastr)
    fi
fi
if [ ! -f "$TASTR_DIR/Makefile" ]; then
    echo "ERROR: tastr sources not found at $TASTR_DIR." >&2
    echo "       Run: git submodule update --init --recursive" >&2
    exit 1
fi

# `make` is always required.
command -v make >/dev/null 2>&1 || {
    echo "ERROR: 'make' is required to build tastr but was not found." >&2
    exit 1
}

# tastr ships the generated flex/bison output (Parser.cxx/.hxx, Lexer.cxx/.hxx)
# in the repository. Regenerating it is only necessary when the grammar changes,
# and requires a modern flex + bison (the version bundled with macOS is too old).
# When the generated sources are present we bump the mtimes of the make sentinels
# and outputs so make treats the parser/lexer as up-to-date and skips flex/bison
# entirely -- this keeps CI and end-user builds portable, needing only a C++
# compiler. flex/bison are still declared in SystemRequirements for the grammar
# workflow (see rstudio/r-system-requirements).
GEN="$TASTR_DIR/src/parser/Parser.cxx $TASTR_DIR/src/parser/Lexer.cxx \
     $TASTR_DIR/include/parser/Parser.hxx $TASTR_DIR/include/parser/Lexer.hxx"
have_generated=1
for f in $GEN; do
    [ -f "$f" ] || have_generated=0
done

if [ "$have_generated" -eq 1 ]; then
    echo "contractr: using tastr's committed parser/lexer (skipping flex/bison)"
    # Order matters: grammar first, then sentinels, then generated outputs, so
    # every generated file is newer than its grammar prerequisite.
    touch "$TASTR_DIR/grammar/Parser.yxx" "$TASTR_DIR/grammar/Lexer.lxx"
    touch "$TASTR_DIR/.parser.sentinel" "$TASTR_DIR/.lexer.sentinel"
    touch $GEN
else
    echo "contractr: generated parser/lexer missing, regenerating with flex/bison"
    for tool in flex bison; do
        command -v "$tool" >/dev/null 2>&1 || {
            echo "ERROR: '$tool' is required to regenerate the tastr parser but was not found." >&2
            exit 1
        }
    done
fi

# Use R's C++ compiler rather than tastr's hard-coded clang++.
CXX_BIN=${CXX:-c++}
echo "contractr: building tastr (CXX=$CXX_BIN) ..."
make -C "$TASTR_DIR" CXX="$CXX_BIN" parser lexer header static-library
echo "contractr: built $LIB"
