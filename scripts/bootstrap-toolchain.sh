#!/usr/bin/env bash
set -euo pipefail

toolchain_blocked() {
  echo "SEAL_TOOLCHAIN_BLOCKED"
  exit 1
}

host_deps_blocked() {
  echo "SEAL_HOST_DEPS_BLOCKED"
  exit 1
}

print_versions() {
  opam --version
  ocamlc -version
  fstar.exe --version
  if command -v krml >/dev/null 2>&1; then
    krml --version
  else
    echo "krml: unavailable (optional; extraction deferred)"
  fi
}

ensure_host_deps() {
  local system
  system="$(uname -s)"

  if command -v opam >/dev/null 2>&1; then
    return 0
  fi

  case "$system" in
    Linux)
      if command -v dnf >/dev/null 2>&1; then
        local cmd="sudo dnf install -y opam ocaml ocaml-findlib gcc gcc-c++ make git curl m4 patch gmp-devel zlib-devel pkgconf-pkg-config"
        if ! command -v sudo >/dev/null 2>&1 || ! sudo -n true 2>/dev/null; then
          echo "$cmd"
          host_deps_blocked
        fi
        sudo dnf install -y opam ocaml ocaml-findlib gcc gcc-c++ make git curl m4 patch gmp-devel zlib-devel pkgconf-pkg-config || toolchain_blocked
      elif command -v apt-get >/dev/null 2>&1; then
        local cmd="sudo apt-get update && sudo apt-get install -y opam ocaml ocaml-findlib gcc g++ make git curl m4 patch pkg-config libgmp-dev zlib1g-dev"
        if ! command -v sudo >/dev/null 2>&1 || ! sudo -n true 2>/dev/null; then
          echo "$cmd"
          host_deps_blocked
        fi
        sudo apt-get update || toolchain_blocked
        sudo apt-get install -y opam ocaml ocaml-findlib gcc g++ make git curl m4 patch pkg-config libgmp-dev zlib1g-dev || toolchain_blocked
      else
        echo "No supported Linux package manager found for OPAM prerequisites."
        host_deps_blocked
      fi
      ;;
    Darwin)
      if ! command -v brew >/dev/null 2>&1; then
        echo "brew install opam ocaml gmp zlib pkg-config gnu-sed coreutils make"
        host_deps_blocked
      fi
      brew install opam ocaml gmp zlib pkg-config gnu-sed coreutils make || toolchain_blocked
      ;;
    *)
      echo "Unsupported platform: $system"
      host_deps_blocked
      ;;
  esac
}

ensure_opam_switch() {
  if ! opam switch list --short >/dev/null 2>&1; then
    opam init --disable-sandboxing -y || toolchain_blocked
  fi

  if opam switch list --short 2>/dev/null | grep -qx seal-core; then
    opam switch set seal-core || toolchain_blocked
  else
    opam switch create seal-core 4.14.2 || toolchain_blocked
  fi

  eval "$(opam env --switch=seal-core --set-switch)"
  opam update || toolchain_blocked
  opam install -y fstar || toolchain_blocked

  if [ "${SEAL_INSTALL_KARAMEL:-0}" = "1" ]; then
    if opam install -y karamel; then
      echo "KaRaMeL installed."
    else
      echo "warning: optional KaRaMeL install failed; C extraction is deferred"
    fi
  else
    echo "KaRaMeL install skipped; set SEAL_INSTALL_KARAMEL=1 to attempt optional installation."
  fi
}

ensure_host_deps
ensure_opam_switch

if ! command -v fstar.exe >/dev/null 2>&1; then
  toolchain_blocked
fi

print_versions
