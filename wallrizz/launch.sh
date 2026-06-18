#!/usr/bin/env bash
exec kitty \
    --class wallrizz \
    -1 \
    -o allow_remote_control=yes \
    -o background_opacity=0.9 \
    WallRizz -d "$HOME/.config/wallpapers" -z list
