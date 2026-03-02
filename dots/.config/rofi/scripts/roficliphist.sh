#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    cliphist list
else
    printf "%s" "$1" | cliphist decode | wl-copy
fi
