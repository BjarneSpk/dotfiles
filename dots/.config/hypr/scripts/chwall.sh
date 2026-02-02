#!/usr/bin/env zsh

set -euo pipefail

for cmd in ffmpeg matugen hyprctl realpath; do
    command -v "$cmd" >/dev/null || { echo "$cmd missing"; exit 1; }
done

HYPRPAPER_CONF="$DOTFILES/dots/.config/hypr/hyprpaper.conf"
HYPRLOCK_WALLPAPER_CONF="$DOTFILES/dots/.config/hypr/hyprlock_wallpaper.conf"
ROFI_BLUR_CONF="$XDG_CONFIG_HOME/rofi/blurred_wall.rasi"

if [[ -z "${1:-}" ]]; then
    echo "usage: $0 /path/to/image" >&2
    exit 1
fi
IMAGE_PATH="$(realpath "$1")"

if [[ ! -f "$IMAGE_PATH" ]]; then
    echo "error: file does not exist -> $IMAGE_PATH"
    exit 1
fi

CURRENT=$(awk -F'= *' '/path =/ {print $2; exit}' "$HYPRPAPER_CONF")
if [[ "$CURRENT" == "$IMAGE_PATH" ]]; then
    echo "Wallpaper already active."
    exit 0
fi

tmpfiles=()

tmp1=$(mktemp)
tmpfiles+=("$tmp1")
cat >"$tmp1" <<EOF
wallpaper {
    monitor =
    path = $IMAGE_PATH
    fit_mode = cover
}
splash = false
EOF

tmp2=$(mktemp)
tmpfiles+=("$tmp2")
cat >"$tmp2" <<EOF
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

trap 'for f in "${tmpfiles[@]}"; do [[ -f "$f" ]] && rm -f "$f"; done' EXIT

install -Dm644 "$tmp1" "$HYPRPAPER_CONF"
install -Dm644 "$tmp2" "$HYPRLOCK_WALLPAPER_CONF"

CACHE_DIR="$XDG_CACHE_HOME/wallpaper_blur"
mkdir -p "$CACHE_DIR"

IMAGE_HASH=$(sha1sum "$IMAGE_PATH" | cut -d' ' -f1)
BLURRED_IMAGE="$CACHE_DIR/${IMAGE_HASH}.jpg"

# generate only if missing
if [[ ! -f "$BLURRED_IMAGE" ]]; then
    ffmpeg -v error -y -i "$IMAGE_PATH" -vf "scale=iw/2:ih/2,gblur=sigma=15,gblur=sigma=15,gblur=sigma=15" "$BLURRED_IMAGE" &
fi

echo "* { current-image: url(\"$BLURRED_IMAGE\", height); }" >"$ROFI_BLUR_CONF"

# turn off monitor after the script if disabled, as matugen calls hyprctl reload
BUILTIN_WAS_DISABLED=false
if ! hyprctl monitors -j 2>/dev/null | grep -q '"name": *"eDP-1"'; then
    BUILTIN_WAS_DISABLED=true
fi

matugen image "$IMAGE_PATH" --mode dark >/dev/null

if [[ "$BUILTIN_WAS_DISABLED" == true ]]; then
    hyprctl keyword monitor "eDP-1,disable"
fi

hyprctl hyprpaper wallpaper ",$IMAGE_PATH"

if read -q "REPLY?Update SDDM background as well? (requires sudo) [y/N] "; then
    echo
    sudo -v || exit 1
    sudo install -Dm0644 "$IMAGE_PATH" "/usr/share/sddm/themes/sequoia/backgrounds/current_wallpaper.jpg"
else
    echo
    echo "Skipping SDDM background update."
fi

wait
