#!/usr/bin/env bash
set -euo pipefail

if command -v opam >/dev/null 2>&1 && opam switch list --short 2>/dev/null | grep -qx seal-core; then
  eval "$(opam env --switch=seal-core --set-switch)"
fi

status=0

echo "SEAL toolchain report"

if command -v opam >/dev/null 2>&1; then
  echo "opam: $(opam --version)"
else
  echo "opam: missing (warning: required only for OPAM-managed installs)"
fi

if command -v ocamlc >/dev/null 2>&1; then
  echo "ocamlc: $(ocamlc -version)"
else
  echo "ocamlc: missing"
fi

if command -v fstar.exe >/dev/null 2>&1; then
  echo "fstar.exe: $(fstar.exe --version)"
else
  echo "fstar.exe: missing"
  status=1
fi

if command -v krml >/dev/null 2>&1; then
  echo "krml: $(krml --version)"
else
  echo "krml: missing (warning: C extraction is deferred)"
fi

if command -v make >/dev/null 2>&1; then
  echo "make: $(make --version | sed -n '1p')"
else
  echo "make: missing"
  status=1
fi

exit "$status"
