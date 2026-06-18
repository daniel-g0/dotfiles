# config.nu — Nushell startup: prompt, vi mode, editor, aliases, completions.

# -- Starship prompt -----------------------------------------------------------------
# Init starship and save its nu script for autoloading on next shell start.
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# -- Zoxide (smart directory jumping) ------------------------------------------------
source ~/.config/zoxide/config.nu

# -- Vi mode -------------------------------------------------------------------------
# Block cursor in normal mode, line cursor in insert. Logo+mode inline.
$env.config.edit_mode           = 'vi'
$env.config.cursor_shape        = { vi_insert: line, vi_normal: block }
$env.PROMPT_INDICATOR_VI_INSERT = "󱄅 I "
$env.PROMPT_INDICATOR_VI_NORMAL = "󱄅 N "

# -- Editor & preferences ------------------------------------------------------------
$env.config.buffer_editor        = "nvim"
$env.EDITOR                      = "nvim"
$env.VISUAL                      = "nvim"
$env.WALLPAPER_DIR               = ($env.HOME | path join ".config/wallpapers")
$env.config.show_banner          = false
$env.config.error_style        = "fancy"
$env.config.use_kitty_protocol = true

# -- fzf -------------------------------------------------------------------------
# Tokyo Night colors + useful keybinds:
#   Ctrl+R → fuzzy history search
#   Ctrl+T → fuzzy file picker (insert path)
#   Alt+C  → fuzzy cd
$env.FZF_DEFAULT_OPTS = [
    "--height=40%"
    "--reverse"
    "--border"
    "--color=bg+:#1a1b26,bg:#1a1b26,spinner:#bb9af7,hl:#f7768e"
    "--color=fg:#c0caf5,header:#7aa2f7,info:#7dcfff,pointer:#bb9af7"
    "--color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#f7768e"
] | str join " "

$env.config.keybindings = ($env.config.keybindings | append [
    {
        name: fzf_history
        modifier: control
        keycode: char_r
        mode: [vi_insert vi_normal]
        event: {
            send: executehostcommand
            cmd: "commandline edit --replace (history | get command | reverse | uniq | str join (char -u '0a') | fzf +s --tac | str trim)"
        }
    }
    {
        name: fzf_files
        modifier: control
        keycode: char_t
        mode: [vi_insert]
        event: {
            send: executehostcommand
            cmd: "commandline edit --insert (fd --type f | fzf | str trim)"
        }
    }
    {
        name: fzf_cd
        modifier: alt
        keycode: char_c
        mode: [vi_insert]
        event: {
            send: executehostcommand
            cmd: "cd (fd --type d | fzf | str trim)"
        }
    }
])

# -- History -------------------------------------------------------------------------
# SQLite history lives in the config dir as history.sqlite3 (gitignored).
# SQLite adds per-session isolation, timestamps, and dedup — better than plain-text.
$env.config.history.file_format   = "sqlite"
$env.config.history.max_size      = 100_000
$env.config.history.sync_on_enter = true
$env.config.history.isolation     = false

# -- Theme ---------------------------------------------------------------------------
source ~/.config/nushell/themes/tokyo-night.nu

# -- Aliases -------------------------------------------------------------------------
use ~/.config/nushell/aliases/bat/bat-aliases.nu         *
use ~/.config/nushell/aliases/chezmoi/chezmoi-aliases.nu *
use ~/.config/nushell/aliases/docker/docker-aliases.nu   *
use ~/.config/nushell/aliases/git/git-aliases.nu         *
use ~/.config/nushell/aliases/nixos/nixos-aliases.nu     *
use ~/.config/nushell/aliases/nvim/nvim-aliases.nu       *
use ~/.config/nushell/aliases/rip/rip-aliases.nu         *
use ~/.config/nushell/aliases/utils/utils-aliases.nu     *

# -- Completions ---------------------------------------------------------------------
use ~/.config/nushell/custom-completions/bat/bat-completions.nu       *
use ~/.config/nushell/custom-completions/docker/docker-completions.nu *
use ~/.config/nushell/custom-completions/gh/gh-completions.nu         *
use ~/.config/nushell/custom-completions/git/git-completions.nu       *
use ~/.config/nushell/custom-completions/less/less-completions.nu     *
use ~/.config/nushell/custom-completions/make/make-completions.nu     *
use ~/.config/nushell/custom-completions/man/man-completions.nu       *
use ~/.config/nushell/custom-completions/nix/nix-completions.nu       *
use ~/.config/nushell/custom-completions/ssh/ssh-completions.nu       *
use ~/.config/nushell/custom-completions/tar/tar-completions.nu       *
use ~/.config/nushell/custom-completions/tldr/tldr-completions.nu     *
use ~/.config/nushell/custom-completions/uv/uv-completions.nu         *
use ~/.config/nushell/custom-completions/zoxide/zoxide-completions.nu *

# -- Terminal title (kitty tab bar) --------------------------------------------------
# Updates title on every prompt: "~/path 󰊢 branch [+3 ~1] | 12f 4d"
$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt? | default [] | append {||
    let dir = ($env.PWD | str replace $env.HOME "~")

    let git = (try {
        let branch = (^git branch --show-current err> /dev/null | str trim)
        if ($branch | is-empty) { "" } else {
            let status    = (^git status --porcelain err> /dev/null | lines)
            let staged    = ($status | where {|l| ($l | str substring 0..1) != " " and ($l | str substring 0..1) != "?" } | length)
            let modified  = ($status | where {|l| ($l | str substring 1..2) == "M" } | length)
            let untracked = ($status | where {|l| ($l | str substring 0..2) == "??" } | length)
            let dirty     = (
                [
                    (if $staged    > 0 { $"+($staged)"    } else { "" })
                    (if $modified  > 0 { $"~($modified)"  } else { "" })
                    (if $untracked > 0 { $"?($untracked)" } else { "" })
                ] | where {|s| not ($s | is-empty) } | str join " "
            )
            let dirty_part = if ($dirty | is-empty) { "" } else { $" [($dirty)]" }
            $" 󰊢 ($branch)($dirty_part)"
        }
    } catch { "" })

    let all   = (try { ls -a | length } catch { 0 })
    let dirs  = (try { ls -a | where type == "dir" | length } catch { 0 })
    let counts = $" | ($all - $dirs)f ($dirs)d"

    print -n $"\e]0;($dir)($git)($counts)\a"
})

# -- Clear on cd (scrollback preserved) ---------------------------------------------
$env.config.hooks.env_change.PWD = (
    $env.config.hooks.env_change.PWD? | default [] | append {|before, after|
        if $after != $env.HOME { clear }
    }
)

# -- Greeting (login shell only) -----------------------------------------------------
if ("NU_BANNER" in $env) {
    fastfetch
    let cols = (term size).columns
    let title = "✦  Quote of the Day"
    let sep = $"(ansi purple)("" | fill --character "━" --width $cols)(ansi reset)"
    let centered_title = $"(ansi blue)($title | fill --alignment center --width $cols)(ansi reset)"
    let quote_lines = (fortune | lines | each {|l| $"(ansi white_bold)($l | fill --alignment center --width $cols)(ansi reset)" })
    print ""
    print $sep
    print $centered_title
    print $sep
    print ""
    $quote_lines | each {|l| print $l }
    print ""
    print $sep
    print ""
}
