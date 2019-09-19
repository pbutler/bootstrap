if &compatible
  set nocompatible               " Be iMproved
endif

set ruler
set signcolumn=yes
set completeopt-=preview
set noshowmode
filetype plugin indent on

set encoding=utf-8
if has("pythonx")
  set pyxversion=3
endif

let mapleader=","
set hidden
set laststatus=2
set undofile
set undodir=$HOME/.vim/undos
set directory=~/.vim/tmp

let g:python3_host_prog = $HOME.'/venv/neovim-py3/bin/python'
let g:python_host_prog = $HOME.'/venv/neovim-py2/bin/python'

let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('haya14busa/dein-command.vim')

  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  " Add or remove your plugins here:
  call dein#add('iCyMind/NeoSolarized')
  call dein#add('altercation/vim-colors-solarized.git')

  call dein#add('schickling/vim-bufonly')
  call dein#add('ntpeters/vim-better-whitespace')

  call dein#add('Shougo/denite.nvim')
  " call dein#add('nixprime/cpsm', {'build': 'PY3=ON ./install.sh'})
  call dein#add('Shougo/neoyank.vim')
  call dein#add('chemzqm/unite-location')
  call dein#add('raghur/fruzzy', {'hook_post_update': 'call fruzzy#install()'})


  call dein#add('junegunn/vim-emoji')
  call dein#add('pocari/vim-denite-emoji')

  call dein#add('Shougo/deoplete.nvim')
  call dein#add('ervandew/supertab')
  call dein#add('Shougo/echodoc.vim')

  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets.git')
  call dein#add('w0rp/ale')
  call dein#add('Konfekt/FastFold')


  call dein#add('airblade/vim-gitgutter')
  call dein#add('gregsexton/gitv')

  "status bar
  call dein#add('itchyny/lightline.vim')
  call dein#add('mgee/lightline-bufferline')
  call dein#add('maximbaz/lightline-ale')

  "programming
  call dein#add('sheerun/vim-polyglot')
  call dein#add('majutsushi/tagbar')
  call dein#add('scrooloose/nerdcommenter')

  "python
  " call dein#add('python-mode/python-mode', {'on_ft': 'python'})
  call dein#add('zchee/deoplete-jedi', {'on_ft': 'python'})
  call dein#add('davidhalter/jedi-vim', {'on_ft': 'python'})
  call dein#add('jmcantrell/vim-virtualenv', {'on_ft': 'python'})
  call dein#add('tmhedberg/SimpylFold', {'on_ft': 'python'})
  call dein#add('szymonmaszke/vimpyter')

"js
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

let g:tagbar_left = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
nmap <F2> :TagbarToggle<CR>

let g:echodoc#type = 'signature'
let g:echodoc_enable_at_startup = 1

let g:NERDSpaceDelims = 0
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

let g:bufferline_echo = 0
let g:ultisnips_python_style = "sphinx"
let g:UltiSnipsExpandTrigger="<c-S>"


autocmd FileType denite-filter
      \ call deoplete#custom#buffer_option('auto_complete', v:false)

inoremap <expr> <C-G> deoplete#undo_completion()
"NeoBundle 'tpope/vim-fugitive'
"NeoBundle 'sjl/gundo.vim'


""""    NeoBundle 'godlygeek/tabular'
""""    NeoBundle 'vim-scripts/taglist.vim'
""""    NeoBundle 'vim-pandoc/vim-pandoc'
""""    NeoBundle 'LaTeX-Box-Team/LaTeX-Box'
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

if has("autocmd")
  autocmd BufEnter * EnableStripWhitespaceOnSave
endif

autocmd BufEnter * lcd %:p:h
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


autocmd Filetype ipynb nmap <silent><Leader>b :VimpyterInsertPythonBlock<CR>
autocmd Filetype ipynb nmap <silent><Leader>j :VimpyterStartJupyter<CR>
autocmd Filetype ipynb nmap <silent><Leader>n :VimpyterStartNteract<CR>

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
  let g:neosolarized_termcolors = 256
  let g:neosolarized_termtrans = 1
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
      \              [ 'linter_errors', 'linter_warnings', 'linter_checking', 'linter_ok' ]
      \            ]
      \ },
      \ 'component_expand':{
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \  'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_function': {
      \  'virtualenv': 'MyVirtualenv'
      \ },
      \ 'component_type': {
      \     'buffers': 'tabsel',
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left'
      \ }
      \}

let g:SuperTabDefaultCompletionType = "<c-n>"

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

" Denite settings
autocmd FileType denite call s:denite_my_mappings()
function! s:denite_my_mappings() abort
  nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> a
    \ denite#do_map('choose_action')
  nnoremap <silent><buffer><expr> dd
    \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> <C-l>
    \ denite#do_map('redraw')
  nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
    \ denite#do_map('toggle_select')
endfunction

"call denite#custom#source('file/rec', 'matchers', ['matcher/cpsm', 'sorter/rank'])
let g:fruzzy#usenative = 1
let g:fruzzy#sortonempty = 1 " default value

" tell denite to use this matcher by default for all sources
call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])


if executable('rg')
  call denite#custom#var('file/rec', 'command',
        \ ['rg', '--files', '--hidden', '--glob', '!.git', '--color', 'never'])
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts',
        \ ['-i', '--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
elseif executable('ag')
  call denite#custom#var('file/rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '--ignore', '.git', '-g', ''])
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'default_opts',
        \ ['-i', '--vimgrep'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

nnoremap <silent> <leader>db :<C-u>Denite buffer<CR>
nnoremap <silent> <leader>df :<C-u>Denite file/rec -start-filter<CR>
nnoremap <silent> <leader>dp :<C-u>DeniteProjectDir file/rec -start-filter<CR>
nnoremap <silent> <leader>dl :<C-u>Denite location_list<CR>
nnoremap <leader>dg :<C-u>Denite grep<CR><CR>
nnoremap <leader>dy :<C-u>Denite neoyank<CR>

