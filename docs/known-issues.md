# Known issues

Investigated problems: symptoms, root cause (proven or suspected), recovery, and gotchas. Newest first.

## Waybar: VPN / bell / power icons drift left (investigated 2026-11-20, Waybar 0.16.0) — UNFIXED

**Symptom:** in the vertical bar the `custom/vpn` (󰦞), `custom/notifications` (󰂛) and `custom/power` (󰒲, looks like `zz`) icons sit left of the others; power ends up on the left border. Native modules (bluetooth, pulseaudio, network) are centred.

**Measured** (pixel centroids in user screenshots, bar centre = 0): native icons -1.5 px; VPN ≈ -11, bell ≈ -18, power ≈ -16 (screenshot px, ~1.3 px per logical px). Matches a label **pinned to the left edge at its natural width** in the 36 px inner width (glyph centre ≈ 12 px left of centre).

**Ruled out:**
- Font: `JetBrainsMono Nerd Font Mono` has every icon, advance 600/1000, ink centred (offset +0.000 for all glyphs in `modules.jsonc`; parsed the TTF `cmap/hmtx/glyf` by hand).
- Stray characters: each `format` / `format-icons` / vpn-script text is exactly one glyph.
- CSS: no horizontal margin/padding on these modules; layout-gap margins (`waybar-layout.css`) are vertical only.
- `min-length`/`max-length` on `custom/vpn` (labels are centred inside it; bell and power have none).
- Waybar `justify`/`align` (default is already 0.5).

