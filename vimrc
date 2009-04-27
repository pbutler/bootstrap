syntax on
set ruler

set modelines=5
if $USER != 'root'
  set modeline
else
  set nomodeline
endif 

map <F6> <Esc>:setlocal nospell<CR>
map <F7> <Esc>:setlocal spell spelllang=en_us<CR> 

autocmd BufRead,BufNewFile *.tex map <F5> <Esc>:make<CR>

autocmd BufRead,BufNewFile *.py set ai
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd BufRead *.py nmap <F5> :!python %<CR>
