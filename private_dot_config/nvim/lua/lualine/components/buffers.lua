local utils = require 'lualine.utils.utils'
local highlight = require 'lualine.highlight'

local Buffers = require('lualine.component'):new()

Buffers.new = function(self, options, child)
  local new_instance = self._parent:new(options, child or Buffers)

  new_instance.hl = highlight.format_highlight(true, 'lualine_c')
  local fg1 = utils.extract_highlight_colors("lualine_c_normal", 'fg')
  local bg1 = utils.extract_highlight_colors("lualine_c_normal", 'bg')
  new_instance.highlight_groups = {
    sel = highlight.create_component_highlight_group(
      {fg = bg1, bg = fg1}, 'selected_buffer', new_instance.options),
    unsel = highlight.create_component_highlight_group(
      {fg = fg1, bg = bg1}, 'unselected_buffer', new_instance.options),
    sep = highlight.create_component_highlight_group(
      {fg = bg1, bg = fg1}, 'sep1_buffer', new_instance.options),
    sep2 = highlight.create_component_highlight_group(
      {fg = fg1, bg = bg1}, 'sep2_buffer', new_instance.options),
  }

  new_instance.hl2 = highlight.format_highlight(true, 'lualine_b')

  return new_instance
end


Buffers.update_status = function (self)
  local buffs = vim.fn["lightline#bufferline#buffers"]()
  local sep = ''
  local sep2 = '  '


  local colors = {}
  for name, hl in pairs(self.highlight_groups) do
    colors[name] = highlight.component_format_highlight(hl)
  end

  local ret = colors["unsel"] .. table.concat(buffs[1], sep2) .. colors["sep"] .. sep
  ret = ret .. colors["sel"] .. " " ..  table.concat(buffs[2], ', ')
  ret = ret .. colors["sep2"] ..  sep .. colors["unsel"] .. " " .. table.concat(buffs[3], sep2)

  return ret
end

return Buffers
