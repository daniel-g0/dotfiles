-- palette.lua — feeds the active apply-theme palette (~/.cache/dynamic-theme/palette.json) into
-- tokyonight, so nvim (and lualine, whose theme is derived from tokyonight's colours) follows the same
-- theme as every other app. Without a palette file it stays stock Tokyo Night.
--
-- apply-theme calls require("palette").reload() in every running nvim after a theme change.

local M = {}

local PALETTE = vim.fn.expand "~/.cache/dynamic-theme/palette.json"

local function read()
  local f = io.open(PALETTE)
  if not f then
    return nil
  end
  local ok, p = pcall(vim.json.decode, f:read "*a")
  f:close()
  return ok and p or nil
end

M.opts = {
  style = "night",
  transparent = true,
  terminal_colors = true,
  cache = false, -- the cache is keyed on the stock palette; on_colors changes it
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    sidebars = "dark",
    floats = "dark",
  },
  on_colors = function(c)
    local p = read()
    if not p then
      return
    end
    local util = require "tokyonight.util"

    c.bg, c.bg_dark, c.bg_dark1, c.bg_float, c.bg_sidebar = p.bg, p.bg, p.bg, p.bg, p.bg
    c.bg_statusline, c.bg_popup, c.bg_highlight = p.bg_alt, p.bg_alt, p.bg_alt
    c.bg_visual = util.lighten(p.bg_alt, 0.9)
    c.bg_search = util.lighten(p.bg_alt, 0.8)
    c.border, c.border_highlight = p.bg_alt, p.blue

    c.fg, c.fg_dark, c.fg_float = p.fg, p.fg, p.fg
    c.fg_gutter, c.dark3, c.dark5 = p.fg_dim, p.fg_dim, util.lighten(p.fg_dim, 0.9)
    c.comment = util.lighten(p.fg_dim, 0.85)

    c.blue, c.blue0, c.blue1 = p.blue, util.darken(p.blue, 0.8), p.cyan
    c.blue2, c.blue5, c.blue6, c.blue7 = p.cyan, p.cyan, p.cyan, util.darken(p.blue, 0.6)
    c.cyan, c.teal = p.cyan, p.cyan
    c.green, c.green1, c.green2 = p.green, p.green, p.green
    c.magenta, c.magenta2, c.purple = p.accent, p.accent, p.accent
    c.orange, c.yellow = p.yellow, p.yellow
    c.red, c.red1 = p.red, util.darken(p.red, 0.8)
    c.git = { add = p.green, change = p.blue, delete = p.red, ignore = p.fg_dim }
  end,
}

M.reload = function()
  require("tokyonight").setup(M.opts)
  vim.cmd.colorscheme "tokyonight"
end

return M
