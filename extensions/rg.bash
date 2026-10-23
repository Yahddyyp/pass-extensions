#!/usr/bin/env bash
# pass-rg: search decrypted password-store entries using ripgrep
#
# Install:
#   mkdir -p "${PASSWORD_STORE_EXTENSIONS_DIR:-$HOME/.password-store/.extensions}"
#   cp rg.bash "${PASSWORD_STORE_EXTENSIONS_DIR:-$HOME/.password-store/.extensions}/rg.bash"
#   chmod +x "${PASSWORD_STORE_EXTENSIONS_DIR:-$HOME/.password-store/.extensions}/rg.bash"
#   export PASSWORD_STORE_ENABLE_EXTENSIONS=true
#
# Usage:
#   pass rg [ripgrep-options] <pattern>
#
# Examples:
#   pass rg "user@example.com"
#   pass rg -i "aws.*secret"
#   pass rg -w login

set -o pipefail

cmd_rg() {
  local -a rg_opts=()
  local pattern=""

  # last non-option argument is the pattern, everything else passes through to rg
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -*) rg_opts+=("$1") ;;
    *) pattern="$1" ;;
    esac
    shift
  done

  if [[ -z "$pattern" ]]; then
    echo "Usage: $PROGRAM rg [ripgrep-options] <pattern>" >&2
    exit 1
  fi

  if ! command -v rg >/dev/null 2>&1; then
    echo "Error: ripgrep (rg) is not installed or not in PATH" >&2
    exit 1
  fi

  local file
  find "$PREFIX" -iname '*.gpg' -print0 | while IFS= read -r -d "" file; do
    local passfile="${file%.gpg}"
    passfile="${passfile#"$PREFIX"/}"

    local out
    out="$("$GPG" -d "${GPG_OPTS[@]}" "$file" 2>/dev/null | rg --color=always "${rg_opts[@]}" -- "$pattern")"

    if [[ -n "$out" ]]; then
      printf '\033[1;34m%s\033[0m:\n' "$passfile"
      echo "$out" | sed 's/^/  /'
    fi
  done
}

cmd_rg "$@"
