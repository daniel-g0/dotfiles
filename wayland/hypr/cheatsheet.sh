#!/usr/bin/env bash

FZF_COLORS="--color=bg+:#292e42,bg:#1a1b26,spinner:#bb9af7,hl:#565f89,fg:#c0caf5,header:#565f89,info:#7aa2f7,pointer:#bb9af7,marker:#7dcfff,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7dcfff"

P='\033[38;2;187;154;247m'
B='\033[38;2;122;162;247m'
Y='\033[38;2;224;175;104m'
D='\033[38;2;86;95;137m'
R='\033[0m'

section() {
    printf -- "-\t${Y}── %s ──────────────────────────────────────────────────────────${R}\n" "$1"
}

row() {
    local key="$1" desc="$2"
    printf "  ${B}%-30s${R}  ${D}%s${R}\n" "$key" "$desc"
}

generate() {
    section "Hyprland — apps"
    row "Super+Return"          "open terminal"
    row "Super+F"               "file manager (yazi)"
    row "Super+E"               "app launcher"
    row "Super+W"               "wallpaper picker"
    row "Super+N"               "toggle notifications"
    row "Super+C"               "cheatsheet (this)"

    section "Hyprland — windows"
    row "Super+Q"               "close window"
    row "Super+Shift+F"         "fullscreen"
    row "Super+T"               "toggle dwindle split"
    row "Super+H/L/K/J"         "focus left/right/up/down"

    section "Hyprland — workspaces"
    row "Super+[1-9]"           "switch workspace"
    row "Super+Shift+[1-9]"     "move window to workspace"
    row "Super+Scroll"          "cycle workspaces"
    row "Super+LMB drag"        "move window"
    row "Super+RMB drag"        "resize window"
    row "3-finger swipe ↔"      "switch workspace"

    section "Hyprland — system"
    row "Super+Shift+L"         "lock screen"
    row "Super+R"               "reload config"
    row "Super+Shift+S"         "region screenshot → clipboard"
    row "Print"                 "full screenshot → ~/Pictures"

    section "Hyprland — media / hardware"
    row "XF86AudioRaiseVolume"  "volume +5%"
    row "XF86AudioLowerVolume"  "volume -5%"
    row "XF86AudioMute"         "toggle mute"
    row "XF86AudioMicMute"      "toggle mic mute"
    row "XF86BrightnessUp"      "brightness +5%"
    row "XF86BrightnessDown"    "brightness -5%"
    row "XF86AudioPlay/Pause"   "play / pause"
    row "XF86AudioNext"         "media next"
    row "XF86AudioPrev"         "media previous"

    section "Nushell / FZF"
    row "Ctrl+R"                "fuzzy history search"
    row "Ctrl+T"                "fuzzy file picker"
    row "Alt+C"                 "fuzzy cd"
    row "Ctrl+L"                "clear screen"
    row "Esc"                   "vi normal mode"
    row "i / a"                 "vi insert mode"
}

ENTRIES=$(generate)
printf '%s\n' "$ENTRIES" | fzf \
    $FZF_COLORS \
    --delimiter=$'\t' \
    --ansi \
    --border=rounded \
    --prompt="  " \
    --header=" Keybindings — ESC to close" \
    --header-first \
    --no-multi \
    --no-sort \
    --layout=reverse \
    --height=100%
