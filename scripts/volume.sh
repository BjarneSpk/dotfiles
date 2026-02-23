#!/usr/bin/env bash

hint="string:x-canonical-private-synchronous:sys-notify"
source $SCRIPTS/notification-handler.sh

# Get Volume
get_volume() {
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
    echo "$volume"
}

# Get icons
get_icon() {
    current=$(get_volume)
    if [[ "$current" -eq "0" ]]; then
        echo "audio-volume-muted-symbolic"
    elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
        echo "audio-volume-low-symbolic"
    elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
        echo "audio-volume-medium-symbolic"
    elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
        echo "audio-volume-high-symbolic"
    fi
}

# Notify
notify_volume() {
    notify_user -h "$hint" -u low -i "$(get_icon)" -a "Volume" -m "$(get_volume) %"
}

# Increase Volume
inc_volume() {
    wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && notify_volume
}

# Decrease Volume
dec_volume() {
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify_volume
}

# Toggle Mute
toggle_mute() {
    if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        notify_user -h "$hint" -u low -i "$(get_icon)" -a "Volume" -m "Volume Switched ON"
    else
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
        notify_user -h "$hint" -u low -i "audio-volume-muted-symbolic" -a "Volume" -m "Volume Switched OFF"
    fi
}

# Toggle Mic
toggle_mic() {
    if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0
        notify_user -h "$hint" -u low -i "microphone-sensitivity-high-symbolic" -a "Microphone" -m "Microphone Switched ON"
    else
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
        notify_user -h "$hint" -u low -i "microphone-sensitivity-muted-symbolic" -a "Microphone" -m "Microphone Switched OFF"
    fi
}
# Get icons
get_mic_icon() {
    current=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2*100)}')
    if [[ "$current" -eq "0" ]]; then
        echo "microphone-sensitivity-muted-symbolic"
    elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
        echo "microphone-sensitivity-low-symbolic"
    elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
        echo "microphone-sensitivity-medium-symbolic"
    elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
        echo "microphone-sensitivity-high-symbolic"
    fi
}
# Notify
nofify_mic() {
    notify_user -h "$hint" -u low -i "$(get_mic_icon)" -a "Microphone" -m "$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2*100)}') %"
}

# Increase MIC Volume
inc_mic_volume() {
    wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+
    nofify_mic
}

# Decrease MIC Volume
dec_mic_volume() {
    wpctl set-volume @DEFAULT_AUDIO_SOURCE 5%-
    nofify_mic
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
    get_volume
elif [[ "$1" == "--inc" ]]; then
    inc_volume
elif [[ "$1" == "--dec" ]]; then
    dec_volume
elif [[ "$1" == "--toggle" ]]; then
    toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
    toggle_mic
elif [[ "$1" == "--get-icon" ]]; then
    get_icon
elif [[ "$1" == "--get-mic-icon" ]]; then
    get_mic_icon
elif [[ "$1" == "--mic-inc" ]]; then
    inc_mic_volume
elif [[ "$1" == "--mic-dec" ]]; then
    dec_mic_volume
else
    get_volume
fi
