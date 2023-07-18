local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local servers = { "html", "cssls", "tsserver", "clangd" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Custom configuration for pylsp
lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      configurationSources = { "pycodestyle" }, -- pycodestyle will read from setup.cfg
      plugins = {
        pycodestyle = {
          enabled = true,
          ignore = {'E501'},  -- Empty list to ignore nothing, will pull from setup.cfg
        },
      },
    },
  },
}

-- lspconfig.pyright.setup { blabla}

