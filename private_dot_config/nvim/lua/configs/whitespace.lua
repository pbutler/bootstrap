local M = {}

local wk = require('which-key')

local function set_keymaps()
  wk.register({
    W = {
      name = 'White Space',
      s = { '<CMD>StripWhitespace<CR>', 'strip all white space now' },
      S = { '<CMD>StripWhitespaceOnChangedLines<CR>',
            'strip all white space now (changed lines)' },
      t = { '<CMD>ToggleWhitespace<CR>', "Toggle White space visuals" },
      T = { '<CMD>ToggleStripWhitespaceOnSave<CR>', "Toggle White space removal"},

    },
  }, {
    prefix = '<leader>',
  })
end

function M.setup()
  vim.g.strip_whitespace_on_save = 1
  vim.g.better_whitespace_enabled = 1
  set_keymaps()
end

return M
