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
    local spec="$1" key="$2" desc="$3"
    printf "%s\t  ${B}%-30s${R}  ${D}%s${R}\n" "$spec" "$key" "$desc"
}

generate() {
    section "Hyprland — apps"
    row "DISPATCH:exec kitty"                               "Super+Return"          "open terminal"
    row "DISPATCH:exec kitty -e yazi"                       "Super+F"               "file manager (yazi)"
    row "EXEC:bash ~/.config/jiffy/launch.sh"               "Super+E"               "app launcher (jiffy)"
    row "EXEC:bash ~/.config/wallrizz/launch.sh"            "Super+W"               "wallpaper picker"
    row "EXEC:swaync-client -t"                             "Super+N"               "toggle notifications"
    row "-"                                                 "Super+C"               "cheatsheet (this)"

    section "Hyprland — windows"
    row "DISPATCH:killactive"                               "Super+Q"               "close window"
    row "DISPATCH:fullscreen 1"                             "Super+Shift+F"         "fullscreen"
    row "DISPATCH:layoutmsg togglesplit"                    "Super+T"               "toggle dwindle split"
    row "DISPATCH:movefocus l"                              "Super+H"               "focus left"
    row "DISPATCH:movefocus r"                              "Super+L"               "focus right"
    row "DISPATCH:movefocus u"                              "Super+K"               "focus up"
    row "DISPATCH:movefocus d"                              "Super+J"               "focus down"

    section "Hyprland — workspaces"
    row "-"                                                 "Super+[1-9]"           "switch workspace"
    row "-"                                                 "Super+Shift+[1-9]"     "move window to workspace"
    row "-"                                                 "Super+Scroll"          "cycle workspaces"
    row "-"                                                 "Super+LMB drag"        "move window"
    row "-"                                                 "Super+RMB drag"        "resize window"
    row "-"                                                 "3-finger swipe ↔"      "switch workspace"

    section "Hyprland — system"
    row "EXEC:loginctl lock-session"                        "Super+Shift+L"         "lock screen"
    row "EXEC:hyprctl reload && pkill waybar; waybar &"     "Super+R"               "reload config + waybar"
    row "EXEC:slurp | grim -g - - | wl-copy"               "Super+Shift+S"         "region screenshot → clipboard"
    row "EXEC:grim ~/Pictures/\$(date +%Y%m%d_%H%M%S).png" "Print"                 "full screenshot → ~/Pictures"

    section "Hyprland — media / hardware"
    row "EXEC:wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"  "XF86AudioRaiseVolume"  "volume +5%"
    row "EXEC:wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"        "XF86AudioLowerVolume"  "volume -5%"
    row "EXEC:wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"       "XF86AudioMute"         "toggle mute"
    row "EXEC:wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"     "XF86AudioMicMute"      "toggle mic mute"
    row "EXEC:brightnessctl -e4 -n2 set 5%+"                    "XF86BrightnessUp"      "brightness +5%"
    row "EXEC:brightnessctl -e4 -n2 set 5%-"                    "XF86BrightnessDown"    "brightness -5%"
    row "EXEC:playerctl play-pause"                              "XF86AudioPlay/Pause"   "play / pause"
    row "EXEC:playerctl next"                                    "XF86AudioNext"         "media next"
    row "EXEC:playerctl previous"                                "XF86AudioPrev"         "media previous"

    section "Nushell / FZF"
    row "-"                                                 "Ctrl+R"                "fuzzy history search"
    row "-"                                                 "Ctrl+T"                "fuzzy file picker"
    row "-"                                                 "Alt+C"                 "fuzzy cd"
    row "-"                                                 "Ctrl+L"                "clear screen"
    row "-"                                                 "Esc"                   "vi normal mode"
    row "-"                                                 "i / a"                 "vi insert mode"
}

run_spec() {
    local spec="$1"
    [[ -z "$spec" || "$spec" == "-" ]] && return
    case "$spec" in
        DISPATCH:*) hyprctl dispatch ${spec#DISPATCH:} ;;
        EXEC:*)     nohup bash -c "${spec#EXEC:}" > /dev/null 2>&1 & disown ;;
    esac
}

ENTRIES=$(generate)

while true; do
    selected=$(printf '%s\n' "$ENTRIES" | fzf \
        $FZF_COLORS \
        --delimiter=$'\t' \
        --with-nth=2 \
        --nth=2 \
        --ansi \
        --border=rounded \
        --prompt="  " \
        --header=" Keybindings — Enter: execute · ESC: close" \
        --header-first \
        --no-multi \
        --no-sort \
        --layout=reverse \
        --height=100%)
    [[ -z "$selected" ]] && break
    spec=$(printf '%s' "$selected" | cut -d$'\t' -f1)
    run_spec "$spec"
done
