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
- [x] kitty tab bar background black text after content scrolls ✓
- [x] wallrizz (super+w) freezes/crashes on image caching — replaced with yazi picker ✓
- [x] wifi context menu drops when on ethernet — replaced GTK menu with on-click nmtui / right-click wifi toggle ✓
- [x] verify date display is correct in waybar/kitty — system time correct (CEST), format fine ✓
- [x] check if new cursor pack renders correctly ✓
- [x] brave tokyonight aint working

### Quick config
- [x] idle → qylock ✓
- [x] waybar: add workspace number indicator ✓

### Features
- [ ] set up claude-code properly (MCP, permissions, hooks)
- [ ] improve nvim (add claude integration)
- [x] super+c: fzf browser for per-stack keybindings cheatsheet
- [ ] add eye care tool (20-20-20 rule notifications)
- [x] add cava and other rice tools ✓ (cava TN gradient + cava-vibe noise mode, cmatrix cyan)
- [x] add whosthere and bind it to a key (super, shift, w) ✓ (Super+Shift+W → kitty -e whosthere)
- [ ] modulate config nix?
- [ ] check cool features on hardware
- [ ] set up idler
- [ ] add mapscii
- [ ] subsitute drawio with clin
- [ ] get gloomberb, cliam, gittop

### Big tasks
- [ ] (important) set up VPN
- [x] set multiple monitor profiles (work: DP-3 left, DP-4 middle, eDP-1 right; home: eDP-1 only) ✓ (hyprmon TUI)
- [ ] add proper screenshots to README and repo graphs
- [ ] create VM for safe dotfile testing
- [ ] set up windows VM ready for working and gaming (home setup)


## Future (when Windows removed / no longer dual boot)

- EFI partition frees ~114MB (Dell firmware + Microsoft gone) → install Plymouth with `nixos-bgrt` theme
- Bump `boot.loader.systemd-boot.configurationLimit` back to 3+
- Consider resizing EFI to 1GB for comfort
