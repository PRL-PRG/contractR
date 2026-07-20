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

# Building the parser needs flex and bison; declare them in DESCRIPTION's
# SystemRequirements so r-universe / CRAN system-dependency resolvers install
# them (see rstudio/r-system-requirements).
for tool in flex bison make; do
    command -v "$tool" >/dev/null 2>&1 || {
        echo "ERROR: '$tool' is required to build tastr but was not found." >&2
        exit 1
    }
done

# Use R's C++ compiler rather than tastr's hard-coded clang++.
CXX_BIN=${CXX:-c++}
echo "contractr: building tastr (CXX=$CXX_BIN) ..."
make -C "$TASTR_DIR" CXX="$CXX_BIN" parser lexer header static-library
echo "contractr: built $LIB"
