#!/usr/bin/env bash
# pass-fd: find password-store entries using fd
#
# Requires: fd, tree
#
# Install (adjust for your PASSWORD_STORE_EXTENSIONS_DIR if set):
#   cp fd.bash "${PASSWORD_STORE_EXTENSIONS_DIR:-$HOME/.password-store/.extensions}/fd.bash"
#   chmod +x "${PASSWORD_STORE_EXTENSIONS_DIR:-$HOME/.password-store/.extensions}/fd.bash"
#
# Usage:
#   pass fd [fd-options] <pattern>
#
# Examples:
#   pass fd github
#   pass fd -i aws

set -o pipefail

cmd_fd() {
  local -a fd_opts=()
  local pattern=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -*) fd_opts+=("$1") ;;
    *) pattern="$1" ;;
    esac
    shift
  done

  if [[ -z "$pattern" ]]; then
    echo "Usage: $PROGRAM fd [fd-options] <pattern>" >&2
    exit 1
  fi

  if ! command -v fd >/dev/null 2>&1; then
    echo "Error: fd is not installed or not in PATH" >&2
    exit 1
  fi
  if ! command -v tree >/dev/null 2>&1; then
    echo "Error: tree is not installed or not in PATH" >&2
    exit 1
  fi

  echo "Search Terms: $pattern"

  local matches
  matches="$(cd "$PREFIX" && fd --extension gpg --type f "${fd_opts[@]}" "$pattern" 2>/dev/null)"

  [[ -z "$matches" ]] && return 0

  echo "$matches" |
    tree -C --noreport --fromfile |
    tail -n +2 |
    sed -E 's/\.gpg(\x1B\[[0-9]+m)?( ->|$)/\1\2/g'
}

cmd_fd "$@"
