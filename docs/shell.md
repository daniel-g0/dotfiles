# Shell

Nushell, Starship and the nushell aliases.

## Nushell

**Config:** `nushell/config.nu` | **Aliases:** `nushell/aliases/<tool>/<tool>-aliases.nu`

### Shell behavior
- Vi mode — block cursor in normal, line in insert; `󱄅 N` / `󱄅 I` indicators
- History: SQLite, 100k entries, per-session, dedup, timestamps, auto-sync on entry
- Zoxide smart directory jumping (`z`, `zi`)
- `$EDITOR` / `$VISUAL` / `buffer_editor` all set to `nvim`

### Hooks
- **Pre-prompt title:** Updates kitty tab bar every prompt: `~/path 󰊢 branch [+staged ~modified ?untracked] | Nf Nd`
- **PWD change:** Auto-clears screen on `cd` to any non-home directory
- **Greeting:** Fastfetch + centered fortune "Quote of the Day" — only fires when `NU_BANNER=1` is in env (set by waybar distro logo kitty launch)

### FZF keybinds
| Key | Action |
|-----|--------|
| `Ctrl+R` | Fuzzy history search |
| `Ctrl+T` | Fuzzy file picker → insert path (fd-powered) |
| `Alt+C` | Fuzzy cd to directory |

### Alias modules
| Module | Key aliases |
|--------|-------------|
| `bat` | `b`, `bn` (numbered), `bp` (plain), `bl` |
| `docker` | 35+ aliases — build, image, container, network, volume; `dsta` (stop all) |
| `git` | 150+ aliases + helpers (`git_current_branch`, `git_main_branch`, worktree, rebase flows) |
| `nixos` | `nixos-edit`, `nixos-re-sw` (rebuild switch), `nixos-garbage` (7d+ cleanup) |
| `nvim` | `n` |
| `rip` | `rm` → rip (trash), `rd` (restore deleted) |
| `utils` | `grep`→rg, `find`→fd, `du`→dust, `top`→btop, `cb` (copy), `cbp` (paste) |
| `chezmoi` | `ch`, `chad`, `chap`, `chd`, `chda`, `chs` |

### Custom completions
Bat, Docker, GitHub CLI, Git, Less, Make, Man, Nix, SSH, Tar, tldr, uv, Zoxide

---

## Starship

**Config:** `starship/starship.toml`

- Single-line, no newline
- **Left:** Language icons (C, Python, Node, Rust, Go, Java, Docker) — appear only in matching project dirs
- **Right:** Username (purple `#bb9af7`; red `#f7768e` for root)
- No cmd_duration, no directory/git in starship (handled by nushell pre-prompt hook + kitty tab bar)

### Git status symbols
`⇡N` ahead · `⇣N` behind · `⇕` diverged · `~` conflicted · `*` stashed · ` ` modified · `++N` staged · `?` untracked · ` ` deleted

---

## Useful aliases (nushell)

| Alias | Command |
|-------|---------|
| `nixos-re-sw` | `sudo nixos-rebuild switch` |
| `nixos-edit` | `sudo nvim /etc/nixos/configuration.nix` |
| `nixos-garbage` | `sudo nix-collect-garbage --delete-older-than 7d` |
| `n` | `nvim` |
| `z` | zoxide jump |
| `rm` | rip (trash, recoverable) |
| `rd` | restore from rip trash |
| `grep` | ripgrep |
| `find` | fd |
| `du` | dust |
| `top` | btop |
| `cb` | wl-copy |
| `cbp` | wl-paste |
