let g:bufstat_prevent_mappings=1

let mapleader=","
set anti gfn=Monaco:h10

set laststatus=2
let &l:statusline="%-10((%l,%c)%)\ %P"
let ropevim_vim_completion=1
let ropevim_extended_complete=1
let ropevim_guess_project=0
let g:ultisnips_python_style = "sphinx"

if !has("python")
  " Trick pyflakes into not running
  let b:did_python_init = 0
  let did_UltiSnips_vim = 1
endif

call pathogen#infect()
syntax on
set ruler

set undodir=$HOME/.vim/undos
set undofile
set directory=~/.vim/tmp

set showcmd
set showmatch
"set sessionoptions+=resize

set backspace=indent,eol,start

" Enable modelines for users but not root
set modelines=5
if $USER != 'root'
  set modeline
else
  set nomodeline
endif 

" Enable or disable spell checker

set spelllang=en_us
map <F6> :setlocal invspell spell?<CR>
map <F7> :setlocal invpaste paste?<CR>

" Toggle taglist
let s:taglist_is_on = 0
function! ToggleTagList()
  if s:taglist_is_on == 0
    exe ":TlistOpen"
    exe ":wincmd t"
    let s:taglist_is_on = 1
  else
    exe ":TlistClose"
    let s:taglist_is_on = 0
  endif
endfunction
map <silent> <F2> :exe ":call ToggleTagList()"<CR>

" This function removes trailing whitespace, a pet peeve of mine.
function! DeleteTrailingWhitespace()
  normal m`
  %s/\s\+$//e
  normal ``
endfunction


if has("autocmd")
  filetype plugin indent on 

  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
  " This setting makes sure Vim is always operating in the directory of
  " " the current buffer
  autocmd BufEnter * lcd %:p:h
  autocmd BufNewFile *.py :0r ~/.vim/templates/python.py
  " this removes trailing extra whitespace from end of lines
  autocmd BufWritePre *.py,*.pl,*.c,*.cpp,*.h,*.tex,*.sh,*.rst call DeleteTrailingWhitespace()

  au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

    autocmd FileType *
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-p>") |
    \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
    \ endif
endif

" Uncomment below to get a dark background.
set background=dark

if &term =~ "xterm-256color"
  set t_Co=256
"  set t_AB=^[[48;5;%dm
"  set t_AF=^[[38;5;%dm
" Choose my favorite color scheme
  if strlen(globpath(&rtp, 'colors/molokai.vim'))
    colorscheme molokai
  "molokai
  endif
endif

if has("gui_running") 
  if strlen(globpath(&rtp, 'colors/molokai.vim'))
    colorscheme molokai
  endif
  set mousemodel=popup
  set mouse=a
endif

noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>


"let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

