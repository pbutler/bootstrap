if &compatible
  set nocompatible               " Be iMproved
endif

let mapleader = ","
let g:python3_host_prog = $HOME.'/venv/neovim-py3/bin/python'
let g:python_host_prog = $HOME.'/venv/neovim-py2/bin/python'
let g:deoplete#sources#jedi#server_timeout = 20
let g:deoplete#disable_auto_complete = 0
" Required:
set runtimepath+=$HOME/.dein.vim/repos/github.com/Shougo/dein.vim
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" let g:deoplete#sources#jedi#debug_server = '/tmp/deoplete-jedi'
" Required:
if dein#load_state($HOME.'/.dein.vim')
  call dein#begin($HOME.'/.dein.vim')

  " Let dein manage dein
  " Required:
  call dein#add($HOME.'/.dein.vim/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('ervandew/supertab')
  call dein#add('Shougo/denite.nvim')
  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets.git')
  call dein#add('w0rp/ale')
  call dein#add('iCyMind/NeoSolarized')
  call dein#add('altercation/vim-colors-solarized.git')
  call dein#add('itchyny/lightline.vim')
  call dein#add('mgee/lightline-bufferline')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#add('zchee/deoplete-jedi')
  call dein#add('maximbaz/lightline-ale')
  call dein#add('jmcantrell/vim-virtualenv')
  call dein#add('scrooloose/nerdcommenter')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('majutsushi/tagbar')
  " Required:
  call dein#end()
  call dein#save_state()
endif

"nmap <F2> :TagbarToggle<CR>
let g:tagbar_left = 1
nmap <F2> :TagbarOpenAutoClose<CR>

filetype plugin indent on
syntax enable


" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif


let g:NERDSpaceDelims = 0
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

let g:bufferline_echo = 0
let g:deoplete#enable_at_startup = 1
let g:ultisnips_python_style = "sphinx"
"End dein Scripts-------------------------

"NeoBundle 'tpope/vim-fugitive'
"NeoBundle 'sjl/gundo.vim'
"NeoBundle 'scrooloose/syntastic'


""""    NeoBundle 'godlygeek/tabular'
""""    NeoBundle 'vim-scripts/taglist.vim'
""""    NeoBundle 'nathanaelkane/vim-indent-guides'
""""    NeoBundle 'vim-pandoc/vim-pandoc'
""""    NeoBundle 'LaTeX-Box-Team/LaTeX-Box'
""""    NeoBundle 'ervandew/supertab'
"
"
if has("autocmd")
    augroup templates
        autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/template.'.expand("<afile>:e")
    augroup END
endif

" let g:NERDTreeQuitOnOpen=1
" 
let mapleader=","
set hidden

" 
set undodir=$HOME/.vim/undos
set undofile
set directory=~/.vim/tmp
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
" 
" " Toggle taglist
" let s:taglist_is_on = 0
" function! ToggleTagList()
"   if s:taglist_is_on == 0
"     exe ":TlistOpen"
"     exe ":wincmd t"
"     let s:taglist_is_on = 1
"   else
"     exe ":TlistClose"
"     let s:taglist_is_on = 0
"   endif
" endfunction
" map <silent> <F1> :NERDTree<CR>
" map <silent> <F2> :exe ":call ToggleTagList()"<CR>
" 
" " This function removes trailing whitespace, a pet peeve of mine.
function! DeleteTrailingWhitespace()
  normal m`
  %s/\s\+$//e
  normal ``
endfunction
" this removes trailing extra whitespace from end of lines
autocmd BufWritePre *.py,*.pl,*.c,*.cpp,*.h,*.tex,*.sh,*.rst call DeleteTrailingWhitespace()
" This setting makes sure Vim is always operating in the directory of the current buffer
autocmd BufEnter * lcd %:p:h
" 
" 
" autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
" 
" au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endi
" Color Stuff
set termguicolors
set background=dark
let g:neosolarized_visibility = "high"
let g:neosolarized_italic = 1
if has('nvim')
  colorscheme NeoSolarized
else
  let g:solarized_termcolors=256
  colorscheme solarized
endif
" 
" 
highlight SpellBad ctermfg=127
hi SignColumn guibg=#282c34
" 
highlight SpellBad ctermfg=127
highlight SpellCap ctermfg=123
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
"inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
