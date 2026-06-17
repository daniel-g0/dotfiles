vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },
  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
-- require('tabnine').setup({
--   disable_auto_comment=true,
--   accept_keymap="<F8>",
--   dismiss_keymap = "<F7>",
--   debounce_ms = 800,
--   suggestion_color = {gui = "#808080", cterm = 244},
--   exclude_filetypes = {"TelescopePrompt", "NvimTree"},
--   log_file_path = nil, -- absolute path to Tabnine log file
-- })

function execpython()
  local file = vim.api.nvim_buf_get_name(0)
  if file:match("%.py$") then
    vim.cmd("write")
    vim.cmd("!" .. "python3 " .. file)
  else
    print("Error: This is not a Python file!")
  end
end

vim.api.nvim_set_keymap("n", "<F9>", ":lua execpython()<CR>", { noremap = true, silent = true })


vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  command = "silent! wall",
})

local function crun()
  local file = vim.api.nvim_buf_get_name(0)
  if file:match("%.c$") then
    vim.cmd("write")
    vim.cmd("!gcc -Wall " .. file)
    vim.cmd("!./a.out")
    vim.cmd("!rm a.out")
  else
    print("Error: This is not a C file!")
  end
end

vim.api.nvim_create_user_command("WallRun", crun, {})

vim.api.nvim_set_keymap("n", "<F10>", ":WallRun<CR>", { noremap = true, silent = true })


require("cyberdream").setup({
    transparent = true,
    italic_comments = true,
    hide_fillchars = ' ',
    borderless_telescope = true,
    terminal_colors = true,
    theme = {
        variant = "default",
        highlights = {
            Comment = { fg = "#696969", bg = "NONE", italic = true },
        },
        overrides = function(colors)
            return {
                Comment = { fg = colors.green, bg = "NONE", italic = true },
                ["@property"] = { fg = colors.magenta, bold = true },
            }
        end,
        colors = {
            bg = "#000000",
            green = "#00ff00",
            magenta = "#ff00ff",
        },
    },
    extensions = {
        telescope = true,
        notify = false,
        mini = true,
    },
})
vim.cmd("colorscheme cyberdream")

-- init.lua
local neogit = require('neogit')
neogit.setup {}

require("zen-mode").setup({
  window = {
    width = .75 -- width will be 85% of the editor width
  }
})
require("toggleterm").setup{}
-- require("leetcode").setup{
--     ---@type string
--     arg = "leetcode.nvim",
--
--     ---@type lc.lang
--     lang = "cpp",
--
--     cn = { -- leetcode.cn
--         enabled = false, ---@type boolean
--         translator = true, ---@type boolean
--         translate_problems = true, ---@type boolean
--     },
--
--     ---@type lc.storage
--     storage = {
--         home = vim.fn.stdpath("data") .. "/leetcode",
--         cache = vim.fn.stdpath("cache") .. "/leetcode",
--     },
--
--     ---@type table<string, boolean>
--     plugins = {
--         non_standalone = false,
--     },
--
--     ---@type boolean
--     logging = true,
--
--     injector = {}, ---@type table<lc.lang, lc.inject>
--
--     cache = {
--         update_interval = 60 * 60 * 24 * 7, ---@type integer 7 days
--     },
--
--     console = {
--         open_on_runcode = true, ---@type boolean
--
--         dir = "row", ---@type lc.direction
--
--         size = { ---@type lc.size
--             width = "90%",
--             height = "75%",
--         },
--
--         result = {
--             size = "60%", ---@type lc.size
--         },
--
--         testcase = {
--             virt_text = true, ---@type boolean
--
--             size = "40%", ---@type lc.size
--         },
--     },
--
--     description = {
--         position = "left", ---@type lc.position
--
--         width = "40%", ---@type lc.size
--
--         show_stats = true, ---@type boolean
--     },
--
--     hooks = {
--         ---@type fun()[]
--         ["enter"] = {},
--
--         ---@type fun(question: lc.ui.Question)[]
--         ["question_enter"] = {},
--
--         ---@type fun()[]
--         ["leave"] = {},
--     },
--
--     keys = {
--         toggle = { "q" }, ---@type string|string[]
--         confirm = { "<CR>" }, ---@type string|string[]
--
--         reset_testcases = "r", ---@type string
--         use_testcase = "U", ---@type string
--         focus_testcases = "H", ---@type string
--         focus_result = "L", ---@type string
--     },
--
--     ---@type lc.highlights
--     theme = {},
--
--     ---@type boolean
--     image_support = false,
-- }

-- require("hardtime").setup() -- Set 2024-11-07
-- require("mistake")
vim.api.nvim_command('set relativenumber')
vim.api.nvim_command('set spell')
