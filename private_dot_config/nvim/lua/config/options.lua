-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
local opt = vim.opt
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

opt.clipboard = ""
opt.ruler = true
opt.signcolumn = "number"
opt.number = true
opt.completeopt = opt.completeopt - { "preview" }
opt.showmode = false
opt.showmatch = true
opt.diffopt = opt.diffopt + { "vertical" }
opt.relativenumber = false
opt.encoding = "utf-8"

vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_quickfix_mode = 0
opt.conceallevel = 1
vim.g.tex_conceal = "abdmg"

opt.hidden = true
opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.cache/nvim/undos")
vim.opt.directory = vim.fn.expand("~/.cache/nvim/tmp")
vim.opt.backupdir = vim.fn.expand("~/.cache/nvim/backup")
opt.autochdir = true

vim.g.python3_host_prog = os.getenv("HOME") .. "/.virtualenvs/neovim-py3/bin/python"

opt.backspace = { "indent", "eol", "start" }

-- Enable modelines for users but not root
opt.modelines = 5
if os.getenv("$USER") == "root" then
  opt.modeline = false
else
  opt.modeline = true
end

--  Enable or disable spell checker
opt.spelllang = "en_us"
