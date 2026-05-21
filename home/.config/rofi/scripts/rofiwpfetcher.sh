#!/usr/bin/env bash
# Rofi custom script mode wallpaper fetcher.
# Run via: rofi -show wpfetch -modi "wpfetch:~/.config/rofi/scripts/rofiwpfetcher.sh"
#
# ROFI_RETV: 0=initial call, 1=item selected, 2=custom entry typed
# ROFI_DATA: persisted between calls to track state
set -euo pipefail

selected="${1:-}"
DATA="${ROFI_DATA:-}"

map_category() {
  case "$1" in
    "General")       echo "100" ;;
    "Anime")         echo "010" ;;
    "People")        echo "001" ;;
    "General+Anime") echo "110" ;;
    "Anime+People")  echo "011" ;;
    "All")           echo "111" ;;
    *)               return 1 ;;
  esac
}

map_purity() {
  case "$1" in
    "SFW")           echo "100" ;;
    "Sketchy")       echo "010" ;;
    "NSFW")          echo "001" ;;
    "SFW+Sketchy")   echo "110" ;;
    "Sketchy+NSFW")  echo "011" ;;
    "All")           echo "111" ;;
    *)               return 1 ;;
  esac
}

# Parse ROFI_DATA fields (format: "state:X|cat:Y|pur:Z")
state=""
cat_code=""
pur_code=""
if [[ -n "$DATA" ]]; then
  IFS='|' read -ra parts <<< "$DATA"
  for part in "${parts[@]}"; do
    key="${part%%:*}"
    val="${part#*:}"
    case "$key" in
      state) state="$val" ;;
      cat)   cat_code="$val" ;;
      pur)   pur_code="$val" ;;
    esac
  done
fi

case "$state" in
  "")
    # Initial call: show category options
    printf "\0prompt\x1fCategories\n"
    printf "\0data\x1fstate:category\n"
    printf "General\nAnime\nPeople\nGeneral+Anime\nAnime+People\nAll\n"
    ;;

  "category")
    # Category was selected (ROFI_RETV=1): show purity options
    cat_code=$(map_category "$selected") || exit 0
    printf "\0prompt\x1fPurity\n"
    printf "\0data\x1fstate:purity|cat:%s\n" "$cat_code"
    printf "SFW\nSketchy\nNSFW\nSFW+Sketchy\nSketchy+NSFW\nAll\n"
    ;;

  "purity")
    # Purity was selected (ROFI_RETV=1): prompt for optional search query
    pur_code=$(map_purity "$selected") || exit 0
    printf "\0prompt\x1fSearch query (optional)\n"
    printf "\0no-custom\x1ffalse\n"
    printf "\0data\x1fstate:query|cat:%s|pur:%s\n" "$cat_code" "$pur_code"
    printf "(no query)\n"
    ;;

  "query")
    # Query entered: launch fetcher+changer in background and close rofi
    args=("-c" "$cat_code" "-p" "$pur_code")
    if [[ -n "$selected" && "$selected" != "(no query)" ]]; then
      args+=("-q" "$selected")
    fi
    coproc ( wpfetcher.sh "${args[@]}" | wpchanger.sh > /dev/null 2>&1 )
    exit 0
    ;;
esac
