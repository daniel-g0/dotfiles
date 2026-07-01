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

#### Suspend/lock freeze on resume
Symptoms: black screen, freeze, or compositor not loading after suspend or lock.
Likely causes:
- GPU/DRM state not restored (hybrid graphics — Intel iGPU + dGPU)
- qylock race: `before_sleep_cmd` fires lock before qylock renders first frame → deadlock on resume
- `after_sleep_cmd = hyprctl dispatch dpms on` fires before Hyprland socket ready → display stays off
- pipewire/wireplumber crash on resume → systemd session bad state

Diagnose after next freeze:
```bash
journalctl -b -1 -p err --no-pager | tail -50
journalctl -b -1 -u systemd-suspend --no-pager
```

Fixes to try:
- Add `sleep 1 &&` before `hyprctl dispatch dpms on` in hypridle `after_sleep_cmd`
- Check amdgpu/nvidia kernel module sleep_state options


- [x] kitty tab bar background black text after content scrolls ✓
- [x] wallrizz (super+w) freezes/crashes on image caching — replaced with yazi picker ✓
- [x] wifi context menu drops when on ethernet — replaced GTK menu with on-click nmtui / right-click wifi toggle ✓
- [x] verify date display is correct in waybar/kitty — system time correct (CEST), format fine ✓
- [x] check if new cursor pack renders correctly ✓
- [x] brave tokyonight aint working ✓

### Quick config
- [x] idle → qylock ✓
- [x] waybar: add workspace number indicator ✓

### Features
- [ ] set up claude-code properly (MCP, permissions, hooks)
- [x] improve nvim (add claude integration) ✓ (riced with tokyonight + 20 plugins; claude integration skipped — needs paid API)
- [x] super+c: fzf browser for per-stack keybindings cheatsheet
- [x] add eye care tool (20-20-20 rule notifications) ✓ (waybar countdown + swaync notification)
- [x] add cava and other rice tools ✓ (cava TN gradient + cava-vibe noise mode, cmatrix cyan)
- [x] add whosthere and bind it to a key (super, shift, w) ✓ (Super+Shift+W → kitty -e whosthere)
- [ ] modulate config nix?
- [ ] check cool features on hardware
- [x] set up idler ✓ (hypridle: 5min dim → 10min lock → 11min display off → 30min suspend)
- [x] add mapscii ✓ (added to nixos packages)
- [ ] subsitute drawio with clin
- [ ] get gloomberb, cliam, gittop
- [x] Fix nvim and rice it ✓ (tokyonight, 20+ plugins, treesitter :TSUpdate fix, markdown renderer, LSP hover)           
- [ ] Coloscheme tool finish creation (also add border colors and icons and all)


### Big tasks
- [x] (important) set up VPN ✓ (vpnc + waybar module + fzf menu)
- [x] set multiple monitor profiles (work: DP-3 left, DP-4 middle, eDP-1 right; home: eDP-1 only) ✓ (hyprmon TUI)
- [x] add proper screenshots to README and repo graphs ✓
- [x] create VM for safe dotfile testing ✓
- [x] create distributable demo VM image (virt-manager qcow2) ✓ (nixos/vm.nix + nixos-generators)
- [x] set up windows VM ready for working and gaming (home setup) ✓


## Future (when Windows removed / no longer dual boot)

- EFI partition frees ~114MB (Dell firmware + Microsoft gone) → install Plymouth with `nixos-bgrt` theme
- Bump `boot.loader.systemd-boot.configurationLimit` back to 3+
- Consider resizing EFI to 1GB for comfort
