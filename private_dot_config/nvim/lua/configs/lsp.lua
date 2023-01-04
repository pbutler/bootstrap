require('configs.diagnostic').setup()


--
--   -- Set some keybinds conditional on server capabilities
--   if client.resolved_capabilities.document_formatting then
--     vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, opts)
--   elseif client.resolved_capabilities.document_range_formatting then
--     vim.keymap.set("n", "<space>f", vim.lsp.buf.range_formatting, opts)
--   end
--
--   -- Set autocommands conditional on server_capabilities
--   if client.resolved_capabilities.document_highlight then
--     vim.api.nvim_exec([[
--     augroup lsp_document_highlight
--     autocmd! * <buffer>
--     autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--     augroup END
--     ]], false)
--   end


local M = {}

--local lsp_format = require('lsp-format')
local nvim_lsp = require('lspconfig')
local wk = require('which-key')
local illuminate = require('illuminate')
local navic = require('nvim-navic')

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local function set_commands()
  -- Commands.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.cmd('command! LspDeclaration lua vim.lsp.buf.declaration()')
  vim.cmd('command! LspDef lua vim.lsp.buf.definition()')
  vim.cmd('command! LspFormat lua vim.lsp.buf.format()')
  vim.cmd('command! LspCodeAction lua vim.lsp.buf.code_action()')
  vim.cmd('command! LspHover lua vim.lsp.buf.hover()')
  vim.cmd('command! LspRename lua vim.lsp.buf.rename()')
  vim.cmd('command! LspOrganize lua lsp_organize_imports()')
  vim.cmd('command! LspRefs lua vim.lsp.buf.references()')
  vim.cmd('command! LspTypeDef lua vim.lsp.buf.type_definition()')
  vim.cmd('command! LspImplementation lua vim.lsp.buf.implementation()')
  vim.cmd('command! LspSignatureHelp lua vim.lsp.buf.signature_help()')
  vim.cmd('command! LspWorkspaceList lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))')
  vim.cmd('command! LspWorkspaceAdd lua vim.lsp.buf.add_workspace_folder()')
  vim.cmd('command! LspWorkspaceRemove lua vim.lsp.buf.remove_workspace_folder()')
end

local function set_keymaps(bufnr)

  -- local formatting = nil
  -- if client.resolved_capabilities.document_formatting then
  --   formatting = {"<Cmd>LspFormatting<CR>", 'format'}
  -- elseif client.resolved_capabilities.document_range_formatting then
  --   formatting = {"<Cmd>LspRangeFormatting<CR>", 'format'}
  -- end
  wk.register({
    g = {
      name = 'LSP goto',
      d = { '<cmd>Telescope lsp_definitions<CR>', 'definitions' },
      D = { '<cmd>LspTypeDef<CR>', 'type definition' },
      L = { '<cmd>LspDeclaration<CR>', 'declaration' },
      i = { '<cmd>Telescope lsp_implementations<CR>', 'implementations' },
      r = { '<cmd>Telescope lsp_references<CR>', 'references' },
    },
    c = {
      name = 'LSP code changes',
      a = { '<cmd>CodeActionMenu<CR>', 'code actions' },
      f = { '<cmd>LspFormat<CR>', 'format' },
      r = { '<cmd>LspRename<CR>', 'rename variable' },
    },
  }, {
    prefix = '<leader>',
    buffer = bufnr,
  })

  wk.register({
      c = {
        name = 'LSP code changes',
        f = {"<Cmd>LspFormat<CR>", "range format" },
      },
    }, {
      mode = 'v',
      prefix = '<leader>',
      buffer = bufnr,
    })

  wk.register({
    K = { '<cmd>LspHover<CR>', 'LSP hover' },
    ['<C-S>'] = { '<cmd>LspSignatureHelp<CR>', 'LSP signature help' },
  }, {
    buffer = bufnr,
  })
  wk.register({
    ['<C-S>'] = { '<cmd>LspSignatureHelp<CR>', 'LSP signature help' },
  }, {
    mode = 'i',
    buffer = bufnr,
  })
end

function M.on_attach(client, bufnr)
  M.on_attach_no_symbols(client, bufnr)

  if vim.b.lsp_symbol_support_loaded then
    return
  end

  illuminate.on_attach(client)
  navic.attach(client, bufnr)
  vim.b.lsp_symbol_support_loaded = 1
end

function M.on_attach_no_symbols(client, bufnr)
  --lsp_format.on_attach(client)
  if vim.b.lsp_buffer_set_up then
    return
  end

  --Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  set_commands()
  set_keymaps(bufnr)

  vim.b.lsp_buffer_set_up = 1
end

function M.setup()
  require("mason-lspconfig").setup_handlers({
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
          capabilities=M.capabilities,
          on_attach=M.on_attach
        }
      end,
    })
end

return M