**Suspected cause (strong, source not read):** upstream regression after 0.15.0, [Alexays/Waybar#5338](https://github.com/Alexays/Waybar/issues/5338): `custom/*` modules became an `AIconLabel`, the label sits at natural width inside a wider box, so `align`/`justify` do nothing. Fix: [PR #5346](https://github.com/Alexays/Waybar/pull/5346) (merge/release status unchecked). Only `custom/*` modules are affected, which is exactly the set that drifts. Launch log also says `Requested width: 40 is less than the minimum width: 72 required by the modules`, then reconfigures at 40: cause unknown, may be related.

**Tried, made it worse (reverted):** `min-width: 36px` on `#custom-vpn, #custom-notifications, #custom-power` (+ `*` children), expecting the label to fill the bar and centre the glyph. User reported the bar "got fucked up" after it; exact breakage not seen (no screenshot access). Don't retry blindly.

**Next options:** pin Waybar 0.15.0, build `waybar-git` containing PR #5346, or wait for a release; JetBrainsMono Nerd Font **Propo** for icons is a reported side workaround. Verify with a before/after screenshot.

**Gotchas from this investigation:**
- `launch` resets the bar to **minimal** mode (`rm /tmp/waybar-mode`); click the clock for full.
- Waybar vanished (no process, no coredump, nothing in the journal) twice right after `style.css` was replaced (edit / `git checkout`) while it was running. Cause unknown; relaunch with `nohup setsid ~/.config/waybar/launch &`. Check `hyprctl layers | grep waybar` shows exactly one layer.
- `pkill -f 'swaync-client -swb'` from `bash -c` kills your own shell too (exit 144) and removes Waybar's bell feed. Recover with `kill -USR2 <waybar pid>` (respawns module commands).
- On this machine the process is named `waybar`, not `.waybar-wrapped`.
- Measuring screenshots without PIL: `magick img.png -depth 8 txt:-` and parse with stdlib Python.

## Steam won't open / "Steam is already running" (investigated 2026-11-19, nixpkgs `steam` 1.0.0.87, client Nov 13 build)

**Symptom:** clicking a game (RIDE 4) or running `steam` did nothing: no window, no error. Every relaunch logged `Steam is already running, exiting (command line was forwarded)` in `~/.local/share/Steam/logs/console-linux.txt`.

**Cause (observed chain, trigger unproven):**
1. The client update of 2026-11-18 was cut off at ~114 of 410 MB. The next launch segfaulted in `steamui.so` right after `SteamUpdateUI: An X Error occurred / BadValue` and the XRandR probing.
2. Finishing that update hung at `Installing update...` (`logs/bootstrap_log.txt`). `strace -p` showed the updater thread blocked in `write()` to the update-UI socket, while the child (`steam -child-update-ui`) sat in `futex_wait` and never read it. **Deadlock in the update-UI window.**
3. The Nov 13 client is 64-bit (`steamrt64/steam`) and re-execs into the SteamRT container (`ReexecToLauncher: steamrt3 client enabled`). The hung `-child-update-ui` (PPID 1, ignores SIGTERM) survived and kept the single-instance lock, so the real client always exited with "already running".

**Fix that worked:** kill the hung UI child (let the update finish), `kill -9` any leftover `-child-update-ui`, relaunch; a reboot cleared the last stale state. Disk, RAM, the `package/` download and the game install (`/gaming/SteamLibrary`, `StateFlags 4`) were all fine.

**If it happens again:**
```
ps -eo pid,ppid,etime,stat,cmd | grep -E 'child-update-ui|steamwebhelper'   # orphan with PPID 1?
kill -9 <pid of every -child-update-ui>                                    # SIGTERM is ignored
steam
```
Last resort, still reversible: `mv ~/.local/share/Steam/package ~/.local/share/Steam/package.bak` and relaunch (forces a clean client re-download). That alone did **not** fix this case, because the hang is in the UI window, not the package.

**Not proven:** why the update-UI window hung. Prime suspect is the `X Error BadValue` under Hyprland + rootless Xwayland (monitor scale 1.3333334, `xwayland:force_zero_scaling = true`). XRandR output itself looked sane (`xrandr` 2560x1440).

**Gotchas from this investigation:**
- **Don't `strace -ff` a whole Steam launch.** It breaks Chromium's sandbox/zygote and `steamwebhelper` restarts every ~10 s, a false crash loop. Attach with `strace -p` to one process instead.
- `pkill -f 'ubuntu12_32/steam'` matches your own shell's command line when run inside `bash -c`; kill by pid.
- `pgrep -f steamwebhelper` / `ps | grep steamwebhelper` also match the grepping shell; use `grep -E '[s]teamwebhelper'`.
- NixOS runs Steam in a bwrap FHS env (`/nix/store/…-steam-1.0.0.87-bwrap`); the client self-updates inside `~/.local/share/Steam`, independent of the nixpkgs version.
- `/gaming` (the game library) is an `ntfs3` mount. Not the cause here, but a suspect if a game's Proton prefix misbehaves later.

## Mouse clicks dead (investigated 2026-11-18, Hyprland 0.56.2 `efb50993`)

**Symptom:** no left click reached any app, from any device (Logitech mouse **and** touchpad). Pointer motion and scroll worked.

**Quick fix (keeps all windows): `systemctl suspend`, wake, unlock.** Worked on 2026-11-18 (episode 3). Why it works is unknown. Restarting Hyprland also works but kills every window.

**Episodes (2026-11-18):**
1. ~10:33–11:10: found already broken; no hotplug in the journal. Fixed by restarting Hyprland.
2. ~12:27–12:51: around an undock/re-dock (dock outputs renamed, `c542` receiver on port `3-3` flapping 6×, libseat `Couldn't close device at /dev/input/event2/3`). Healed by itself; trigger and cure unknown.
3. ~13:00–14:04: **started right after lock → unlock (hyprlock)**. Fixed by `systemctl suspend`.

**Episode 3 live tests (the decisive ones):**
- `wev` (`nix shell nixpkgs#wev -c wev`) got 845 `motion` events, **0 left-button**, but **right click pressed+released**. Modifiers sent to clients: `depressed: 00000000`.
- That rules out (each would also eat right clicks): stuck drag/resize (`ensureMouseBindState()` runs for every button), stuck Super in Hyprland's mod state (`Super+RMB` is the resize bind), input capture (`onMouseButton` returns early for all buttons while `PROTO::inputCapture->isCaptured()`).
- **Not the `Super+LMB` drag bind:** `hyprctl eval 'hl.unbind("SUPER + mouse:272")'` didn't bring left clicks back (restored with `hyprctl reload`).
- Not fixed by: `hyprctl dispatch 'hl.dsp.release_input_capture()'`, opening/closing rofi (`Super+E`, Esc; refocus calls `releaseAllMouseButtons()`, which is a no-op while a drag-and-drop is active).
- Teams (teams-for-linux 2.25.0) was open. xdg-desktop-portal-hyprland 1.4.1 provides InputCapture, but the journal shows no capture session ever opened.
- No code in `onMouseButton` / `processMouseDownNormal` (v0.56.2) checks for left specifically. Left-only loss is **unexplained**. Leads: a stuck Wayland drag-and-drop (DnD starts from a left press; not logged at this log level), or state in a path not yet read (seat / data-device).

The analysis below was written after episode 1. Its resize-bug theory **doesn't explain episode 3**, where no resize happened and the drag theory was ruled out.

**Isolated to the Hyprland process:**

| Suspect | Test | Result |
|---|---|---|
| Hardware | touchpad dead too | ruled out |
| Kernel / libinput | `libinput debug-events` showed `button left pressed` | ruled out, OS got the click |
| keyd | restarted keyd + unplugged/replugged all USB input (journal confirms) | ruled out, bug survived; keyd doesn't touch the touchpad anyway |
| Config | read `input` block + all binds; only `Super+LMB/RMB` touch `mouse:272/273` | ruled out |
| Overlay / grab | `hyprctl layers`, process list, `hyprctl submap` = `default` | ruled out |
| Config reload | `hyprctl reload` | no effect |
| **Hyprland runtime state** | exiting Hyprland and logging back in | **fixed it** |

**Suspected root cause (strong, not reproduced):** upstream bug in the Lua `hl.dsp.window.resize()` dispatcher (our `Super+RMB` bind):
- `hlWindowResize` stores its upvalue as a **number**; `dsp_mouseResize` reads it with `Check::string`. On failure it returns early, *after* setting `releasePending` and *without* calling `CA::mouse("resizewindow …")`. Known result on this exact build: intermittent SIGSEGV/SIGABRT (hyprwm/Hyprland#16058, omacom/omarchy#15433). Fixed upstream in `1c4fbb6` (`Check::number`), one line; **in no release yet**.
- Click swallowing: on every mouse event `KeybindManager::onMouseEvent` calls `ensureMouseBindState()`. If the drag controller still has a target, it ends the drag and suppresses that click. A drag target that never clears → every click suppressed forever. While a target exists, `changeMouseBindMode` returns early, so `Super+click` can't start a new drag to "finish" the stuck one (tried, didn't help).
- **Not proven:** the drag-end code wasn't read, so *why* the target stays stuck is unknown. It's also unknown whether `Super+RMB` was used before the freeze. Same symptom reported upstream since 2024 (hyprwm/Hyprland#6551, closed as not planned, still reported on 0.56.2), so it may have more than one cause.

**Recovery:** first try `systemctl suspend` (see Quick fix above). Not effective: reload, keyd restart, replug, `Super+click`, rofi open/close, unbinding `Super+LMB`. Last resort is restarting Hyprland, which kills all windows; save first:
```
hyprctl dispatch 'hl.dsp.exit()'     # then log back in; fallback: pkill Hyprland
```
No keyboard bind exits Hyprland (`Super+M` is wdisplays). With no clicks, copy commands via `wl-copy` and paste with `Ctrl+Shift+V` in kitty.

**If it happens again, capture before restarting:**
```
cp /run/user/1000/hypr/*/hyprland.log ~/hypr-stuck.log   # per-instance logs, gone after reboot
nix shell nixpkgs#libinput -c sudo libinput debug-events # confirms OS sees clicks
nix shell nixpkgs#wev -c wev                             # does any client get button events?
```
Also note the last mouse action (especially `Super+RMB` resizes).

**Gotchas from this investigation:**
- **Hyprland 0.56 Lua `dispatch` takes Lua, not legacy args:** `hyprctl dispatch mouse 0movewindow` → `malformed number near '0m'`. Use `hyprctl dispatch 'hl.dsp.…()'`.
- `hyprctl binds -j` shows `"mouse": false` for the `{ mouse = true }` binds. **That's expected:** the Lua path tracks mouse binds via `releasePending`, not the legacy flag. `{ mouse = true }` is valid (official wiki and shipped example use it). The shipped stubs (`<hyprland pkg>/share/hypr/stubs/hl.meta.lua`) omit `mouse` from `HL.BindOptions`, so they're incomplete.
- Shipped reference config: `<hyprland pkg>/share/hypr/hyprland.lua`. The real binary for `strings` is `bin/.Hyprland-wrapped`, not `bin/Hyprland` (a 16 KB Nix wrapper).
- `xev` sees nothing native on Wayland; `libinput`, `evtest`, `ydotool` aren't installed; `/dev/input/event*` are `root:input`, so non-root tools can't read them.
- Hyprland logs at debug level by default here, mostly touchpad gesture spam: filter with `grep -v 'libinput\]'`. Normal boot noise: `Wayland backend cannot start` (tries nested first), `drm: Cannot commit when a page-flip is awaiting`.

---

## Waybar CPU / thermals (investigated 2026-11-16, laptop hit 94 °C)

**Root cause: the animated waybar border.** `#waybar` in `style.css` had `animation: border-flow 8s linear infinite` (a 400 %-tall gradient sliding through a 2 px border) on top of two blurred `box-shadow` glows. Waybar is GTK3 and paints with Cairo **on the CPU**, so it restyled and repainted the whole bar every frame, forever: ~60 % of one core, 151 CPU-minutes in 4 h 17 min uptime, all on the main thread (the other 22 threads idle, no child process busy).

Measured A/B on a quiet system (waybar CPU, 15 s windows):

| Variant | Waybar CPU |
|---|---|
| animation + glow shadows (old) | ~60 % |
| animation, glow shadows removed | ~17 % |
| **static glow, animation off (current)** | **0 %** |

- `animation-timing-function: steps(N)` and a 60 s duration did **not** help (~60 %): GTK ticks the frame clock every frame regardless. Static glow alone is free; the *animation* is what costs.
- The animation line is commented out in `style.css` with a note; the `@keyframes` block is kept so re-enabling is one line. Don't turn it back on blindly.
- **Hyprland's own animated border is fine.** It is a GL shader on the GPU (only an angle uniform changes). Hyprland CPU with `borderangle` loop on vs off: 0 % vs 0–2 %. GPU (Iris Xe, `i915`): GPU "busy" (= 100 % − RC6 residency) ~12 % on vs ~5 % off, so ~7 points of extra wake time, small. Keep it. Turn it off only if battery/heat matters: `hyprctl eval 'hl.animation({ leaf = "borderangle", enabled = false })'` (runtime only; `Super+R` restores the config).
- **Waybar cannot do a GPU border.** GTK3/Cairo has no GPU path and Hyprland draws borders only on windows, not layer surfaces (not seen in 0.56.2; checked via binary strings only). Options if ever wanted: (A) a small GTK4 layer-shell overlay drawing the glow ring behind a transparent waybar (must track the bar size/margins that `toggle-layout` changes, and recolour with `apply-theme`), or (B) replace waybar with Quickshell (Qt Quick, GPU). Neither is installed or built. Static glow was accepted instead.

Other contributors seen (not changed):
- A render job (`remotion` + headless chromium + ffmpeg, `--concurrency=4`) was running and pushed load to ~6.8; it was legitimate work, not a leak. It used 4.2 GB RSS; swap sat at ~4 GB.
- CPU governor `performance` on AC, `intel_pstate`, `auto-cpufreq` enabled with no `/etc/auto-cpufreq.conf` (defaults: performance on AC). Not touched.
- `custom/eyecare` forks bash every 1 s; `custom/vpn` every 5 s. Small.
- Waybar once died on its own with no journal/`dmesg` trace (cause unknown); restart with `bash ~/.config/waybar/launch`.

**Measuring gotchas (they bit this investigation):**
- NixOS process names are wrapped: `.waybar-wrapped`, `.Hyprland-wrapp`. `pgrep -x waybar` / `pgrep -x Hyprland` return nothing, and `pgrep -f` matches your own shell command line. With an empty PID, `/proc/$pid/stat` collapses to `/proc/stat` and gives garbage. Use `pgrep -x .waybar-wrapped`, or the PID from `ps`.
- CPU % = delta of utime+stime (`/proc/PID/stat` fields 14+15) / `getconf CLK_TCK` / seconds. `strace` is blocked (`kernel.yama.ptrace_scope=1`).
- `hyprctl keyword` does not work with the Lua config ("Use eval"); use `hyprctl eval 'hl.animation({...})'`.
- `apply-theme` rewrites `style.css` colours at any time. Never restore a backup copy of the file over it (that reverts the theme); patch single lines only. `reload_style_on_change` applies edits live.
- When scripting sed edits to test CSS variants, assert the replacement applied. A silently failed sed once made three "variants" all identical.
- GPU busy without `intel_gpu_top`: read `/sys/class/drm/card1/gt/gt0/rc6_residency_ms` over a window; `rps_act_freq_mhz` reads ~0 whenever the GPU is asleep, so don't trust it as an average clock.
