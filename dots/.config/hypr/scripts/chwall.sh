#!/usr/bin/env zsh

set -e

for cmd in magick matugen hyprctl realpath; do
    command -v $cmd >/dev/null || { echo "$cmd missing"; exit 1; }
done

HYPRPAPER_CONF="$HOME/dotfiles/dots/.config/hypr/hyprpaper.conf"
HYPRLOCK_WALLPAPER_CONF="$HOME/dotfiles/dots/.config/hypr/hyprlock_wallpaper.conf"
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

CURRENT=$(grep -m1 "path =" "$HYPRPAPER_CONF" 2>/dev/null | cut -d= -f2 | xargs)
if [[ "$CURRENT" == "$IMAGE_PATH" ]]; then
    echo "Wallpaper already active."
    exit 0
fi

IMAGE_DIR="$(dirname "$IMAGE_PATH")"
IMAGE_NAME="$(basename "$IMAGE_PATH")"
BLURRED_IMAGE="$IMAGE_DIR/blurred_$IMAGE_NAME"

tmp=$(mktemp)
cat >"$tmp" <<EOF
wallpaper {
    monitor =
    path = $IMAGE_PATH
    fit_mode = cover
}
splash = false
EOF
mv "$tmp" "$HYPRPAPER_CONF"

tmp=$(mktemp)
cat >"$tmp" <<EOF
background {
    monitor =
    path = $IMAGE_PATH
    blur_passes = 2
    contrast = 1
    brightness = 0.5
    vibrancy = 0.2
    vibrancy_darkness = 0.2
}
EOF
mv "$tmp" "$HYPRLOCK_WALLPAPER_CONF"

if [[ ! -f "$BLURRED_IMAGE" || "$IMAGE_PATH" -nt "$BLURRED_IMAGE" ]]; then
    magick "$IMAGE_PATH" -resize 50% "$BLURRED_IMAGE"
    magick mogrify -blur "50x30" "$BLURRED_IMAGE"
fi

echo "* { current-image: url(\"$BLURRED_IMAGE\", height); }" >"$ROFI_BLUR_CONF"

# turn off monitor after the script if disabled, as matugen calls hyprctl reload
BUILTIN_WAS_DISABLED=false
if ! hyprctl monitors -j 2>/dev/null | grep -q '"name": "eDP-1"'; then
    BUILTIN_WAS_DISABLED=true
fi

matugen image "$IMAGE_PATH" --mode dark

if [[ "$BUILTIN_WAS_DISABLED" == true ]]; then
    hyprctl keyword monitor "eDP-1,disable"
fi

hyprctl hyprpaper wallpaper ",$IMAGE_PATH"

if read -q "REPLY?Update SDDM background as well? (requires sudo) [y/N] "; then
    echo
    sudo -v || exit 1
    sudo install -m 0644 "$IMAGE_PATH" \
        "/usr/share/sddm/themes/sequoia/backgrounds/current_wallpaper.jpg"
else
    echo
    echo "Skipping SDDM background update."
fi
