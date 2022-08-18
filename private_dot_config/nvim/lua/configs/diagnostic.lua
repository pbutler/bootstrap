local M = {}



local wk = require('which-key')

local function set_commands()
  vim.cmd('command! DiagnosticPrev lua vim.diagnostic.goto_prev()')
  vim.cmd('command! DiagnosticNext lua vim.diagnostic.goto_next()')
  vim.cmd('command! DiagnosticLine lua vim.diagnostic.open_float({ source = true })')
end

local function set_keymaps()
  wk.register({
    e = {
      name = 'Diagnostic',
      l = { '<cmd>DiagnosticLine<CR>', 'show for current line' },
      n = { '<cmd>DiagnosticNext<CR>', 'jump to next' },
      p = { '<cmd>DiagnosticPrev<CR>', 'jump to previous' },
    },
  }, {
    prefix = '<leader>',
  })
  wk.register({
    E = { '<cmd>DiagnosticLine<CR>', 'show diagnostic for current line' },
  })
end

local function set_signs()
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
end


function M.setup()
  set_commands()
  set_keymaps()
  set_signs()
  vim.diagnostic.config({
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
  })
end

return M

