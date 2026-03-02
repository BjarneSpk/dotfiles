#!/usr/bin/env bash

timeout=0
function handle() {
  case $1 in
    monitoradded\>* | monitorremoved\>*) brightness.sh redetect ;;
    windowtitlev2*)
        # Extract the window ID from the line
        window_id=${1#*>>}

        # Check if the title matches the characteristics of the Bitwarden popup window
        if [[ "$window_id" == *"(Bitwarden Password Manager) - Bitwarden"* ]]; then

            # in case of double rename only allow once per second
            if ((SECONDS < timeout)); then
                return
            fi
            timeout=$((SECONDS + 1))

            window_id=${window_id%%,*}

            hyprctl --batch "dispatch togglefloating address:0x$window_id; dispatch resizewindowpixel exact 20% 54%,address:0x$window_id; dispatch centerwindow"
            # hyprctl --batch "dispatch togglefloating address:0x$window_id; dispatch centerwindow"
        fi
        ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
