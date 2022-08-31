set runtimepath^=~/.vim runtimepath+=~/.vim/after

set ruler
set signcolumn=number
set number
set completeopt-=preview
set noshowmode
set diffopt+=vertical
filetype plugin indent on

set encoding=utf-8
if has("pythonx")
  set pyxversion=3
endif

let mapleader=","
let maplocalleader="\\"
let g:tex_flavor='latex'
let g:vimtex_view_method='skim'  "mupdf'
let g:vimtex_quickfix_mode=0
" let g:vimtex_latexmk_progname= 'nvr'
set conceallevel=1
let g:tex_conceal='abdmg'

set hidden
set laststatus=2
set undofile
set undodir=~/.cache/nvim/undos
set directory=~/.cache/nvim/tmp
set backupdir=~/.cache/nvim/backup
set autochdir


let g:python3_host_prog = $HOME.'/.virtualenvs/neovim-py3/bin/python'

set termguicolors
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
" colorscheme material

lua require('plugins')
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

syntax enable

" vis mode inc each line n+1 where n is lineno
vnoremap <C-a> g<C-a>
vnoremap <C-x> g<C-x>

nnoremap <leader>xx <cmd>TroubleToggle<cr>

inoremap <F3>  <nop>
inoremap <F4>  <nop>
inoremap <F8>  <nop>
inoremap <F9>  <nop>
inoremap <F10>  <nop>
inoremap <F11>  <nop>
inoremap <F12>  <nop>
nmap Q <nop>

" let g:echodoc#enable_at_startup = 1
" let g:echodoc#type = 'floating'

"  Templates config
augroup templates
  autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/template.'.expand("<afile>:e")
augroup END

nnoremap <silent> <leader>mx :w<CR>:!chmod +x %<CR>l<CR>

" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endi

" Help Neovim check if file has changed on disc
" https://github.com/neovim/neovim/issues/2127
augroup checktime
  autocmd!
  if !has("gui_running")
    "silent! necessary otherwise throws errors when using command
    "line window.
    autocmd BufEnter,FocusGained,BufEnter,FocusLost,WinLeave * checktime
  endif
augroup END

" let g:NERDTreeQuitOnOpen=1
"
"
" set showcmd
" set showmatch
" "set sessionoptions+=resize
"
set backspace=indent,eol,start

"
" " Enable modelines for users but not root
set modelines=5
if $USER != 'root'
   set modeline
 else
   set nomodeline
endif

"
" " Enable or disable spell checker
"
set spelllang=en_us
map <F6> :setlocal invspell spell?<CR>
map <F7> :setlocal invpaste paste?<CR>

"wiki.vim
let g:wiki_root = '~/vimwiki'
"nnoremap <leader>wj :WikiJournalIndex<CR>
nmap <leader>wj <plug>(wiki-journal-index)

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
      \ {'buns': ['{ ', ' }'], 'nesting': 1, 'match_syntax': 1,
      \  'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
      \
      \ {'buns': ['[ ', ' ]'], 'nesting': 1, 'match_syntax': 1,
      \  'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
      \
      \ {'buns': ['( ', ' )'], 'nesting': 1, 'match_syntax': 1,
      \  'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
      \
      \ {'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1,
      \  'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
      \  'action': ['delete'], 'input': ['{']},
      \
      \ {'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1,
      \  'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
      \  'action': ['delete'], 'input': ['[']},
      \
      \ {'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1,
      \  'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
      \  'action': ['delete'], 'input': ['(']},
      \ ]
