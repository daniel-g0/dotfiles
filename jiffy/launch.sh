#!/usr/bin/env bash
exec kitty \
    --class jiffy \
    -1 \
    -o allow_remote_control=yes \
    -o background_opacity=0.9 \
    jiffy --fzf-args="--color=bg+:#292e42,bg:#1a1b26,spinner:#bb9af7,hl:#565f89,fg:#c0caf5,header:#565f89,info:#7aa2f7,pointer:#bb9af7,marker:#7dcfff,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7dcfff --border=rounded --prompt=  --preview-window=0"
