#!/usr/bin/env bash

set -euo pipefail

if [[ ${EUID:-0} -ne 0 ]]; then
  if ! command -v sudo >/dev/null 2>&1; then
    echo "This script must run as root (sudo not found)."
    exit 1
  fi
  exec sudo -- "$0" "$@"
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SYSTEM_DIR="$SCRIPT_DIR/system"

if [[ ! -d "$SYSTEM_DIR" ]]; then
  echo "system/ directory not found."
  exit 1
fi

while IFS= read -r -d '' src; do
  rel_path="${src#$SYSTEM_DIR/}"
  dest="/$rel_path"
  mode="$(stat -c '%a' "$src")"

  if [[ -L "$dest" ]]; then
    rm -f "$dest"
  fi

  install -D -o root -g root -m "$mode" "$src" "$dest"
done < <(find "$SYSTEM_DIR" -type f -print0)

echo "System files installed."
