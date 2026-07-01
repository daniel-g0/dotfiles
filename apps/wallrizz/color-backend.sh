#!/usr/bin/env bash
# Fixed-count color backend for WallRizz — always outputs exactly 16 hex colors.
IMAGE="$1"
N=16

mapfile -t colors < <(
  magick "$IMAGE" \
    -format "%c" \
    -define histogram:method=kmeans \
    -colors $N \
    histogram:info: 2>/dev/null \
    | grep -oP '#[0-9A-Fa-f]{6,8}' \
    | head -$N
)

# Pad with last color if magick returned fewer than N
while [ ${#colors[@]} -lt $N ]; do
  colors+=("${colors[-1]:-#1a1b26}")
done

printf '%s\n' "${colors[@]:0:$N}"
