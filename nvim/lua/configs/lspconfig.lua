-- EXAMPLE 
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "ruff", "pylsp", "clangd",
                  "perlnavigator", "asm_lsp", "biome"}-- "powershell-lsp"}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

lspconfig.pylsp.setup{
  -- ... other config options ...

  -- Disable PEP 8 warnings entirely
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = false,
        },
      },
    },
  },
}
