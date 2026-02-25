#!/usr/bin/env bash

MONITOR="eDP-1"
MODE="1920x1080@60"
POS="0x0"
SCALE="1"

case "$1" in
    off)
        hyprctl keyword monitor "$MONITOR, disable"
        ;;
    on)
        hyprctl keyword monitor "$MONITOR, $MODE, $POS, $SCALE"
        ;;
    *)
        if hyprctl monitors | grep -q "^Monitor $MONITOR"; then
            hyprctl keyword monitor "$MONITOR, disable"
        else
            hyprctl keyword monitor "$MONITOR, $MODE, $POS, $SCALE"
        fi
        ;;
esac
