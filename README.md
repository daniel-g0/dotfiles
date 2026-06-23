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

</div>

---

**Bleeding-edge tools built for maximum efficiency and aesthetics — configs that actually make sense. Tokyo Night across every surface. Vim keys everywhere: Nushell, Hyprland, Neovim, Brave, even Claude.**

Stack: Hyprland · Hyprlock · Hypridle · Waybar · swaync · WallRizz · Rofi · Kitty · Nushell · Starship · Neovim · Yazi · Zoxide · Fastfetch · Cava · NixOS

## Install

We use ***doller***, a custom dotfile installer, it basically symlinks configs to where they should be, makes life easy.

```bash
git clone https://github.com/daniel-g0/dotfiles ~/dotfiles
cd ~/dotfiles && ./doller
nixos-re-sw                                                                                     # (rebuild switch with tweaks)
```
> Never edit `~/.config/*` directly — they're symlinks. Edits land in the repo.
