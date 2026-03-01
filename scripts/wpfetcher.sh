#!/usr/bin/env bash

set -euo pipefail

DEST="$HOME/Pictures/Wallpapers/wallhaven"
CACHE_DIR="$XDG_CACHE_HOME/arch-rice/wallpaper/wallhaven"
KEY_FILE="$XDG_CONFIG_HOME/wallhaven/api_key"

mkdir -p "$CACHE_DIR"
mkdir -p "$DEST"

categories="110"
purity="100"
query=""

while getopts "c:p:q:" opt; do
  case $opt in
    c) categories="$OPTARG" ;;
    p) purity="$OPTARG" ;;
    q) query="$OPTARG" ;;
    *) echo "Usage: $0 [-c categories] [-p purity] [-q query]"
       exit 1 ;;
  esac
done

API_URL="https://wallhaven.cc/api/v1/search?categories=$categories&purity=$purity&sorting=toplist&topRange=1y&ratios=landscape&order=desc"

if [ -n "$query" ]; then
  API_URL="$API_URL&q=$(printf '%s' "$query" | jq -sRr @uri)"
fi

cache_key=$(printf "%s" "$categories$purity$query" | sha1sum | cut -d' ' -f1)
cache_file="$CACHE_DIR/$cache_key"

if [[ -f "$cache_file" ]]; then
  cached_last_page=$(<"$cache_file")
  page=$(( (RANDOM % cached_last_page) + 1 ))
else
  page=1
fi

apikey_param=""
[ -f "$KEY_FILE" ] && apikey_param="&apikey=$(<"$KEY_FILE")"

json=$(curl -fsSL "$API_URL&page=$page$apikey_param")

last_page=$(echo "$json" | jq '.meta.last_page')
if [[ "$last_page" =~ ^[0-9]+$ && "$last_page" -gt 0 ]]; then
    echo "$last_page" > "$cache_file"
fi

count=$(echo "$json" | jq '.data | length')

if [ "$count" -eq 0 ]; then
  echo "No wallpapers found"
  exit 1
fi

rand_index=$((RANDOM % count))
image_url=$(echo "$json" | jq -r ".data[$rand_index].path")

filename=$(basename "$image_url")
filepath="$DEST/$filename"

if [ ! -f "$filepath" ]; then
  curl -fsSL "$image_url" -o "$filepath"
fi

echo $filepath
