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
    printf "  ${B}%-32s${R}  ${D}%s${R}\n" "$key" "$desc"
}

generate() {
    # ── Hyprland ──────────────────────────────────────────────────────────────
    section "Hyprland — apps"
    row "Super+Return"            "open terminal"
    row "Super+F"                 "file manager (yazi)"
    row "Super+E"                 "app launcher"
    row "Super+W"                 "wallpaper picker"
    row "Super+N"                 "toggle notifications"
    row "Super+C"                 "cheatsheet (this)"
    row "Super+Shift+W"           "LAN discovery (whosthere)"
    row "Super+M"                 "display config (wdisplays)"

    section "Hyprland — windows"
    row "Super+Q"                 "close window"
    row "Super+Shift+F"           "fullscreen"
    row "Super+T"                 "toggle dwindle split"
    row "Super+H/L/K/J"           "focus left/right/up/down"
    row "Super+LMB drag"          "move window"
    row "Super+RMB drag"          "resize window"

    section "Hyprland — workspaces"
    row "Super+[1-9]"             "switch workspace"
    row "Super+Shift+[1-9]"       "move window to workspace"
    row "Super+Scroll"            "cycle workspaces"
    row "3-finger swipe ↔"        "switch workspace"

    section "Hyprland — system"
    row "Super+Shift+L"           "lock screen"
    row "Super+R"                 "reload config"
    row "Super+Shift+S"           "region screenshot → clipboard"
    row "Print"                   "full screenshot → ~/Pictures"

    section "Hyprland — media"
    row "XF86AudioRaiseVolume"    "volume +5%"
    row "XF86AudioLowerVolume"    "volume -5%"
    row "XF86AudioMute"           "toggle mute"
    row "XF86AudioMicMute"        "toggle mic"
    row "XF86BrightnessUp/Down"   "brightness ±5%"
    row "XF86AudioPlay/Pause"     "play/pause"
    row "XF86AudioNext/Prev"      "next/prev track"

    # ── Shell ─────────────────────────────────────────────────────────────────
    section "Nushell — FZF"
    row "Ctrl+R"                  "fuzzy history search"
    row "Ctrl+T"                  "fuzzy file picker → insert path"
    row "Alt+C"                   "fuzzy cd to directory"
    row "Esc"                     "vi normal mode"
    row "i / a"                   "vi insert mode"

    section "Nushell — utils"
    row "z <dir>"                 "zoxide smart jump"
    row "zi"                      "zoxide interactive picker"
    row "rm <file>"               "rip (trash, recoverable)"
    row "rd"                      "restore from rip trash"
    row "cb"                      "copy to clipboard (wl-copy)"
    row "cbp"                     "paste from clipboard (wl-paste)"
    row "grep"                    "→ ripgrep"
    row "find"                    "→ fd"
    row "du"                      "→ dust"
    row "top"                     "→ btop"
    row "b <file>"                "bat (syntax highlight)"
    row "n <file>"                "nvim"

    # ── Git ───────────────────────────────────────────────────────────────────
    section "Git — basics"
    row "g"                       "git"
    row "ga / gaa"                "add / add all"
    row "gc / gcm"                "commit / commit -m"
    row "gca"                     "commit --amend"
    row "gp / gpf"                "push / push --force-with-lease"
    row "gl"                      "pull"
    row "gst"                     "status"
    row "gd / gds"                "diff / diff --staged"
    row "gco"                     "checkout"
    row "gcb"                     "checkout -b (new branch)"
    row "gb"                      "branch list"
    row "gbd"                     "branch delete"

    section "Git — log / history"
    row "glog"                    "pretty log (graph)"
    row "gloga"                   "log --all branches"
    row "glo"                     "log oneline"
    row "gbl"                     "git blame"
    row "gsh"                     "show"

    section "Git — stash / rebase"
    row "gsta / gstp"             "stash push / pop"
    row "gstl"                    "stash list"
    row "grb / grbi"              "rebase / rebase -i"
    row "grba / grbc / grbd"      "rebase abort/continue/drop"
    row "gcp"                     "cherry-pick"

    section "Git — worktree"
    row "gwt"                     "worktree list"
    row "gwta <path> <branch>"    "worktree add"
    row "gwtr <path>"             "worktree remove"

    # ── Docker ───────────────────────────────────────────────────────────────
    section "Docker — containers"
    row "dps"                     "ps (running)"
    row "dpsa"                    "ps --all"
    row "dr <name>"               "run"
    row "dstart / dstop"          "start / stop"
    row "dsta"                    "stop all"
    row "drm"                     "remove container"
    row "dxcit <name>"            "exec -it (attach shell)"
    row "dl <name>"               "logs"
    row "dlf <name>"              "logs --follow"

    section "Docker — images"
    row "di"                      "image ls"
    row "dbl <tag>"               "build + tag"
    row "dpull / dpush"           "pull / push"
    row "dirm"                    "image remove"
    row "dip"                     "image prune"

    section "Docker — compose"
    row "dco"                     "docker compose"
    row "dcup / dcdn"             "compose up -d / down"
    row "dcl"                     "compose logs"
    row "dcps"                    "compose ps"

    # ── NixOS ────────────────────────────────────────────────────────────────
    section "NixOS"
    row "nixos-re-sw"             "rebuild switch"
    row "nixos-edit"              "edit configuration.nix"
    row "nixos-garbage"           "collect garbage (>7d)"
    row "nix search nixpkgs <q>"  "search packages"
    row "nix shell nixpkgs#<pkg>" "temp shell with package"

    # ── Yazi ─────────────────────────────────────────────────────────────────
    section "Yazi — navigation"
    row "h / l"                   "parent / enter dir"
    row "j / k"                   "down / up"
    row "H / L"                   "back / forward (history)"
    row "g + g"                   "go to top"
    row "G"                       "go to bottom"
    row "/"                       "search"
    row "z"                       "zoxide jump"

    section "Yazi — actions"
    row "Space"                   "select file"
    row "y / x"                   "yank / cut"
    row "p"                       "paste"
    row "d"                       "trash"
    row "r"                       "rename"
    row "a"                       "create file/dir"
    row "."                       "toggle hidden files"
    row "Enter"                   "open file"
    row "q"                       "quit"

    # ── Bat ──────────────────────────────────────────────────────────────────
    section "Bat"
    row "b <file>"                "view with syntax highlight"
    row "bn <file>"               "with line numbers"
    row "bp <file>"               "plain (no theme)"
    row "bl <file>"               "list languages"
    row "b --list-themes"         "list available themes"

    # ── VPN ──────────────────────────────────────────────────────────────────
    section "VPN (vpnc)"
    row "waybar vpn icon click"   "open VPNC TUI"
    row "Connections → Connect"   "connect to saved config"
    row "Connections → Edit"      "edit config in nvim"
    row "Import"                  "import .pcf / .conf file"
    row "sudo vpnc-disconnect"    "disconnect (CLI fallback)"
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
