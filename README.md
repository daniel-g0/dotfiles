<div align="center">

# ❄️ dotfiles

**NixOS · Hyprland · Tokyo Night — end-to-end**

[![Tokyo Night](https://img.shields.io/badge/theme-Tokyo%20Night-7aa2f7?style=flat-square)](https://github.com/enkia/tokyo-night-vscode-theme)
[![License](https://img.shields.io/badge/license-MIT-bb9af7?style=flat-square)](LICENSE)

[![Stars](https://img.shields.io/github/stars/daniel-g0/dotfiles?style=flat-square&color=9ece6a&logo=github&label=stars)](https://github.com/daniel-g0/dotfiles/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/daniel-g0/dotfiles?style=flat-square&color=f7768e)](https://github.com/daniel-g0/dotfiles/commits/main)
[![Repo size](https://img.shields.io/github/repo-size/daniel-g0/dotfiles?style=flat-square&color=7dcfff)](https://github.com/daniel-g0/dotfiles)

![Desktop](screenshots/desktop.png)
![Rice](screenshots/rice.png)

**VPN Menu**
![VPN Menu](screenshots/vpn-menu.png)

**Neovim**
![Neovim](screenshots/nvim.png)

**WhosThere — LAN Discovery**
![WhosThere](screenshots/whosthere.png)

**Cheatsheet**
![Cheatsheet](screenshots/cheatsheet.png)

**Kitty Title Bar with Starship Prompt**
![Kitty Title Bar](screenshots/kitty-titlebar.png)

</div>

---

**Bleeding-edge tools built for maximum efficiency and aesthetics — configs that actually make sense. Tokyo Night across every surface. Vim keys everywhere: Nushell, Hyprland, Neovim, Brave, even Claude.**

Stack: Hyprland · Hyprlock · Hypridle · Waybar · swaync · WallRizz · Rofi · Kitty · Nushell · Starship · Neovim · Yazi · Zoxide · Fastfetch · Cava · NixOS

## What's custom

**Kitty** — tab bar built from scratch in Python. Shows current dir, git branch, file counts and time. Updates every keystroke.

**Nushell** — vi mode, 150+ git aliases, 35+ docker aliases, every basic tool swapped for a modern one. Shell greets you with fastfetch + a quote. Screen clears on every `cd`.

**Hyprland** — written in Lua (not the standard format). Borders animate as a liquid gradient. Full GPU passthrough for a Windows VM — discrete GPU auto-detaches on VM start, re-attaches on stop.

**WallRizz** — changing wallpaper resyncs your entire color scheme live: Hyprland borders, kitty colors, all of it. Transitions are random every time.

**NixOS** — custom-built packages for tools that don't exist in nixpkgs. Private certs drop-in folder. Entire system declared, one command to rebuild.

**Waybar** — NixOS control panel baked in (rebuild, update, garbage collect). Live VPN indicator with a full management TUI: connect, import, edit configs.

**Cheatsheet** — `Super+C`. Searchable fzf browser, 139 shortcuts across every tool.

**doller** — custom installer. Symlinks everything, backs up conflicts, Tokyo Night UI.

---

## Install

We use ***doller***, a custom dotfile installer, it basically symlinks configs to where they should be, makes life easy.

```bash
git clone https://github.com/daniel-g0/dotfiles ~/dotfiles
cd ~/dotfiles && ./doller
nixos-re-sw                                                                                     # (rebuild switch with tweaks)
```
> Never edit `~/.config/*` directly — they're symlinks. Edits land in the repo.
