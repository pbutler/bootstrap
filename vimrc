syntax on
set ruler

set showcmd
set showmatch
set sessionoptions+=resize

set mousemodel=popup

" Enable modelines for users but not root
set modelines=5
if $USER != 'root'
  set modeline
else
  set nomodeline
endif 

"Enable or disable spell checker
map <F6> <Esc>:setlocal nospell<CR>
map <F7> <Esc>:setlocal spell spelllang=en_us<CR> 

" This function removes trailing whitespace, a pet peeve of mine.
function! DeleteTrailingWhitespace()
  normal m`
  %s/\s\+$//e
  normal ``
endfunction


if has("autocmd")
  filetype plugin indent on 

  "LaTeX
  autocmd BufNewFile *.tex set filetype=tex
  autocmd BufNewFile *.tex :0r ~/.vim/templates/python.py
  autocmd FileType tex map <F5> <Esc>:make<CR>
  autocmd FileType tex nmap <Leader>pyt :0r ~/.vim/templates/latex.tex<CR>
   

  " Python 
  autocmd FileType python setlocal ai
  autocmd FileType python setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType python setlocal ts=4 sts=4 sw=4 tw=80 sta et 

  "Make program compiles to check for syntax errors
  autocmd FileType python setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
  autocmd FileType python setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
  "Press F5 to run
  autocmd FileType python nmap <F5> :!python %<CR>

  autocmd BufNewFile *.py :0r ~/.vim/templates/python.py
  autocmd FileType python nmap <Leader>pyt :0r ~/.vim/templates/python.py<CR>
  autocmd FileType python nmap <Leader>pym <insert># -*- coding: UTF-8 -*-<CR># vim: ts=4 sts=4 sw=4 tw=80 sta et<CR><ESC>
  if strlen(globpath(&rtp, '$HOME/.vim/plugin/pydoc.vim'))
    autocmd FileType python source $HOME/.vim/plugin/pydoc.vim
  endif


  "C/C++
  autocmd FileType c,cpp setlocal ts=8 sts=8 sw=8 noet

  " this removes trailing extra whitespace from end of lines
  autocmd BufWritePre *.py,*.pl,*.c,*.cpp,*.h,*.tex,*.sh,*.rst call DeleteTrailingWhitespace()

endif

if &term =~ "xterm-256color"
  set t_Co=256
  colorscheme inkpot
"  set t_AB=^[[48;5;%dm
"  set t_AF=^[[38;5;%dm
" Choose my favorite color scheme
if strlen(globpath(&rtp, 'colors/inkpot.vim'))
    colorscheme inkpot
endif
endif


" Uncomment below to get a dark background.
" set background=dark

