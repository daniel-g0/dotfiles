# config.nu
#
# Installed by:
# version = "0.112.2"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# -- Starship ----------------------------------------------------------------------
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# -- Zoxide -----------------------------------------------------------------------
source /home/user/.config/zoxide/config.nu

# -- Vim mode ---------------------------------------------------------------------
$env.config.edit_mode = 'vi'
$env.config.cursor_shape = { vi_insert: line, vi_normal: block }
$env.PROMPT_INDICATOR_VI_INSERT = "> "
$env.PROMPT_INDICATOR_VI_NORMAL = "$ "   

# -- Preferences -----------------------------------------------------------------
$env.config.buffer_editor = "hx"
$env.config.show_banner = false

# -- Visuals ---------------------------------------------------------------------
source ~/.config/nushell/themes/black-metal-dark-funeral.nu

# -- Aliases ---------------------------------------------------------------------
use ~/.config/nushell/aliases/bat/bat-aliases.nu  *
use ~/.config/nushell/aliases/chezmoi/chezmoi-aliases.nu *
use ~/.config/nushell/aliases/docker/docker-aliases.nu *
use ~/.config/nushell/aliases/git/git-aliases.nu *
use ~/.config/nushell/aliases/nixos/nixos-aliases.nu *
# I left out more availiable under the aliases, I'm using what I need.


# -- Autocomplete ----------------------------------------------------------------
use ~/.config/nushell/custom-completions/bat/bat-completions.nu *
use ~/.config/nushell/custom-completions/docker/docker-completions.nu *
use ~/.config/nushell/custom-completions/gh/gh-completions.nu *
use ~/.config/nushell/custom-completions/git/git-completions.nu *
use ~/.config/nushell/custom-completions/less/less-completions.nu *
use ~/.config/nushell/custom-completions/make/make-completions.nu *
use ~/.config/nushell/custom-completions/man/man-completions.nu *
use ~/.config/nushell/custom-completions/nix/nix-completions.nu *
use ~/.config/nushell/custom-completions/ssh/ssh-completions.nu *
use ~/.config/nushell/custom-completions/tar/tar-completions.nu *
use ~/.config/nushell/custom-completions/tldr/tldr-completions.nu *
use ~/.config/nushell/custom-completions/uv/uv-completions.nu *
use ~/.config/nushell/custom-completions/zoxide/zoxide-completions.nu *
# I left out more availiable under the custom-completions dir, I'm using what I need.
