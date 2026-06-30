-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  plugins/init.lua  —  lazy.nvim plugin specs
--
--  Sections:
--    󰏘  Colorscheme
--    󰒓  Language & LSP
--    󰙀  UI
--     Git
--    󰌕  Editor Behavior
--    󰒙  Diagnostics & Navigation
--    󰒡  Utilities
--    󰐂  Recommended (commented out — uncomment to enable)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

return {

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  󰏘  COLORSCHEME  ━━━━━━━━━━━━━━━━━━━━━━━━━

  -- Tokyo Night: canonical dark colorscheme — consistent with system-wide theme
  -- NOTE: overrides NvChad base46 (chadrc.lua theme is cosmetic only when this is active)
  {
    "folke/tokyonight.nvim",
    lazy     = false,
    priority = 1000,
    opts = {
      style           = "night",
      transparent     = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats   = "dark",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")
    end,
  },


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  󰒓  LANGUAGE & LSP  ━━━━━━━━━━━━━━━━━━━━━━━

  -- nvim-lspconfig: configure and launch language servers
  -- Servers defined in lua/configs/lspconfig.lua
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require("configs.lspconfig")
    end,
  },

  -- Mason: install/manage LSP servers, linters, formatters
  -- lua-language-server installed via NixOS (Mason can't install binaries on NixOS)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "stylua",
        "html-lsp", "css-lsp", "prettier",
      },
    },
  },

  -- Treesitter: incremental parsing → syntax highlighting, text objects
  -- build = ":TSUpdate" keeps parsers in sync with binary (fixes nil range errors)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript", "typescript",
        "python", "c", "bash",
        "markdown", "markdown_inline",
      },
    },
  },

  -- Conform: formatter runner
  -- Format-on-save: uncomment format_on_save in lua/configs/conform.lua
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("configs.conform")
    end,
  },

  -- Fidget: LSP progress spinner bottom-right — disappears when done
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts  = { notification = { window = { winblend = 0 } } },
  },


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  󰙀  UI  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  -- Lualine: statusline with Tokyo Night theme + powerline separators
  {
    "nvim-lualine/lualine.nvim",
    event        = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                = "tokyonight",
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
        globalstatus         = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Barbar: tabline with git status + file icons
  {
    "romgrk/barbar.nvim",
    event = "BufAdd",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init    = function() vim.g.barbar_auto_setup = false end,
    opts    = {},
    version = "^1.0.0",
  },

  -- Dashboard: startup screen
  {
    "nvimdev/dashboard-nvim",
    event        = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({})
    end,
  },

  -- indent-blankline: indent guides with scope highlight
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    main  = "ibl",
    opts  = {
      indent = { char = "│" },
      scope  = { enabled = true },
    },
  },

  -- nvim-highlight-colors: inline color swatches in CSS/HTML/Lua
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPost",
    opts  = { render = "virtual", virtual_symbol = "■" },
  },

  -- rainbow-delimiters: brackets colored by nesting depth
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
  },

  -- dressing.nvim: replaces all vim.ui.select/input with telescope-style pickers
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- mini.animate: smooth cursor movement + window open/close/resize animations
  -- scroll disabled — conflicts with centered C-d/C-u mappings
  {
    "echasnovski/mini.animate",
    version = "*",
    event   = "VeryLazy",
    opts    = { scroll = { enable = false } },
  },


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  GIT  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  -- Gitsigns: hunk signs in gutter + blame + hunk navigation
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(buf)
        local gs  = package.loaded.gitsigns
        local map = function(m, l, r, desc)
          vim.keymap.set(m, l, r, { buffer = buf, desc = desc })
        end
        map("n", "]h",          gs.next_hunk,                   "Next hunk")
        map("n", "[h",          gs.prev_hunk,                   "Prev hunk")
        map("n", "<leader>gb",  gs.toggle_current_line_blame,   "Toggle git blame")
        map("n", "<leader>gp",  gs.preview_hunk,                "Preview hunk")
        map("n", "<leader>gr",  gs.reset_hunk,                  "Reset hunk")
        map("n", "<leader>gs",  gs.stage_hunk,                  "Stage hunk")
      end,
    },
  },

  -- Neogit: Magit-style git TUI — :Neogit
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
    },
    config = true,
  },


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━  󰌕  EDITOR BEHAVIOR  ━━━━━━━━━━━━━━━━━━━━━━━

  -- Hardtime: enforces good vim motion habits — breaks arrow keys / hjkl spam
  {
    "m4xshen/hardtime.nvim",
    event        = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts         = {},
  },

  -- flash.nvim: fast jump with s/S — pairs well with hardtime
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s",     function() require("flash").jump() end,       mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S",     function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash treesitter" },
      { "r",     function() require("flash").remote() end,     mode = "o",               desc = "Flash remote" },
      { "<c-s>", function() require("flash").toggle() end,     mode = "c",               desc = "Toggle flash search" },
    },
  },

  -- nvim-autopairs: auto-close ()[]{}""'' in insert mode
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = true,
  },

  -- nvim-ts-autotag: auto-close and auto-rename HTML/JSX/TSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPost",
    opts  = {},
  },

  -- f-string-toggle: toggle Python f-strings with <leader>f
  {
    "roobert/f-string-toggle.nvim",
    keys = { { "<leader>f", desc = "Toggle f-string" } },
    config = function()
      require("f-string-toggle").setup({
        key_binding      = "<leader>f",
        key_binding_desc = "Toggle f-string",
      })
    end,
  },

  -- Toggleterm: persistent terminal windows — :ToggleTerm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd     = "ToggleTerm",
    config  = true,
  },

  -- Zen-mode: distraction-free writing at 75% width — :ZenMode
  {
    "folke/zen-mode.nvim",
    cmd  = "ZenMode",
    opts = { window = { width = 0.75 } },
  },

  -- nvim-surround: add/change/delete surrounding pairs (ys / cs / ds)
  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "VeryLazy",
    config  = true,
  },


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━  󰒙  DIAGNOSTICS & NAVIGATION  ━━━━━━━━━━━━━━━━

  -- Trouble: pretty diagnostics, references, quickfix, LSP results
  {
    "folke/trouble.nvim",
    branch = "dev",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",      desc = "Symbols" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP info" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix list" },
    },
    opts = {},
  },

  -- todo-comments: highlight TODO/FIXME/NOTE/HACK in comments + telescope search
  {
    "folke/todo-comments.nvim",
    event        = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Search TODOs" } },
    opts = {},
  },


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  󰒡  UTILITIES  ━━━━━━━━━━━━━━━━━━━━━━━━━

  -- mistake.nvim: highlights common typos/coding mistakes
  {
    "https://github.com/ck-zhang/mistake.nvim",
    event = "VeryLazy",
  },

  -- vim-illuminate: highlight all occurrences of word under cursor
  -- providers: skip treesitter (nil node bug in locals.lua), use lsp + regex
  {
    "RRethy/vim-illuminate",
    event  = "BufReadPost",
    opts   = {
      providers         = { "lsp", "regex" },
      delay             = 200,
      large_file_cutoff = 2000,
    },
    config = function(_, opts) require("illuminate").configure(opts) end,
  },

  -- render-markdown: beautiful in-buffer markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft           = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading = { sign = false },
      code    = { sign = false },
    },
  },

  -- cellular-automaton: :CellularAutomaton make_it_rain / game_of_life
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
  },

  -- precognition: ghost-text showing available motions on current line
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts  = { startVisible = true },
  },

  -- duck: hatch a walking animal on screen — :lua require("duck").hatch()
  -- animals: "🦆" (default), "🐈", "🐎", "🦀", "🐤", "🦖"
  {
    "tamton-aquib/duck.nvim",
    cmd = "DuckHatch",
    config = function()
      vim.api.nvim_create_user_command("DuckHatch", function()
        require("duck").hatch()
      end, {})
      vim.api.nvim_create_user_command("DuckCook", function()
        require("duck").cook()
      end, {})
    end,
  },


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  󰐂  RECOMMENDED  ━━━━━━━━━━━━━━━━━━━━━━━━━
--
--  Uncomment any block to enable. All are lazy-loaded.

  -- oil.nvim: edit the filesystem like a buffer — much faster than nvim-tree for renames/moves
  -- {
  --   "stevearc/oil.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" } },
  --   opts = {},
  -- },

  -- harpoon (v2): instant bookmarks for 4-5 hot files per project — <leader>h*
  -- {
  --   "ThePrimeagen/harpoon",
  --   branch       = "harpoon2",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   keys = {
  --     { "<leader>ha", function() require("harpoon"):list():add() end,                                desc = "Harpoon add" },
  --     { "<leader>hh", function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end, desc = "Harpoon menu" },
  --     { "<leader>1",  function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
  --     { "<leader>2",  function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
  --     { "<leader>3",  function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
  --     { "<leader>4",  function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
  --   },
  -- },

  -- nvim-dap + dap-ui: debugger (works with clangd/pylsp for C/Python)
  -- {
  --   "mfussenegger/nvim-dap",
  --   keys = {
  --     { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP breakpoint" },
  --     { "<leader>dc", function() require("dap").continue() end,          desc = "DAP continue" },
  --     { "<leader>di", function() require("dap").step_into() end,         desc = "DAP step into" },
  --     { "<leader>do", function() require("dap").step_over() end,         desc = "DAP step over" },
  --   },
  -- },
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  --   keys = { { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI" } },
  --   config = true,
  -- },

}
