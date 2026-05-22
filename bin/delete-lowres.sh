#!/usr/bin/env bash

mkdir -p ./too_small

_check_and_move() {
  img="$1"
  set -- $(identify -format "%w %h" "$img" 2>/dev/null) || return 0
  w=$1 h=$2
  if [ -n "$w" ] && { [ "$w" -lt 2560 ] || [ "$h" -lt 1440 ]; }; then
    mv -- "$img" ./too_small/
  fi
}
export -f _check_and_move

fd -t f -E too_small -e jpg -e jpeg -e png -0 \
| parallel -0 -j"$(nproc)" _check_and_move {}
