-- chadrc.lua — NvChad UI config. Structure must match nvconfig.lua.
-- Reference: https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
--
-- `theme` and `hl_override` belong to M.base46, NOT M.ui — with them under M.ui NvChad silently
-- ignores them and falls back to "onedark", so no theme ever applied.
-- "dynamic" is lua/themes/dynamic.lua, generated from the active palette by apply-theme.

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "dynamic",

  hl_override = {
    Normal        = { bg = "NONE" },
    NormalNC      = { bg = "NONE" },
    NormalFloat   = { bg = "NONE" },
    FloatBorder   = { bg = "NONE" },
    SignColumn    = { bg = "NONE" },
    EndOfBuffer   = { bg = "NONE" },
  },
}

return M
