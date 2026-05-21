#!/usr/bin/env bash

SAVE_DIR=$HOME/Pictures/Screenshots
NAME=screenshot_$(date +%Y%m%d_%H%M%S).png

# Notifications
source "$SCRIPTS/notification_handler.sh"
APP_NAME="Screen Capture"
NOTIFICATION_ICON="camera-photo-symbolic"

# Quick instant mode: full screen
take_instant_full() {
  [[ -d "$SAVE_DIR" && -w "$SAVE_DIR" ]] && grim -l 1 "$SAVE_DIR/$NAME" && wl-copy --type image/png <"$SAVE_DIR/$NAME"

  [[ -f "$SAVE_DIR/$NAME" ]] && notify_user \
    -a "${APP_NAME}" \
    -i "$SAVE_DIR/$NAME" \
    -s "Screenshot saved" \
    -m "$SAVE_DIR/$NAME" \
    -t 3000

}

# Handle instant flags
if [[ "$1" == "--instant" ]]; then
    take_instant_full
    exit 0
fi
