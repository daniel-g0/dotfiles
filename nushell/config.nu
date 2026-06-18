# config.nu — Nushell startup: prompt, vi mode, editor, aliases, completions.

# -- Starship prompt -----------------------------------------------------------------
# Init starship and save its nu script for autoloading on next shell start.
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# -- Zoxide (smart directory jumping) ------------------------------------------------
source /home/user/.config/zoxide/config.nu

# -- Vi mode -------------------------------------------------------------------------
# Block cursor in normal mode, line cursor in insert. Logo+mode inline.
$env.config.edit_mode           = 'vi'
$env.config.cursor_shape        = { vi_insert: line, vi_normal: block }
$env.PROMPT_INDICATOR_VI_INSERT = "󱄅 I "
$env.PROMPT_INDICATOR_VI_NORMAL = "󱄅 N "

# -- Editor & preferences ------------------------------------------------------------
$env.config.buffer_editor = "nvim"
$env.EDITOR               = "nvim"
$env.VISUAL               = "nvim"
$env.config.show_banner   = false

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
source ~/.config/nushell/themes/black-metal-dark-funeral.nu

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

# -- Greeting (login shell only) -----------------------------------------------------
if $nu.is-interactive and not ($env | get -o GREETED | default false) {
    $env.GREETED = true
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
