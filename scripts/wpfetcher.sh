#!/usr/bin/env bash
set -euo pipefail

DEST="$HOME/Pictures/Wallpapers/wallhaven"
CACHE_DIR="$XDG_CACHE_HOME/arch-rice/wallpaper/wallhaven"
KEY_FILE="$XDG_CONFIG_HOME/wallhaven/api_key"

categories="110"
purity="100"
query=""
download_all=false

init_dirs() {
  mkdir -p "$CACHE_DIR" "$DEST"
}

parse_args() {
  while getopts "c:p:q:a" opt; do
    case $opt in
      c) categories="$OPTARG" ;;
      p) purity="$OPTARG" ;;
      q) query="$OPTARG" ;;
      a) download_all=true ;;
      *) echo "Usage: $0 [-c categories] [-p purity] [-q query] [-a]"
         exit 1 ;;
    esac
  done
}

build_api_url() {
  local url="https://wallhaven.cc/api/v1/search"
  url+="?categories=$categories"
  url+="&purity=$purity"
  url+="&sorting=toplist&topRange=1y"
  url+="&ratios=landscape&order=desc"

  if [[ -n "$query" ]]; then
    local encoded=$(printf '%s' "$query" | jq -sRr @uri)
    url+="&q=$encoded"
  fi

  printf '%s\n' "$url"
}

read_api_key_param() {
  [[ -f "$KEY_FILE" ]] && printf '&apikey=%s' "$(<"$KEY_FILE")"
}

fetch_json() {
  curl -fsSL "$1"
}

download_if_needed() {
  local image_url="$1"

  local filename
  filename=$(basename "$image_url")
  local filepath="$DEST/$filename"

  if [[ ! -f "$filepath" ]]; then
    curl -fsSL "$image_url" -o "$filepath"
  fi

  printf '%s\n' "$filepath"
}

download_all_pages() {
  local api_url="$1"
  local apikey="$2"

  echo "Fetching first page to determine total pages..."
  local first_json
  first_json=$(fetch_json "$api_url&page=1$apikey")

  local last_page
  last_page=$(jq '.meta.last_page' <<<"$first_json")

  for ((page=1; page<=last_page; page++)); do
    echo "Processing page $page / $last_page"

    local json
    if [[ "$page" -eq 1 ]]; then
      json="$first_json"
    else
      json=$(fetch_json "$api_url&page=$page$apikey")
    fi

    jq -r '.data[].path' <<<"$json" | while read -r url; do
      download_if_needed "$url"
      sleep 2
    done
  done
}

extract_random_image_url() {
  local json="$1"

  local count
  count=$(jq '.data | length' <<<"$json")

  if [[ "$count" -eq 0 ]]; then
    notify-send "WPFetcher" "No wallpapers found"
    exit 1
  fi

  local index=$((RANDOM % count))
  jq -r ".data[$index].path" <<<"$json"
}

cache_file_for_query() {
  local key=$(printf "%s" "$categories$purity$query" | sha1sum | cut -d' ' -f1)
  printf '%s/%s\n' "$CACHE_DIR" "$key"
}

pick_page() {
  local cache_file="$1"

  if [[ -f "$cache_file" ]]; then
    local last_page=$(<"$cache_file")
    printf '%d\n' $(( (RANDOM % last_page) + 1 ))
  else
    printf '1\n'
  fi
}

update_cache() {
  local cache_file="$1"
  local json="$2"

  local last_page=$(jq '.meta.last_page' <<<"$json")

  if [[ "$last_page" =~ ^[0-9]+$ && "$last_page" -gt 0 ]]; then
    echo "$last_page" > "$cache_file"
  fi
}

main() {
  init_dirs
  parse_args "$@"

  local api_url=$(build_api_url)

  local apikey=$(read_api_key_param)

  if $download_all; then
    download_all_pages "$api_url" "$apikey"
  else
    # Original behavior (download one random wallpaper)
    local cache_file=$(cache_file_for_query)
    local page=$(pick_page "$cache_file")

    local json=$(fetch_json "$api_url&page=$page$apikey")

    update_cache "$cache_file" "$json"

    local image_url=$(extract_random_image_url "$json")

    download_if_needed "$image_url"
  fi
}

main "$@"
