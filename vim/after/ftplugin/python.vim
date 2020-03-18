" Python
setlocal ai
"setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal ts=4 sts=4 sw=4 tw=88 sta et
set colorcolumn=88
"setlocal omnifunc=pythoncomplete#Complete
"setlocal completefunc=RopeCompleteFunc

"Make program compiles to check for syntax errors
"setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
"setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
"Press F5 to run
"nmap <F5> :!python %<CR>

" Check Python files with flake8 and pylint.
let b:ale_linters = ['flake8', "mypy"]
" Fix Python files with autopep8 and yapf.:
" let b:ale_fixers = ['black', 'remove_trailing_lines', 'trim_whitespace']
set nofoldenable
" nmap <buffer> <leader>rn :call jedi#rename()<cr>
" nmap <buffer> K :call jedi#show_documentation()<cr>
" nmap <buffer> gd :call jedi#goto()<cr>
