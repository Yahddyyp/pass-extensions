#!/bin/bash
# pass-lazygit: open lazygit in the password-store git repo
#
# Requires: lazygit, and the store must be a git repo
#
# Install:
#   cp lazygit.bash "${PASSWORD_STORE_EXTENSIONS_DIR:-$HOME/.password-store/.extensions}/lazygit.bash"
#   chmod +x "${PASSWORD_STORE_EXTENSIONS_DIR:-$HOME/.password-store/.extensions}/lazygit.bash"
#
# Usage:
#   pass lazygit [lazygit-options]

set -o pipefail

cmd_lazygit() {
  if ! command -v lazygit >/dev/null 2>&1; then
    echo "Error: lazygit is not installed or not in PATH" >&2
    exit 1
  fi

  if [[ ! -d "$PREFIX/.git" ]]; then
    echo "Error: $PREFIX is not a git repository (run 'pass git init' first baka)" >&2
    exit 1
  fi

  cd "$PREFIX" && lazygit "$@"
}

cmd_lazygit "$@"
