-- chadrc.lua — NvChad UI config. Structure must match nvconfig.lua.
-- Reference: https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "catppuccin",

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
