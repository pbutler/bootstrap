if &compatible
  set nocompatible               " Be iMproved
endif

filetype plugin indent on

set encoding=utf-8
if has("pythonx")
  set pyxversion=3
endif

let mapleader=","
set hidden

set undodir=$HOME/.vim/undos
set undofile
set directory=~/.vim/tmp

let g:python3_host_prog = $HOME.'/venv/neovim-py3/bin/python'
let g:python_host_prog = $HOME.'/venv/neovim-py2/bin/python'
let g:deoplete#sources#jedi#server_timeout = 20
let g:deoplete#disable_auto_complete = 0

let g:pymode_python = 'python3'
let g:pymode_lint = 0
let g:pymode_options = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope = 0
let g:pymode_syntax = 1
let g:pymode_options_colorcolumn = 1

set runtimepath+=~/.dein.vim/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state($HOME.'/.dein.vim')
  call dein#begin($HOME.'/.dein.vim')

  " Let dein manage dein
  " Required:
  call dein#add($HOME.'/.dein.vim/repos/github.com/Shougo/dein.vim')
  call dein#add('wsdjeg/dein-ui.vim')

  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  " Add or remove your plugins here:
  call dein#add('iCyMind/NeoSolarized')
  call dein#add('altercation/vim-colors-solarized.git')

  call dein#add('ntpeters/vim-better-whitespace')

  call dein#add('Shougo/deoplete.nvim')
  call dein#add('ervandew/supertab')
  call dein#add('Shougo/denite.nvim')

  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets.git')
  call dein#add('w0rp/ale')

  call dein#add('airblade/vim-gitgutter')
  call dein#add('gregsexton/gitv')

  call dein#add('itchyny/lightline.vim')
  call dein#add('mgee/lightline-bufferline')
  call dein#add('maximbaz/lightline-ale')

  call dein#add('sheerun/vim-polyglot')
  call dein#add('majutsushi/tagbar')
  call dein#add('scrooloose/nerdcommenter')

  call dein#add('python-mode/python-mode', {'on_ft': 'python'})
  call dein#add('zchee/deoplete-jedi', {'on_ft': 'python'})
  call dein#add('jmcantrell/vim-virtualenv', {'on_ft': 'python'})

  call dein#add('pangloss/vim-javascript', {'on_ft': 'javascript.jsx'})
  " Required:
  call dein#end()
  call dein#save_state()
endif

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------

syntax enable

set laststatus=2
let g:tagbar_left = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
nmap <F2> :TagbarToggle<CR>



let g:NERDSpaceDelims = 0
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

let g:bufferline_echo = 0
let g:deoplete#enable_at_startup = 1
let g:ultisnips_python_style = "sphinx"

"NeoBundle 'tpope/vim-fugitive'
"NeoBundle 'sjl/gundo.vim'


""""    NeoBundle 'godlygeek/tabular'
""""    NeoBundle 'vim-scripts/taglist.vim'
""""    NeoBundle 'nathanaelkane/vim-indent-guides'
""""    NeoBundle 'vim-pandoc/vim-pandoc'
""""    NeoBundle 'LaTeX-Box-Team/LaTeX-Box'
""""    NeoBundle 'ervandew/supertab'
"
"
"
if has("autocmd")
    augroup templates
        autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/template.'.expand("<afile>:e")
    augroup END
endif

" vim-better-whitespace configuration
nnoremap <silent> <leader>rws :ToggleStripWhitespaceOnSave<CR>
nnoremap <silent> <leader>hws :ToggleWhitespace<CR>

if has("autocmd")
  autocmd BufEnter * EnableStripWhitespaceOnSave
endif

autocmd BufEnter * lcd %:p:h
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endi


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

" Color Stuff
set t_Co=256
set termguicolors
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set background=dark

"if has('nvim')
  let g:neosolarized_visibility = "high"
  let g:neosolarized_termcolors=256
  let g:neosolarized_termtrans=1
  let g:neosolarized_italic = 1
  colorscheme NeoSolarized
"else
"  let g:solarized_termtrans=1
"  let g:solarized_visibility = "high"
"  let g:solarized_termcolors=256
"  colorscheme solarized
"endif
" "
" highlight SignColumn guibg=#282c34
" highlight SpellBad ctermfg=127
" highlight SpellCap ctermfg=123
"
" noremap   <Up>     <NOP>
" noremap   <Down>   <NOP>
" noremap   <Left>   <NOP>
" noremap   <Right>  <NOP>

"

function! MyVirtualenv()
  if &filetype == "python"
    let _ = virtualenv#statusline()
    return strlen(_) ? _ : ''
  endif
 return ''
endfunction


set ruler
let g:lightline#bufferline#show_number = 1
let g:lightline#bufferline#modified = "+"
let g:lightline#bufferline#unnamed = '[No Name]'
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [
      \              [ 'mode', 'paste' ],
      \              [ 'gitbranch', 'virtualenv' ],
      \              [ 'buffers' ]
      \            ],
      \   'right': [
      \              [ 'percent' ],
      \              [ 'lineinfo' ],
      \              [ 'linter_errors', 'linter_warnings', 'linter_ok' ]
      \            ]
      \ },
      \ 'component_expand':{
      \    'buffers': 'lightline#bufferline#buffers',
      \    'linter_warnings': 'lightline#ale#warnings',
      \    'linter_errors': 'lightline#ale#errors',
      \    'linter_ok': 'lightline#ale#ok',
      \    'virtualenv': 'MyVirtualenv'
      \ },
      \ 'component_type': {
      \     'buffers': 'tabsel',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }
      \}

let g:SuperTabDefaultCompletionType = "<c-n>"
