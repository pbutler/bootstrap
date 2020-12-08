"Vim-LaTeX crapola
" let g:tex_flavor='latex'
" let g:Tex_MultipleCompileFormats="pdf,dvi"
" let g:Tex_DefaultTargetFormat = "pdf"
" let g:Tex_ViewRule_dvi = "evince"
" let g:Tex_ViewRule_pdf = "evince"
" let g:Tex_ViewRule_ps = "evince"
" setlocal grepprg=grep\ -nH\ $*

"LaTeX
"autocmd BufNewFile *.tex set filetype=tex
"autocmd BufNewFile *.tex :0r ~/.vim/templates/python.py
"map <F5> :make<CR>
"map <Leader>pyt :0r ~/.vim/templates/latex.tex<CR>
let g:tex_comment_nospell=1

inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

setlocal spell
setlocal ts=2 sts=2 sw=2 tw=100 sta et
setlocal iskeyword+=:


