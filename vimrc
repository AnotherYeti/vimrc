set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'sheerun/vim-wombat-scheme'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-dispatch'
Plug 'Omnisharp/omnisharp-vim'
Plug 'scrooloose/syntastic'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf.vim'
Plug '/usr/local/opt/fzf'
call plug#end()

filetype plugin indent on    " required

"colorscheme settings
syntax enable
colorscheme dracula
set background=dark

"leader is comma
let mapleader = ","

"gui things
set guifont=FuraCode\ Nerd\ Font:h12
"removes scrollbars on macvim
set guioptions=

"font nonsense
set encoding=utf-8
set fileencoding=utf-8

"keep performance OK
let g:airline_extensions=[]

"put .cs in the sort sequence
let g:netrw_sort_sequence="[\/]$,\<core\%(\.\d\+\)\=\>,\.h$,\.c$,\.cs$,\.cpp$,\~\=\*$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$"
let g:netrw_list_hide=".*\.meta,.*\.swp"

"syntastic checkers
"let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
let g:OmniSharp_server_type = 'roslyn'
let g:OmniSharp_server_stdio = 1
let g:syntastic_cs_checkers = ['code_checker']
let g:OmniSharp_selector_ui = 'fzf'
"don't complain about lacking underscores
let g:syntastic_quiet_messages = { 
  \ "regex": ["Redundant", "'_'", "IComparable"]
  \ }

"don't show current mode, that's in our status bar
set noshowmode

"some lightline config
let g:lightline = {
  \ 'separator': { 'left': 'î°', 'right': 'î¶' },
  \ 'subseparator': { 'left': '', 'right': '|' },
  \ 'colorscheme': 'dracula',
  \ 'active': {
  \   'left': [['filename', 'modified'],['gitbranch'], ['typeinfo']],
  \   'right':[[ 'lineinfo' ], [ 'readonly' ] ]
  \ },
  \ 'inactive': {
  \   'left': [ ['filename', 'modified' ] ],
  \   'right':[ [ 'lineinfo' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'LightLineBranch',
  \   'typeinfo': 'TypeInfo'
  \ },
  \ 'component' : {
  \   'lineinfo': 'î¡%3l:%-2v'
  \ }
  \ }

let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c "

" inject macros
" lower case takes the current variable definition line, and puts it into
" the inject function
" upper case makes a new inject function with tthe variable
function AddZenject()
  let @0 = 'yygg/Inject]/{kp==$xk$a,/{"0pdW$bithis.$xa = bhyb$pa;=='
  normal @0
endfunction

function CreateZenject()
  let @0 = 'o[Zenject.Inject]public void Inject() [�kb{}kkkkk^yyjjjp==$xyyjopkdd=dExi=�kbathis.lyw$a = pa;==kkkkkk'
  normal @0
endfunction

" test setup macro
" takes the current line with some test name,
" and sets up a dummy test on it, and goes to the next line
let @t = '^ko[Test]j^ipublic avoid $a()ü [kb{}kothrow new System.NotImplementedException();jjI'

" comment title macro
" takes the current line with some commant, and  puts quotes around it
let @c = '^ikA///kb=======bllywppppyyjpk^i//   kb'

" query build macro
" builds a query
" and sets up a dummy test on it, and goes to the next line
let @q = 'oqueryname = GetEntityQuery(new EntityQueryDesc {});koAll = new [ ]kbkb kb] {{kb},None = new[kb [] {}kkkko	ComponentType.ReadOnly<T>()yyjjpjddkwwwjkkkkkk^'



function! LightLineBranch() abort
  let head = fugitive#head()
  return head ==# '' ? '' : 'î  ' . head
endfunction

function! UpdateTypeInfo() abort
  let opts = {'Callback': 1}
  call OmniSharp#stdio#TypeLookup(0, function('TypeInfoCallback', [opts]))
endfunction

let b:currentTypeLine = ""
function! TypeInfo() abort
  if exists('b:currentTypeLine')
    return b:currentTypeLine
  else
    let b:currentTypeLine = ""
    return b:currentTypeLine
  endif
endfunction

function! TypeInfoCallback(opts, response) abort
  let b:currentTypeLine = a:response.type
  call lightline#update()
endfunction

"omnisharp stuff
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

"folding settings
set foldmethod=syntax
set foldenable

"indent settings
set smartindent
set autoindent
set smarttab

"expand tabs
set expandtab
set tabstop=2
set shiftwidth=2

"don't beep at me
set visualbell
set ignorecase
set smartcase

"autocopmlete settings
set completeopt=longest,menuone,preview
set previewheight=5

"explore on spacebar
nnoremap <leader><space> :Files<cr>
nnoremap <leader>s :BLines<cr>
nnoremap <leader>S :Lines<cr>

"boo files are python
au BufNewFile,BufRead *.boo set filetype=python

"Some window management
nnoremap <leader>l <c-w>l
nnoremap <leader>j <c-w>h
nnoremap <leader>v <c-w>v<c-w>l
nnoremap <leader>q :q<cr>
nnoremap <c-s> :w<cr>

"Easymotion
map <Leader>/ <Plug>(easymotion-sn)
map  <Leader>w <Plug>(easymotion-bd-w)
map  <Leader>a <Plug>(easymotion-bd-jk)

"macro functions
nnoremap <leader>mZ :call CreateZenject()<cr>
nnoremap <leader>mz :call AddZenject()<cr>

"omni/error lookups
autocmd CursorMoved *.cs call UpdateTypeInfo()
nnoremap <leader>f :cnext<cr>
nnoremap <leader>d :cprevious<cr>
nnoremap <leader>gd :OmniSharpGotoDefinition<cr>
nnoremap <leader>gw :Ggrep <cword> Assets/Scripts<cr>
nnoremap <Leader>go :OmniSharpDocumentation<CR>
nnoremap <Leader>gr :OmniSharpRename<CR>
nnoremap <Leader>ga :OmniSharpGetCodeActions<CR>
nnoremap <Leader>gf :OmniSharpFixUsings<CR>
nnoremap <Leader>gu :OmniSharpFindUsages<CR>
nnoremap <Leader>gi :OmniSharpFindImplementations<CR>
nnoremap <Leader>gz <c-w>z:cclose<cr>
inoremap <c-o> <c-x><c-o>

"git
nnoremap <leader>z :Gstatus<cr>
nnoremap <leader>Z :Gcommit<cr>
nnoremap <leader>c :GitGutterToggle<cr>
nnoremap <leader>n :GitGutterNextHunk<cr>
nnoremap <leader>b :GitGutterPrevHunk<cr>

nnoremap <leader>= :Tabularize /=<cr>

"per-project vim files
set exrc
set secure
