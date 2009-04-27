syntax on
set ruler

map <F5> <Esc>:setlocal nospell<CR>
map <F6> <Esc>:setlocal spell spelllang=en_us<CR> 

autocmd BufRead,BufNewFile *.py syntax on
autocmd BufRead,BufNewFile *.py set ai
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
set modeline
