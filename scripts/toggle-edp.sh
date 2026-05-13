#!/usr/bin/env bash

MONITOR="eDP-1"

monitor_is_on() {
    hyprctl monitors all -j | jq -e --arg monitor "$MONITOR" '
        first(.[] | select((.name // .output // "") == $monitor))
        | ((.disabled // false) | not)
        and (.dpmsStatus // true)
    ' >/dev/null
}

disable_monitor() {
    hyprctl eval "hl.monitor({ output = \"$MONITOR\", disabled = true })"
}

enable_monitor() {
    hyprctl eval "hl.monitor({ output = \"$MONITOR\", mode = \"preferred\", position = \"auto\", scale = 1 })"
}

case "${1:-toggle}" in
    off)
        disable_monitor
        ;;
    on)
        enable_monitor
        ;;
    *)
        if monitor_is_on; then
            disable_monitor
        else
            enable_monitor
        fi
        ;;
esac
