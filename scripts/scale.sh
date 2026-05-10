#!/usr/bin/env bash
monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
current=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .scale')
width=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .width')
height=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .height')

is_valid_scale() {
    local scale=$1
    jq -n --argjson w "$width" --argjson h "$height" --argjson s "$scale" '
        (($w / $s) - ($w / $s | floor)) < 0.001 and
        (($h / $s) - ($h / $s | floor)) < 0.001
    '
}

find_next_valid() {
    local current=$1
    local dir=$2

    if [[ "$dir" == "increase" ]]; then
        candidates=$(seq 1 200 | awk -v c="$current" '{printf "%.2f\n", c + $1*0.01}')
    else
        candidates=$(seq 1 200 | awk -v c="$current" '{printf "%.2f\n", c - $1*0.01}')
    fi

    while IFS= read -r candidate; do
        if [[ $(is_valid_scale "$candidate") == "true" ]]; then
            echo "$candidate"
            return
        fi
    done <<< "$candidates"

    echo "$current"
}

new=$(find_next_valid "$current" "$1")

if [[ "$new" == "$current" ]]; then
    echo "No valid scale found in that direction"
    exit 1
fi

hyprctl keyword monitor "$monitor,preferred,auto,$new"
