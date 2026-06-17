-- init.lua — NvChad entry point: bootstrap lazy.nvim, load plugins, colorscheme, custom commands.

-- NvChad requires this cache path set before lazy loads.
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader    = " "

-- Bootstrap lazy.nvim if not already installed
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugins: NvChad core + user plugins from lua/plugins/
local lazy_config = require "configs.lazy"
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy   = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },
  { import = "plugins" },
}, lazy_config)

-- Apply NvChad base46 theme cache and register autocmds/mappings
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
require "nvchad.autocmds"
vim.schedule(function()
  require "mappings"
end)

-- Tabnine AI completion (disabled — uncomment to enable)
-- require('tabnine').setup({
--   disable_auto_comment = true,
--   accept_keymap        = "<F8>",
--   dismiss_keymap       = "<F7>",
--   debounce_ms          = 800,
--   suggestion_color     = { gui = "#808080", cterm = 244 },
--   exclude_filetypes    = { "TelescopePrompt", "NvimTree" },
--   log_file_path        = nil,
-- })

-- F9: write and run the current Python file
local function execpython()
  local file = vim.api.nvim_buf_get_name(0)
  if file:match("%.py$") then
    vim.cmd("write")
    vim.cmd("!" .. "python3 " .. file)
  else
    print("Error: This is not a Python file!")
  end
end
vim.api.nvim_set_keymap("n", "<F9>", ":lua execpython()<CR>", { noremap = true, silent = true })

-- Auto-save all open buffers after every write event
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  command = "silent! wall",
})

-- F10 / :WallRun — compile and run the current C file, then clean up the binary
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

-- Cyberdream colorscheme — transparent bg, custom comment/property highlights
require("cyberdream").setup({
  transparent          = true,
  italic_comments      = true,
  hide_fillchars       = ' ',
  borderless_telescope = true,
  terminal_colors      = true,
  theme = {
    variant    = "default",
    highlights = {
      Comment = { fg = "#696969", bg = "NONE", italic = true },
    },
    overrides = function(colors)
      return {
        Comment       = { fg = colors.green, bg = "NONE", italic = true },
        ["@property"] = { fg = colors.magenta, bold = true },
      }
    end,
    colors = {
      bg      = "#000000",
      green   = "#00ff00",
      magenta = "#ff00ff",
    },
  },
  extensions = {
    telescope = true,
    notify    = false,
    mini      = true,
  },
})
vim.cmd("colorscheme cyberdream")

-- Neogit — git interface (setup must run after lazy loads the plugin)
local neogit = require('neogit')
neogit.setup {}

-- Zen mode — focused editing at 75% editor width
require("zen-mode").setup({
  window = { width = .75 }
})

-- Toggleterm — persistent terminal windows
require("toggleterm").setup{}

-- LeetCode (disabled — uncomment to enable)
-- require("leetcode").setup{
--     arg  = "leetcode.nvim",
--     lang = "cpp",
--     cn = { enabled = false, translator = true, translate_problems = true },
--     storage = {
--         home  = vim.fn.stdpath("data") .. "/leetcode",
--         cache = vim.fn.stdpath("cache") .. "/leetcode",
--     },
--     plugins  = { non_standalone = false },
--     logging  = true,
--     injector = {},
--     cache    = { update_interval = 60 * 60 * 24 * 7 },
--     console  = {
--         open_on_runcode = true,
--         dir    = "row",
--         size   = { width = "90%", height = "75%" },
--         result   = { size = "60%" },
--         testcase = { virt_text = true, size = "40%" },
--     },
--     description = { position = "left", width = "40%", show_stats = true },
--     hooks = {
--         ["enter"]          = {},
--         ["question_enter"] = {},
--         ["leave"]          = {},
--     },
--     keys = {
--         toggle          = { "q" },
--         confirm         = { "<CR>" },
--         reset_testcases = "r",
--         use_testcase    = "U",
--         focus_testcases = "H",
--         focus_result    = "L",
--     },
--     theme         = {},
--     image_support = false,
-- }

-- require("hardtime").setup()
-- require("mistake")

vim.api.nvim_command('set relativenumber')
vim.api.nvim_command('set spell')
