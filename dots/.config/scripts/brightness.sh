#!/usr/bin/env bash

STATE_DIR="/tmp/ext_monitor_brightness"
mkdir -p "$STATE_DIR"

EXT_BRIGHTNESS=10
INT_BRIGHTNESS=10

set_internal() {
    brightnessctl -s set $INT_BRIGHTNESS
}

restore_internal() {
    brightnessctl -r
}

detect_monitors() {
    ddcutil detect --brief 2>/dev/null | \
        awk '/Display [0-9]+/ {print $2}'
}

set_external() {
    for disp in $(detect_monitors); do
        # Save current brightness
        current=$(ddcutil -d "$disp" getvcp 10 2>/dev/null \
                  | awk -F'current value = +' '{print $2}' \
                  | awk -F',' '{print $1}')

        if [[ -n "$current" ]]; then
            echo "$current" > "$STATE_DIR/$disp"
            ddcutil -d "$disp" setvcp 10 "$EXT_BRIGHTNESS" >/dev/null
        fi
    done
}

restore_external() {
    for file in "$STATE_DIR"/*; do
        [[ -f "$file" ]] || continue
        disp=$(basename "$file")
        val=$(cat "$file")

        ddcutil -d "$disp" setvcp 10 "$val" >/dev/null
    done
}

case "$1" in
    set)
        set_internal
        set_external
        ;;
    restore)
        restore_internal
        restore_external
        ;;
    *)
        echo "Usage: $0 {set|restore}"
        exit 1
        ;;
esac
