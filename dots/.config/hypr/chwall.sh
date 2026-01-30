#!/usr/bin/env zsh

set -e

HYPERPAPER_CONF="$HOME/dotfiles/dots/.config/hypr/hyprpaper.conf"
ROFI_BLUR_CONF="$HOME/.config/rofi/blurred_wall.rasi"

if [[ -z "$1" ]]; then
    echo "usage: $0 /path/to/image"
    exit 1
fi

IMAGE_PATH="$(realpath "$1")"

if [[ ! -f "$IMAGE_PATH" ]]; then
    echo "error: file does not exist -> $IMAGE_PATH"
    exit 1
fi

IMAGE_DIR="$(dirname "$IMAGE_PATH")"
IMAGE_NAME="$(basename "$IMAGE_PATH")"
BLURRED_IMAGE="$IMAGE_DIR/blurred_$IMAGE_NAME"

cat >"$HYPERPAPER_CONF" <<EOF
wallpaper {
    monitor =
    path = $IMAGE_PATH
    fit_mode = cover
}
splash = false
EOF

magick "$IMAGE_PATH" -resize 50% "$BLURRED_IMAGE"
magick "$BLURRED_IMAGE" -blur "50x30" "$BLURRED_IMAGE"

echo "* { current-image: url(\"$BLURRED_IMAGE\", height); }" >"$ROFI_BLUR_CONF"

# turn off monitor after the script if disabled, as matugen calls hyprctl reload
BUILTIN_WAS_DISABLED=false
if ! hyprctl monitors | grep -q "Monitor eDP-1"; then
    BUILTIN_WAS_DISABLED=true
fi

matugen image "$IMAGE_PATH" --mode dark

if [[ "$BUILTIN_WAS_DISABLED" == true ]]; then
    hyprctl keyword monitor "eDP-1,disable"
fi

hyprctl hyprpaper wallpaper ",$IMAGE_PATH"
