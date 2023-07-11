local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local clangd_sdk_path = "/opt/sdk/camo/2.3.0.0/environment-setup-goldmont-camo-linux"  -- specify the path to your sdk

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver" }  -- remove clangd from the list

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- setup clangd separately
lspconfig.clangd.setup {
  cmd = { "clangd", "--clang-tidy", "--compile-commands-dir=" .. clangd_sdk_path },
  on_attach = on_attach,
  capabilities = capabilities,
}

-- lspconfig.pyright.setup { blabla}
