# TODO

## Active

- ~~customize waybar~~ ✓
- ~~customize starship~~ ✓
- ~~customize nushell~~ ✓
- ~~customize kitty~~ ✓ (tab bar, tokyo night, opacity, blur)
- ~~set wallpaper~~ ✓ (awww + wallrizz)
- ~~set custom cursor~~ ✓ (nix-logo, size 20)
- ~~replace hyprlauncher with rofi or keep~~ ✓ (jiffy)
- ~~create cheatsheet of all keybinds/aliases/features~~ ✓ (README + CLAUDE.md)
- ~~add hello/motd on shell start~~ ✓ (fastfetch + fortune via NU_BANNER)
- improve nvim config (add claude integration)
- ~~find clean way to update configs~~ ✓ (keeping symlinks; doller TUI installer replaces install.sh)
- fix screen issues
- set up claude-code properly (patch security settings — MCP, permissions, hooks)

## Future (when Windows removed / no longer dual boot)

- EFI partition frees ~114MB (Dell firmware + Microsoft gone) → install Plymouth with `nixos-bgrt` theme
- Bump `boot.loader.systemd-boot.configurationLimit` back to 3+
- Consider resizing EFI to 1GB for comfort
