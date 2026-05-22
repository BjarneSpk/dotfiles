#!/usr/bin/env bash

STATE_DIR="/tmp/ext_monitor_brightness"
MON_FILE="$STATE_DIR/monitors"

mkdir -p "$STATE_DIR/current/"
mkdir -p "$STATE_DIR/restore/"

clamp() {
    local val=$1
    (( val < 0 )) && val=0
    (( val > 100 )) && val=100
    echo "$val"
}

get_internal() {
    brightnessctl g
}

set_internal() {
    brightnessctl -s set "$1%" >/dev/null
}

restore_internal() {
    brightnessctl -r >/dev/null
}

detect_monitors() {
    ddcutil detect --brief 2>/dev/null \
        | awk '/Display [0-9]+/ {print $2}'
}

get_monitors() {
    if [[ ! -f "$MON_FILE" ]]; then
        detect_monitors > "$MON_FILE"
    fi
    cat "$MON_FILE"
}

get_external_brightness() {
    local disp=$1
    ddcutil -d "$disp" getvcp 10 2>/dev/null \
        | awk -F'current value = +' '{print $2}' \
        | awk -F',' '{print $1}'
}

set_external_all() {
    local target=$1

    for disp in $(get_monitors); do
        current=$(get_external_brightness "$disp")
        [[ -z "$current" ]] && continue

        echo "$current" > "$STATE_DIR/restore/$disp"

        # Fast write (no readback verification)
        ddcutil -d "$disp" setvcp 10 "$target" --noverify >/dev/null
    done
}

adjust_external() {
    local delta=$1

    for disp in $(get_monitors); do
        file="$STATE_DIR/current/$disp"

        if [[ -f "$file" ]]; then
            current=$(cat "$file")
        else
            current=$(get_external_brightness "$disp")
        fi

        [[ -z "$current" ]] && continue

        new=$(clamp $(( current + delta )))
        echo "$new" > "$file"

        ddcutil -d "$disp" setvcp 10 "$new" --noverify >/dev/null
    done
}

restore_external() {
    for file in "$STATE_DIR"/restore/*; do
        [[ -f "$file" ]] || continue
        disp=$(basename "$file")
        val=$(cat "$file")

        ddcutil -d "$disp" setvcp 10 "$val" --verify >/dev/null
    done
}

set_all() {
    local val
    val=$(clamp "$1")

    set_internal "$val"
    set_external_all "$val"
}

case "$1" in
    set)
        [[ -z "$2" ]] && { echo "Missing brightness value"; exit 1; }
        set_all "$2"
        ;;

    increase)
        [[ -z "$2" ]] && { echo "Missing increase value"; exit 1; }
        brightnessctl -e4 -n2 set "$2%+" >/dev/null
        adjust_external "$2"
        ;;

    decrease)
        [[ -z "$2" ]] && { echo "Missing decrease value"; exit 1; }
        brightnessctl -e4 -n2 set "$2%-" >/dev/null
        adjust_external "-$2"
        ;;

    restore)
        restore_internal
        restore_external
        ;;

    redetect)
        detect_monitors > "$MON_FILE"
        echo "Monitors redetected"
        ;;

    *)
        echo "Usage:"
        echo "  $0 set <percent>"
        echo "  $0 increase <percent>"
        echo "  $0 decrease <percent>"
        echo "  $0 restore"
        echo "  $0 redetect   (if monitors changed)"
        exit 1
        ;;
esac
