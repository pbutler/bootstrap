local lualine = require("lualine")
local highlight = require('lualine.highlight')
local utils = require('lualine.utils.utils')
local gps = require("nvim-gps")

-- function! MyVirtualenv()
--   if &filetype == "python"
--     let _ = virtualenv#statusline()
--     return strlen(_) ? _ : ''
--   endif
--  return ''
-- endfunction

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

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
    lualine_b = { {'b:gitsigns_head', icon = ''}, {'diff', source = diff_source}, },

    lualine_c = {
      {'buffers',
        show_filename_only=false,
        mode=2
      }
    },
    lualine_x = {
      { gps.get_location, condition = gps.is_available },
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
