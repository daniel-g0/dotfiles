# config.nu — Nushell startup: prompt, vi mode, editor, aliases, completions.

# -- Starship prompt -----------------------------------------------------------------
# Init starship and save its nu script for autoloading on next shell start.
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# -- Zoxide (smart directory jumping) ------------------------------------------------
source /home/user/.config/zoxide/config.nu

# -- Vi mode -------------------------------------------------------------------------
# Block cursor in normal mode, line cursor in insert. Greek letters as mode indicators.
$env.config.edit_mode           = 'vi'
$env.config.cursor_shape        = { vi_insert: line, vi_normal: block }
$env.PROMPT_INDICATOR_VI_INSERT = "ι "
$env.PROMPT_INDICATOR_VI_NORMAL = "η "

# -- Editor & preferences ------------------------------------------------------------
$env.config.buffer_editor = "nvim"
$env.EDITOR               = "nvim"
$env.VISUAL               = "nvim"
$env.config.show_banner   = false

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
