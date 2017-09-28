" Python 
setlocal ai
setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal ts=4 sts=4 sw=4 tw=100 sta et 
setlocal omnifunc=pythoncomplete#Complete
setlocal completefunc=RopeCompleteFunc

"Make program compiles to check for syntax errors
setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
"Press F5 to run
nmap <F5> :!python %<CR>

nmap <Leader>pyt :0r ~/.vim/templates/python.py<CR>
if strlen(globpath(&rtp, '$HOME/.vim/plugin/pydoc.vim'))
   source $HOME/.vim/plugin/pydoc.vim
 endif
