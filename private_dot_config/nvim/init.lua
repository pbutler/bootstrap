
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- set runtimepath^=~/.vim runtimepath+=~/.vim/after

vim.opt.ruler = true
vim.opt.signcolumn = "number"
vim.opt.number = true
vim.opt.completeopt = vim.opt.completeopt - {"preview"}
vim.opt.showmode = false
vim.opt.diffopt = vim.opt.diffopt + {"vertical"}

vim.opt.encoding = "utf-8"

vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'skim'
vim.g.vimtex_quickfix_mode = 0
vim.opt.conceallevel = 1
vim.g.tex_conceal = 'abdmg'

vim.opt.hidden = true
vim.opt.laststatus = 2
vim.opt.undofile = true
vim.opt.undodir = "~/.cache/nvim/undos"
vim.opt.directory = "~/.cache/nvim/tmp"
vim.opt.backupdir = "~/.cache/nvim/backup"
vim.opt.autochdir = true


vim.g.python3_host_prog = os.getenv('HOME') .. "/.virtualenvs/neovim-py3/bin/python"

vim.opt.termguicolors = true
-- set t_8f=[38;2;%lu;%lu;%lum
-- set t_8b=[48;2;%lu;%lu;%lum

-- " vis mode inc each line n+1 where n is lineno
-- vnoremap <C-a> g<C-a>
-- vnoremap <C-x> g<C-x>
--
-- nnoremap <leader>xx <cmd>TroubleToggle<cr>
--
-- "  Templates config
-- augroup templates
--   autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/template.'.expand("<afile>:e")
-- augroup END
--
-- nnoremap <silent> <leader>mx :w<CR>:!chmod +x %<CR>l<CR>

-- " autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endi

-- Help Neovim check if file has changed on disk
-- https://github.com/neovim/neovim/issues/2127
local checktime_group = vim.api.nvim_create_augroup('checktime', { clear = true })
if vim.fn.has('gui_running') == 0 then
  vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'BufEnter', 'FocusLost', 'WinLeave' }, {
      group = checktime_group,
      pattern = '*',
      command = 'checktime',
    })
end


vim.opt.backspace = {"indent", "eol", "start"}

-- Enable modelines for users but not root
vim.opt.modelines = 5
if os.getenv("$USER") == "root" then
  vim.opt.modeline = false
else
  vim.opt.modeline = true
end

--  Enable or disable spell checker
vim.opt.spelllang = "en_us"
-- map <F6> :setlocal invspell spell?<CR>
-- map <F7> :setlocal invpaste paste?<CR>
--

require("plugins").setup()
vim.opt.rtp:append(vim.fn.expand("~/.vim/after"))

-- "wiki.vim
-- let g:wiki_root = '~/vimwiki'
-- "nnoremap <leader>wj :WikiJournalIndex<CR>
-- nmap <leader>wj <plug>(wiki-journal-index)
--
-- let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
-- let g:sandwich#recipes += [
--       \ {'buns': ['{ ', ' }'], 'nesting': 1, 'match_syntax': 1,
--       \  'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
--       \
--       \ {'buns': ['[ ', ' ]'], 'nesting': 1, 'match_syntax': 1,
--       \  'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
--       \
--       \ {'buns': ['( ', ' )'], 'nesting': 1, 'match_syntax': 1,
--       \  'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
--       \
--       \ {'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1,
--       \  'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
--       \  'action': ['delete'], 'input': ['{']},
--       \
--       \ {'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1,
--       \  'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
--       \  'action': ['delete'], 'input': ['[']},
--       \
--       \ {'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1,
--       \  'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
--       \  'action': ['delete'], 'input': ['(']},
--       \ ]
