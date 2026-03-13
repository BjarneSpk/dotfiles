#!/usr/bin/env bash

set -euo pipefail
# Don't react on USR1, as it is used by matugen to signal zsh to reload color theme.
trap '' USR1
source $SCRIPTS/notification_handler.sh

update_sddm=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--sddm)
            update_sddm=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--sddm] /path/to/image"
            exit 0
            ;;
        *)
            img_arg="$1"
            shift
            ;;
    esac
done

for cmd in ffmpeg matugen hyprctl; do
    command -v "$cmd" >/dev/null || { echo "$cmd missing"; exit 1; }
done

if [[ -z "${img_arg:-}" ]]; then
    if [[ ! -t 0 ]]; then
        read -r img_arg
    else
        echo "Error: No image path provided."
        echo "Usage: $0 [--sddm] /path/to/image"
        exit 1
    fi
fi

img_path="$(realpath "$img_arg")"

if [[ ! -f "$img_path" ]]; then
    echo "error: file does not exist -> $img_path"
    exit 1
fi
if ! file --mime-type -b "$img_path" | grep -q '^image/'; then
    echo "error: not a valid image"
    exit 1
fi

: "${XDG_CACHE_HOME:=$HOME/.cache}"
cache_dir="$XDG_CACHE_HOME/arch-rice/wallpaper"
mkdir -p "$cache_dir"

if [[ -f "$cache_dir/current.txt" && "$(<"$cache_dir/current.txt")" == "$img_path" ]]; then
    notify_user -a "WPChanger" -m "Wallpaper already active."
    exit 0
fi

echo "$img_path" > "$cache_dir/current.txt"

img_ext="${img_path##*.}"
img_ext="${img_ext,,}"

ln -sf "$img_path" "$cache_dir/current"

awww img "$cache_dir/current" -t random --transition-pos 0.5,0.5 --transition-fps 60 --transition-duration 1

matugen --quiet image "$(readlink -f "$img_path")" --mode dark --source-color-index 0

img_hash=$(sha1sum "$img_path" | cut -d' ' -f1)
img_blurred="$cache_dir/$img_hash.$img_ext"

# generate only if missing
if [[ ! -f "$img_blurred" ]]; then
    magick $img_path -resize 50% -blur 50x30 "$img_blurred"
fi

ln -sf "$img_blurred" "$cache_dir/current_blurred"

if [[ "$update_sddm" == true ]]; then
    sudo -v || exit 1
    sudo install -Dm0644 \
        "$img_path" \
        "/usr/share/sddm/themes/sequoia/backgrounds/current_wallpaper"
fi

notify_user -a "WPChanger" -m "Wallpaper changed to $(basename $img_path)."
