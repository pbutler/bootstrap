local null_ls = require('null-ls')
local lsp = require('configs.lsp')
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

null_ls.setup {
  sources = {
    diagnostics.flake8,
    formatting.isort,
    -- formatting.black,
    -- formatting.stylua,
  },
  on_attach = lsp.on_attach
}
