local lspconfig = require("lspconfig")

-- Setup clagd for Arduino (C/C++)
lspconfig.clangd.setup {
  cmd = { "clangd" },
}
