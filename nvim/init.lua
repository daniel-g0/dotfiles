-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  init.lua  —  NvChad entry point
--
--  Load order:
--    1. lazy.nvim bootstrap
--    2. NvChad core  (options, base46 cache, autocmds, mappings)
--    3. User plugins (lua/plugins/init.lua)
--    4. Custom commands / autocmds
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- ── bootstrap ─────────────────────────────────────────────────────
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader    = " "

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- ── plugins ───────────────────────────────────────────────────────
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

-- ── NvChad post-setup ─────────────────────────────────────────────
-- base46 cache may not exist on first run (before :Lazy sync)
if vim.loop.fs_stat(vim.g.base46_cache .. "defaults") then
  dofile(vim.g.base46_cache .. "defaults")
  dofile(vim.g.base46_cache .. "statusline")
end
require "nvchad.autocmds"
vim.schedule(function()
  require "mappings"
end)

-- ── custom commands & autocmds ────────────────────────────────────

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

-- ── run current file ──────────────────────────────────────────────
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

-- ── auto-save all buffers on write ────────────────────────────────
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  command = "silent! wall",
})

-- ── LSP hover on cursor hold ───────────────────────────────────────
-- Shows type info / docs popup after updatetime ms of not moving.
-- Only fires when an LSP client is attached; silent on no info.
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
      vim.lsp.buf.hover()
    end
  end,
})

-- ── compile & run C ───────────────────────────────────────────────
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
