#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/.config/wallpapers"
CHOOSER=$(mktemp)

yazi "$WALLPAPER_DIR" --chooser-file="$CHOOSER"

SELECTED=$(cat "$CHOOSER")
rm -f "$CHOOSER"

[[ -z "$SELECTED" ]] && exit 0

TRANSITIONS=(fade left right top bottom wipe wave grow center outer)
POSITIONS=(center top left right bottom top-left top-right bottom-left bottom-right)

TRANSITION="${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}"
ANGLE=$((RANDOM % 360))
POS="${POSITIONS[$RANDOM % ${#POSITIONS[@]}]}"

awww img "$SELECTED" \
    --resize crop \
    --transition-type "$TRANSITION" \
    --transition-step 255 \
    --transition-duration 1 \
    --transition-fps 60 \
    --transition-angle "$ANGLE" \
    --transition-pos "$POS"
