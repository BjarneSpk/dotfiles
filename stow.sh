#!/usr/bin/env bash

set -euo pipefail

if [[ ${EUID:-0} -eq 0 ]]; then
  echo "Run this as your user, not root."
  exit 1
fi

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is not installed. Install it and try again."
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

HOME_TARGET="$HOME"
BIN_TARGET="$HOME/.local/bin"

mkdir -p "$BIN_TARGET"

if [[ -d "$SCRIPT_DIR/home" ]]; then
  stow -t "$HOME_TARGET" home
fi

if [[ -d "$SCRIPT_DIR/bin" ]]; then
  stow -t "$BIN_TARGET" bin
fi

if [[ -d "$SCRIPT_DIR/system" ]]; then
  sudo stow -t / system
fi

echo "Stow complete."
