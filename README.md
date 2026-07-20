<div align="center">

# ❄️ dotfiles

**NixOS · Hyprland · Tokyo Night — end-to-end**

[![Tokyo Night](https://img.shields.io/badge/theme-Tokyo%20Night-7aa2f7?style=flat-square)](https://github.com/enkia/tokyo-night-vscode-theme)
[![License](https://img.shields.io/badge/license-MIT-bb9af7?style=flat-square)](LICENSE)

[![Stars](https://img.shields.io/github/stars/daniel-g0/dotfiles?style=flat-square&color=9ece6a&logo=github&label=stars)](https://github.com/daniel-g0/dotfiles/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/daniel-g0/dotfiles?style=flat-square&color=f7768e)](https://github.com/daniel-g0/dotfiles/commits/main)
[![Repo size](https://img.shields.io/github/repo-size/daniel-g0/dotfiles?style=flat-square&color=7dcfff)](https://github.com/daniel-g0/dotfiles)

![Showcase](screenshots/showcase.png)

</div>

---

Tokyo Night across every surface. Vi keys everywhere. Custom tools that actually get used.

**Stack:** NixOS · Hyprland · Waybar · Kitty · Nushell · Neovim (NvChad) · Yazi · Starship · Swaync · WallRizz · Rofi · Zoxide · Fastfetch · Cava

---

## What makes this different

**Hyprland config is written in Lua** — not the standard format. Borders animate as a liquid blue→purple→cyan gradient. Window rules, keybinds, autostart, all in one structured file.

**Kitty tab bar built from scratch in Python.** Every keypress updates the tab: current directory, git branch, staged/modified/untracked counts, and a clock. Not using any plugin.

**WallRizz live color sync.** Change the wallpaper → Hyprland border colors, kitty terminal colors, and your whole desktop resync instantly. Every transition is a different random animation.

**GPU passthrough baked in.** A QEMU hook auto-detects your discrete GPU, unbinds it from the host driver, and hands it to the Windows VM on start. Re-attaches on stop. No manual steps.

**Cheatsheet at `Super+C`.** fzf browser with 139 keyboard shortcuts across Hyprland, Nushell, Neovim, Yazi, Git, Docker, VPN, and more. Searchable, instant.

**VPN manager TUI in the taskbar.** Click the waybar indicator → fzf menu: connect, disconnect, import `.pcf`/`.ovpn`/`.conf`, edit configs in nvim. Auto-converts Cisco PCF to vpnc format. Green/red status at a glance.

**Eye care timer built into waybar.** 20-20-20 rule — fires a notification every 20 minutes to look away. Countdown visible in the bar. Click to reset. Race-condition safe.

**NixOS control panel in waybar.** Rebuild switch, test, update flake, garbage collect, view generations — each opens in kitty, tees output to a log, waits for Enter. Full system management without touching a terminal manually.

**Entire system is one file.** Drop a `.crt` in `~/.config/certs/` → rebuild → cert trusted system-wide. Change a package, a font, a kernel param → one command. Private stuff stays out of the repo.

---

## Shell

Nushell with vi mode. Block cursor in normal, line in insert. SQLite history (100k entries, dedup, timestamps, per-session). Screen clears on `cd` to any non-home directory.

Modern replacements wired up as defaults: `grep`→rg · `find`→fd · `du`→dust · `top`→btop · `rm`→rip (recoverable — restore with `rd`)

Clipboard shortcuts: `cb` to copy (pipe into it), `cbp` to paste. `reload` hot-reloads config without opening a new window.

FZF everywhere: `Ctrl+R` fuzzy history · `Ctrl+T` fuzzy file insert · `Alt+C` fuzzy cd.

---

## Try it in a VM

No install needed — boot the full setup in virt-manager.

**Build the image** (on any NixOS machine with flakes enabled):
```bash
git clone https://github.com/daniel-g0/dotfiles
cd dotfiles
nix run github:nix-community/nixos-generators -- --format qcow2 --configuration ./nixos/vm.nix
```

**Import into virt-manager:**
1. New VM → Import existing disk image → select `nixos.qcow2`
2. Set OS to `Generic Linux` — at least 4GB RAM, 2 CPUs recommended
3. Boot → login: `user` / `nixos`

Dotfiles clone and install automatically on first boot (needs internet). Watch progress:
```bash
journalctl -u setup-dotfiles -f
```

> The VM config strips hardware-specific stuff (IOMMU, GPU passthrough). Everything else is identical.

---

## Install

Uses **doller**, a custom symlink installer. TUI shows status per link, backs up conflicts automatically.

```bash
git clone https://github.com/daniel-g0/dotfiles ~/dotfiles
cd ~/dotfiles && ./doller
nixos-re-sw
```

> Never edit `~/.config/*` directly — they're symlinks. Edits land in the repo.
