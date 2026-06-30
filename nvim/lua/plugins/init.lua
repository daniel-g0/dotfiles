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

  -- Cyberdream: futuristic dark colorscheme
  -- NOTE: overrides NvChad base46 (chadrc.lua theme is cosmetic only when this is active)
  {
    "scottmckendry/cyberdream.nvim",
    lazy     = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent          = true,
        italic_comments      = true,
        hide_fillchars       = " ",
        borderless_telescope = true,
        terminal_colors      = true,
        theme = {
          variant    = "default",
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
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "lua-language-server", "stylua",
        "html-lsp", "css-lsp", "prettier",
      },
    },
  },

  -- Treesitter: incremental parsing → syntax highlighting, text objects
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript", "typescript",
        "python", "c", "bash",
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


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  󰙀  UI  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  -- Lualine: statusline
  {
    "nvim-lualine/lualine.nvim",
    event        = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Barbar: tabline with git status + file icons
  -- Loads on BufAdd so the bar appears when the second buffer opens
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


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  GIT  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  -- Neogit: Magit-style git TUI — :Neogit
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",        -- side-by-side diff view
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


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  󰒡  UTILITIES  ━━━━━━━━━━━━━━━━━━━━━━━━━

  -- mistake.nvim: highlights common typos/coding mistakes
  {
    "https://github.com/ck-zhang/mistake.nvim",
    event = "VeryLazy",
  },


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  󰐂  RECOMMENDED  ━━━━━━━━━━━━━━━━━━━━━━━━━
--
--  Uncomment any block to enable. All are lazy-loaded.

  -- flash.nvim: fast jump with s/S/f/t — replaces hop/leap
  -- Pairs well with hardtime to learn real motions fast
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     { "s",     function() require("flash").jump() end,              mode = { "n", "x", "o" }, desc = "Flash jump" },
  --     { "S",     function() require("flash").treesitter() end,        mode = { "n", "x", "o" }, desc = "Flash treesitter" },
  --     { "r",     function() require("flash").remote() end,            mode = "o",               desc = "Flash remote" },
  --     { "<c-s>", function() require("flash").toggle() end,            mode = "c",               desc = "Toggle flash search" },
  --   },
  -- },

  -- oil.nvim: edit the filesystem like a buffer — much faster than nvim-tree for renames/moves
  -- {
  --   "stevearc/oil.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" } },
  --   opts = {},
  -- },

  -- todo-comments.nvim: highlight TODO/FIXME/NOTE/HACK in comments + telescope search
  -- {
  --   "folke/todo-comments.nvim",
  --   event        = "BufReadPost",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   keys = { { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Search TODOs" } },
  --   opts = {},
  -- },

  -- nvim-surround: add/change/delete surrounding pairs (ys / cs / ds)
  -- {
  --   "kylechui/nvim-surround",
  --   version = "*",
  --   event   = "VeryLazy",
  --   config  = true,
  -- },

  -- nvim-highlight-colors: show color swatches inline in CSS/HTML/Lua
  -- {
  --   "brenoprata10/nvim-highlight-colors",
  --   event = "BufReadPost",
  --   opts  = { render = "virtual", virtual_symbol = "■" },
  -- },

  -- harpoon (v2): instant bookmarks for 4-5 hot files per project — <leader>h*
  -- {
  --   "ThePrimeagen/harpoon",
  --   branch       = "harpoon2",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   keys = {
  --     { "<leader>ha", function() require("harpoon"):list():add() end,                                       desc = "Harpoon add" },
  --     { "<leader>hh", function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end,        desc = "Harpoon menu" },
  --     { "<leader>1",  function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
  --     { "<leader>2",  function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
  --     { "<leader>3",  function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
  --     { "<leader>4",  function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
  --   },
  -- },

  -- nvim-ts-autotag: auto-close and auto-rename HTML/JSX/TSX tags
  -- {
  --   "windwp/nvim-ts-autotag",
  --   event = "BufReadPost",
  --   opts  = {},
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
