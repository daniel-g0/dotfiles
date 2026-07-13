-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  configs/lspconfig.lua  —  LSP server configurations
--
--  Servers active:
--    html         HTML language server
--    cssls        CSS / SCSS / Less
--    ts_ls        TypeScript / JavaScript
--    biome        JS/TS linter + formatter (replaces eslint)
--    ruff         Python linter (fast, Rust-based)
--    pylsp        Python LSP (completions, hover, refs)
--    clangd       C / C++
--    asm_lsp      x86 / x86_64 assembly
--    perlnavigator  Perl
--
--  Add a server: append to `servers` (default config) or add a
--  custom block below (like pylsp) for non-default settings.
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local nvchad_lsp   = require("nvchad.configs.lspconfig")
local on_attach    = nvchad_lsp.on_attach
local on_init      = nvchad_lsp.on_init
local capabilities = nvchad_lsp.capabilities

-- ── servers with default config ──────────────────────────────────
local servers = {
  "html",
  "cssls",
  "ts_ls",
  "biome",
  "ruff",
  "clangd",
  "asm_lsp",
  "perlnavigator",
}

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach    = on_attach,
    on_init      = on_init,
    capabilities = capabilities,
  })
  vim.lsp.enable(lsp)
end

-- ── pylsp — disable pycodestyle (ruff handles linting) ───────────
vim.lsp.config("pylsp", {
  on_attach    = on_attach,
  on_init      = on_init,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false },
        pylint      = { enabled = false },
      },
    },
  },
})
vim.lsp.enable("pylsp")
