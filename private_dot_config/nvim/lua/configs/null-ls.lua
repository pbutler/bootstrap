local null_ls = require('null-ls')
local lsp = require('configs.lsp')
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions

null_ls.setup {
  sources = {
    diagnostics.flake8,
    diagnostics.gitlint,
    formatting.isort,
    formatting.black,
    code_actions.gitsigns
  },
  on_attach = lsp.on_attach_no_symbols
}
