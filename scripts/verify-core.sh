#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if command -v opam >/dev/null 2>&1 && opam switch list --short 2>/dev/null | grep -qx seal-core; then
  eval "$(opam env --switch=seal-core --set-switch)"
fi

if ! command -v fstar.exe >/dev/null 2>&1; then
  echo "fstar.exe: missing"
  exit 1
fi

mkdir -p build/fstar-cache build/toolchain-bin

if ! command -v z3-4.13.3 >/dev/null 2>&1 && command -v z3 >/dev/null 2>&1; then
  z3_version="$(z3 --version | sed -n '1p')"
  if [ "${z3_version#Z3 version 4.13.3}" != "$z3_version" ]; then
    ln -sf "$(command -v z3)" build/toolchain-bin/z3-4.13.3
    export PATH="$ROOT/build/toolchain-bin:$PATH"
  fi
fi

fstar.exe \
  --include src \
  --cache_dir build/fstar-cache \
  --odir build/fstar-cache \
  src/Seal.Types.fst \
  src/Seal.Policy.fst \
  src/Seal.Gate.fst \
  src/Seal.Proofs.fst

echo "SEAL_CORE_VERIFIED"
