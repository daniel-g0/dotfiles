#!/usr/bin/env bash
exec kitty \
    --class wallrizz \
    -1 \
    -o background_opacity=0.9 \
    WallRizz -d "$HOME/.config/wallpapers" -z list -c "$HOME/.config/WallRizz/color-backend.sh {}"
