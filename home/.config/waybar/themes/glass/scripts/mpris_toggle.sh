#!/usr/bin/env bash

set -u

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

playing_player=""
paused_player=""
while IFS= read -r p; do
  [ -n "$p" ] || continue
  status="$(playerctl -p "$p" status 2>/dev/null || true)"
  if [ "$status" = "Playing" ]; then
    playing_player="$p"
    break
  fi
  if [ "$status" = "Paused" ] && [ -z "$paused_player" ]; then
    paused_player="$p"
  fi
done < <(playerctl -l 2>/dev/null || true)

target_player="$playing_player"
[ -n "$target_player" ] || target_player="$paused_player"

if [ -z "$target_player" ]; then
  printf '{"text":"","tooltip":""}\n'
  exit 0
fi

status="$(playerctl -p "$target_player" status 2>/dev/null || true)"
if [ "$status" = "Playing" ]; then
  icon=""
  tooltip="Pause"
else
  icon=""
  tooltip="Play"
fi

printf '{"text":"%s","tooltip":"%s"}\n' "$(json_escape "$icon")" "$(json_escape "$tooltip")"
