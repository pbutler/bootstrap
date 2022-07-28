local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')


-- local signs = {
--   { name = "DiagnosticSignError", text = " " },
--   { name = "DiagnosticSignWarn", text = " " },
--   { name = "DiagnosticSignHint", text = " " },
--   { name = "DiagnosticSignInfo", text = " " },
-- }

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
  virtual_text = true,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focus = false,
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.diagnostic.config(config)


-- keymaps
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = {noremap=true, silent=true, buffer=bufnr}
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>',     vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<space>D',  vim.lsp.buf.type_definition, opts)
  -- nuf_set_keymap('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<space>e', vim.lsp.diagnostic.show_line_diagnostics, opts)
  vim.keymap.set('n', '[d',       vim.lsp.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d',       vim.lsp.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.lsp.diagnostic.set_loclist, opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, opts)
  elseif client.resolved_capabilities.document_range_formatting then
    vim.keymap.set("n", "<space>f", vim.lsp.buf.range_formatting, opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end
  require 'illuminate'.on_attach(client)
  require 'lsp_signature'.on_attach(client)
end

require("mason-lspconfig").setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
      require("lspconfig")[server_name].setup {
        on_attach=on_attach
      }
    end,
  })

return {
  on_attach = on_attach
}
