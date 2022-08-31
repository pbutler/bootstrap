local M = {}

local lualine = require("lualine")
local highlight = require('lualine.highlight')
local utils = require('lualine.utils.utils')
local navic = require("nvim-navic")

-- function! MyVirtualenv()
--   if &filetype == "python"
--     let _ = virtualenv#statusline()
--     return strlen(_) ? _ : ''
--   endif
--  return ''
-- endfunction

local wk = require('which-key')

local function set_keymaps()
  wk.register({
    b = {
      name = 'Buffers',
      ["1"] = { '<CMD>LualineBuffersJump 1<CR>', 'Switch to buffer 1' },
      ["2"] = { '<CMD>LualineBuffersJump 2<CR>', 'Switch to buffer 2' },
      ["3"] = { '<CMD>LualineBuffersJump 3<CR>', 'Switch to buffer 3' },
      ["4"] = { '<CMD>LualineBuffersJump 4<CR>', 'Switch to buffer 4' },
      ["5"] = { '<CMD>LualineBuffersJump 5<CR>', 'Switch to buffer 5' },
      ["6"] = { '<CMD>LualineBuffersJump 6<CR>', 'Switch to buffer 6' },
      ["7"] = { '<CMD>LualineBuffersJump 7<CR>', 'Switch to buffer 7' },
      ["8"] = { '<CMD>LualineBuffersJump 8<CR>', 'Switch to buffer 8' },
      ["9"] = { '<CMD>LualineBuffersJump 9<CR>', 'Switch to buffer 9' },
      ["$"] = { '<CMD>LualineBuffersJump $<CR>', 'Switch to last buffer' },
      ["d"] = { ':bd<CR>', 'Delete current buffer' },
      ["o"] = { '<CMD>BufOnly<CR>', 'Delete all other buffers' },
    },
  }, {
    prefix = '<leader>',
  })
end

 function M.diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end


function M.setup()
  lualine.setup {
    options = {
      icons_enabled = true,
      theme = 'catppuccin',
      section_separators = {left='', right=''},
      component_separators = {left='', right=''},
      disabled_filetypes = {}
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = { {'b:gitsigns_head', icon = ''}, {'diff', source = M.diff_source}, },

      lualine_c = {
        {'buffers',
          show_filename_only=false,
          mode=2
        }
      },
      lualine_x = {
        { navic.get_location, cond = navic.is_available },
        { 'diagnostics',
          sources = {'nvim_diagnostic'},
          symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '}
        },
        --     'filetype'
      },
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {'fugitive'}
  }

  set_keymaps()
end

return M
