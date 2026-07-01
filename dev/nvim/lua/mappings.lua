-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  mappings.lua  —  keybindings (extends nvchad.mappings)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

require("nvchad.mappings")

local map = vim.keymap.set

-- ── command mode ──────────────────────────────────────────────────
map("n", ";",  ":",        { desc = "Enter command mode" })
map("i", "jk", "<ESC>",   { desc = "Escape insert mode" })

-- ── window navigation ─────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })

-- ── window resize ─────────────────────────────────────────────────
map("n", "<C-Up>",    ":resize +2<cr>",          { silent = true, desc = "Increase height" })
map("n", "<C-Down>",  ":resize -2<cr>",           { silent = true, desc = "Decrease height" })
map("n", "<C-Left>",  ":vertical resize -2<cr>",  { silent = true, desc = "Decrease width" })
map("n", "<C-Right>", ":vertical resize +2<cr>",  { silent = true, desc = "Increase width" })

-- ── buffer navigation ─────────────────────────────────────────────
map("n", "<Tab>",   ":bnext<cr>",     { silent = true, desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<cr>", { silent = true, desc = "Prev buffer" })
map("n", "<leader>bd", ":bdelete<cr>", { silent = true, desc = "Delete buffer" })

-- ── move lines in visual mode ─────────────────────────────────────
map("v", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "Move selection up" })

-- ── keep cursor centered ──────────────────────────────────────────
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down + center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up + center" })
map("n", "n",     "nzzzv",   { desc = "Next search result centered" })
map("n", "N",     "Nzzzv",   { desc = "Prev search result centered" })

-- ── clipboard ─────────────────────────────────────────────────────
-- paste without overwriting clipboard register
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
-- yank to system clipboard
map({ "n", "v" }, "<leader>y", '"+y',  { desc = "Yank to clipboard" })
map("n",          "<leader>Y", '"+Y',  { desc = "Yank line to clipboard" })

-- ── clear search highlight ────────────────────────────────────────
map("n", "<Esc>", ":noh<cr>", { silent = true, desc = "Clear search highlight" })

-- ── splits ────────────────────────────────────────────────────────
map("n", "<leader>sv", ":vsplit<cr>", { silent = true, desc = "Vertical split" })
map("n", "<leader>sh", ":split<cr>",  { silent = true, desc = "Horizontal split" })
map("n", "<leader>sc", ":close<cr>",  { silent = true, desc = "Close split" })

-- ── quickfix ──────────────────────────────────────────────────────
map("n", "]q", ":cnext<cr>",     { silent = true, desc = "Next quickfix item" })
map("n", "[q", ":cprevious<cr>", { silent = true, desc = "Prev quickfix item" })

-- ── run current file ──────────────────────────────────────────────
-- Python: F9  (defined in init.lua)
-- C:      F10 / :WallRun  (defined in init.lua)

-- ── terminal ──────────────────────────────────────────────────────
map("n", "<leader>tt", ":ToggleTerm<cr>",                       { silent = true, desc = "Toggle terminal" })
map("n", "<leader>tf", ":ToggleTerm direction=float<cr>",       { silent = true, desc = "Float terminal" })
map("n", "<leader>th", ":ToggleTerm direction=horizontal<cr>",  { silent = true, desc = "Horizontal terminal" })

-- ── git (neogit) ──────────────────────────────────────────────────
map("n", "<leader>gg", ":Neogit<cr>", { silent = true, desc = "Open Neogit" })

-- ── zen mode ──────────────────────────────────────────────────────
map("n", "<leader>z", ":ZenMode<cr>", { silent = true, desc = "Toggle zen mode" })
