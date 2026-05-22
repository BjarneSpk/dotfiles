#!/usr/bin/env bash

if pkill -f waybar_auto_hide; then
    pkill -SIGUSR2 -x waybar
else
    waybar_auto_hide &
    pkill -SIGUSR1 -x waybar
fi
