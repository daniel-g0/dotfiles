return {
  -- Formatter — configure formatters in lua/configs/conform.lua
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment to format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- LSP configs — configure servers in lua/configs/lspconfig.lua
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  -- Mason — auto-install LSP servers, linters, formatters
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server", "stylua",
        "html-lsp", "css-lsp", "prettier",
      },
    },
  },

  -- Treesitter — syntax highlighting and parsing
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css",
      },
    },
  },

  -- Lualine statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Cyberdream colorscheme (active, loaded eagerly at max priority)
  {
    "scottmckendry/cyberdream.nvim",
    lazy     = false,
    priority = 1000,
  },

  -- Toggleterm — persistent floating/split terminal windows
  { 'akinsho/toggleterm.nvim', version = "*", config = true },

  -- Zen mode — distraction-free writing at 75% editor width
  {
    "folke/zen-mode.nvim",
    opts = {},
  },

  -- LeetCode (disabled — uncomment opts and init.lua setup to enable)
  -- {
  --   "kawre/leetcode.nvim",
  --   build = ":TSUpdate html",
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   opts = {},
  -- },

  -- Tabnine AI completion (disabled)
  -- { 'codota/tabnine-nvim', build = "./dl_binaries.sh" },

  -- Neogit — Magit-style git interface inside Neovim
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",        -- diff integration
      "nvim-telescope/telescope.nvim", -- only one of telescope/fzf needed
      "ibhagwan/fzf-lua",
    },
    config = true,
  },

  -- Toggle Python f-strings with <leader>f
  {
    "roobert/f-string-toggle.nvim",
    config = function()
      require("f-string-toggle").setup({
        key_binding      = "<leader>f",
        key_binding_desc = "Toggle f-string",
      })
    end,
  },

  -- Dashboard — startup screen
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {}
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Hardtime — enforces good vim motion habits
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Barbar — tab bar with git status and file icons
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init    = function() vim.g.barbar_auto_setup = false end,
    opts    = {},
    version = '^1.0.0',
  },

  -- Trouble — pretty diagnostics, references, quickfix list
  {
    "folke/trouble.nvim",
    branch = "dev",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ...",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = {},
  },

  -- mistake.nvim — highlights common writing/coding mistakes
  {
    "https://github.com/ck-zhang/mistake.nvim",
  },
}
