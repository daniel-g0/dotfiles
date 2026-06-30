-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  options.lua  —  editor options (extends nvchad.options)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

require("nvchad.options")

local o = vim.o

-- ── scroll & cursor ───────────────────────────────────────────────
o.scrolloff     = 8       -- keep 8 lines context above/below cursor
o.sidescrolloff = 8
o.cursorline    = true    -- highlight current line

-- ── lines ─────────────────────────────────────────────────────────
o.relativenumber = true   -- relative line numbers
o.number         = true   -- also show absolute number on current line
o.wrap           = false  -- no soft wrap

-- ── sign column ───────────────────────────────────────────────────
o.signcolumn = "yes"      -- always show; prevents layout shift on diagnostics

-- ── search ────────────────────────────────────────────────────────
o.ignorecase = true
o.smartcase  = true       -- case-sensitive when pattern has uppercase

-- ── splits ────────────────────────────────────────────────────────
o.splitright = true       -- vsplit → new pane on right
o.splitbelow = true       -- split  → new pane below

-- ── performance ───────────────────────────────────────────────────
o.updatetime  = 500       -- CursorHold delay for LSP hover + gitsigns
o.timeoutlen  = 300       -- faster which-key popup

-- ── undo ──────────────────────────────────────────────────────────
o.undofile = true         -- persist undo history across sessions

-- ── spell ─────────────────────────────────────────────────────────
o.spell     = true
o.spelllang = "en_us"
