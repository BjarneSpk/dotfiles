#!/usr/bin/env bash

# CONFIG
QML_PATH="$XDG_CONFIG_HOME/quickshell/WallpaperPicker.qml"
SRC_DIR="$HOME/Pictures/Wallpapers"
THUMB_DIR="$XDG_CACHE_HOME/arch-rice/wallpaper/thumbs"

# 1. Kill if running
if pgrep -f "quickshell.*WallpaperPicker.qml" > /dev/null; then
    pkill -f "quickshell.*WallpaperPicker.qml"
    exit 0
fi

# 2. Cleanup and Sync Thumbs (Backgrounded)
mkdir -p "$THUMB_DIR"
(
    # --- CLEANUP: Remove thumbnails that no longer have a source wallpaper ---
    for thumb in "$THUMB_DIR"/*; do
        [ -e "$thumb" ] || continue
        filename=$(basename "$thumb")

        # Remove "000_" prefix to check against real source file
        clean_name="${filename#000_}"

        # Decode % back to / to reconstruct subfolder path
        source_rel="${clean_name//%//}"

        if [ ! -f "$SRC_DIR/$source_rel" ]; then
            rm "$thumb"
        fi
    done

    # # --- GENERATE: Create thumbnails for new or renamed wallpapers ---
    # while IFS= read -r img; do
    #     [ -e "$img" ] || continue
    #     # Use relative path with / replaced by % to support subfolders without collisions
    #     rel_path=$(realpath --relative-to="$SRC_DIR" "$img")
    #     filename="${rel_path//\//%}"
    #     extension="${filename##*.}"
    #
    #     # Determine if video to apply sorting prefix
    #     if [[ "${extension,,}" =~ ^(mp4|mkv|mov|webm)$ ]]; then
    #         # Prefix video thumbs with 000_ so they appear first in the list
    #         thumb="$THUMB_DIR/000_$filename"
    #
    #         # Ensure we don't have a non-prefixed old version lying around
    #         [ -f "$THUMB_DIR/$filename" ] && rm "$THUMB_DIR/$filename"
    #
    #         if [ ! -f "$thumb" ]; then
    #              ffmpeg -y -ss 00:00:05 -i "$img" -vframes 1 -f image2 -q:v 2 "$thumb" > /dev/null 2>&1
    #         fi
    #     else
    #         # Standard images
    #         thumb="$THUMB_DIR/$filename"
    #         if [ ! -f "$thumb" ]; then
    #             # Escape % as %% so ImageMagick doesn't treat it as a format specifier
    #             magick "$img" -resize x420 -quality 70 "${thumb//\%/%%}"
    #         fi
    #     fi
    # done < <(find "$SRC_DIR" \
    #   \( -path "$SRC_DIR/too_small" -o -path "$SRC_DIR/wallhaven" \) -prune -o \
    #   -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \) -print)
) &

# 3. Detect Active Wallpaper & Calculate Index
TARGET_INDEX=0
CURRENT_SRC=$(cat "$XDG_CACHE_HOME/arch-rice/wallpaper/current.txt" 2>/dev/null)

if [ -n "$CURRENT_SRC" ]; then
    # Encode relative path (with / → %) to match thumbnail naming
    rel_path=$(realpath --relative-to="$SRC_DIR" "$CURRENT_SRC" 2>/dev/null)
    CURRENT_THUMB="${rel_path//\//%}"

    # Determine expected thumbnail name (add 000_ prefix for videos)
    EXT="${CURRENT_THUMB##*.}"
    if [[ "${EXT,,}" =~ ^(mp4|mkv|mov|webm)$ ]]; then
        TARGET_THUMB="000_$CURRENT_THUMB"
    else
        TARGET_THUMB="$CURRENT_THUMB"
    fi

    # Find index in the thumb dir (sorted alphabetically to match FolderListModel)
    # LC_ALL=C ensures byte-order sort, matching Qt's FolderListModel.Name sort on Linux
    MATCH_LINE=$(LC_ALL=C ls -1 "$THUMB_DIR" | grep -nxF "$TARGET_THUMB" | cut -d: -f1)
    
    if [ -n "$MATCH_LINE" ]; then
        TARGET_INDEX=$((MATCH_LINE - 1))
    fi
else
  echo "wallpaper not set in current.txt"
  exit 1
fi

export WALLPAPER_INDEX="$TARGET_INDEX"
export CURRENT_WALLPAPER="$CURRENT_SRC"

# 4. Launch Quickshell
quickshell -p "$QML_PATH" &

# 5. FORCE FOCUS
sleep 0.2
hyprctl dispatch focuswindow "quickshell"

