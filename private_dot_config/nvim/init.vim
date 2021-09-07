set runtimepath^=~/.vim runtimepath+=~/.vim/after

set ruler
set signcolumn=yes:2
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

lua require('plugins')
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

syntax enable


nnoremap <leader>xx <cmd>LspTroubleToggle<cr>

"doge settings
let g:doge_mapping = '<Leader>dd'
let g:doge_doc_standard_python = 'sphinx'


" tab-completion
" inoremap <silent><expr> <Tab>
"       \ pumvisible() ? "\<C-N>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"

inoremap <F3>  <nop>
inoremap <F4>  <nop>
inoremap <F8>  <nop>
inoremap <F9>  <nop>
inoremap <F10>  <nop>
inoremap <F11>  <nop>
inoremap <F12>  <nop>
nmap Q <nop>
let g:tagbar_left = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
nmap <F2> :TagbarToggle<CR>

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'

" ultisnips
let g:ultisnips_python_style = "sphinx"
let g:UltiSnipsExpandTrigger="<c-S>"


"
"
"  Templates config
if has("autocmd")
    augroup templates
        autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/template.'.expand("<afile>:e")
    augroup END
endif

nnoremap <silent> <leader>mx :w<CR>:!chmod +x %<CR>l<CR>
" vim-better-whitespace configuration
nnoremap <silent> <leader>rws :ToggleStripWhitespaceOnSave<CR>
nnoremap <silent> <leader>hws :ToggleWhitespace<CR>

autocmd BufEnter * EnableStripWhitespaceOnSave

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

" Color Stuff
" set t_Co=256
set termguicolors
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set background=dark

let g:solarized_italics = 0
let g:solarized_termtrans = 1
let g:solarized_visibility = "high"
let g:neosolarized_visibility = "high"
let g:neosolarized_termcolors = 256
let g:neosolarized_termtrans = 1
let g:neosolarized_italic = 0

colorscheme material

autocmd BufWritePost * call defx#redraw()
nnoremap <silent><leader>fl :Defx -split=vertical -winwidth=50 -direction=topleft<CR>
nnoremap <silent><leader>ft :Defx -toggle -resume -split=vertical -winwidth=50 -direction=topleft<CR>
nnoremap <silent><leader>fc :Defx -resume -split=vertical -winwidth=50 -direction=topleft -search=`expand('%:p')` `getcwd()`<CR>
call defx#custom#option('_', {
      \ 'columns': 'indent:icons:filename:type:git',
      \ })
autocmd FileType defx call s:defx_my_settings()

function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
        \ defx#is_directory() ?
        \ defx#do_action('open_tree', 'toggle') :
        \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
        \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
        \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('preview')
  nnoremap <silent><buffer><expr> o
        \ defx#do_action('open_tree', 'toggle')
  nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> S
        \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
        \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
        \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
        \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
endfunction


" lightline-ale configuration
function! LightlineFugitive()
  try
    if expand('%:t') !~? 'denite\|Tagbar\|NERD' && exists('*FugitiveHead')
      let mark = ' '  " edit here for cool mark
      let branch = FugitiveHead()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

nnoremap <leader>fg :Telescope live_grep prompt_prefix=🔍<cr>


"wiki.vim
let g:wiki_root = '~/vimwiki'
"nnoremap <leader>wj :WikiJournalIndex<CR>
nmap <leader>wj <plug>(wiki-journal-index)

" Terraform settings
let g:terraform_align=1
let g:terraform_fold_sections=0

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

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
