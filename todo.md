# TODO

## Completed

- ~~customize waybar~~ ✓
- ~~customize starship~~ ✓
- ~~customize nushell~~ ✓
- ~~customize kitty~~ ✓ (tab bar, tokyo night, opacity, blur)
- ~~set wallpaper~~ ✓ (awww + wallrizz)
- ~~set custom cursor~~ ✓ (nix-logo, size 20)
- ~~replace hyprlauncher with rofi or keep~~ ✓ (jiffy)
- ~~create cheatsheet of all keybinds/aliases/features~~ ✓ (README + CLAUDE.md)
- ~~add hello/motd on shell start~~ ✓ (fastfetch + fortune via NU_BANNER)
- ~~find clean way to update configs~~ ✓ (keeping symlinks; doller TUI installer replaces install.sh)

## Active

### Bugs
- [ ] kitty tab bar background black text after content scrolls
- [ ] wallrizz (super+w) freezes/crashes on image caching (just remove it by another tool)
- [ ] wifi context menu drops when on ethernet
- [ ] verify date display is correct in waybar/kitty (was showing wrong date)
- [ ] check if new cursor pack renders correctly
- [ ] brave tokyonight aint working

### Quick config
- [ ] idle → hyprlock (currently going to wrong locker)
- [ ] waybar: add workspace number indicator

### Features
- [ ] set up claude-code properly (MCP, permissions, hooks)
- [ ] improve nvim config (add claude integration)
- [ ] super+c: fzf browser for per-stack keybindings cheatsheet
- [ ] add eye care tool (20-20-20 rule notifications)

### Big tasks
- [ ] (important) set up VPN
- [ ] set multiple monitor profiles (work: 2 screens + eDP off; home: single screen)
- [ ] add proper screenshots to README
- [ ] create VM for safe dotfile testing


## Future (when Windows removed / no longer dual boot)

- EFI partition frees ~114MB (Dell firmware + Microsoft gone) → install Plymouth with `nixos-bgrt` theme
- Bump `boot.loader.systemd-boot.configurationLimit` back to 3+
- Consider resizing EFI to 1GB for comfort
