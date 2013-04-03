" Enable syntax hilighting
syntax on
" Enable filetype support
filetype plugin indent on


" leader for future maps
let mapleader = ','


" Searching options
set incsearch
set ignorecase
set smartcase
set hlsearch
" This map makes <enter> in normal mode hide search hilights
nnoremap  <Enter>  :nohlsearch<Enter>

" Various settings
set number
set cursorline
set cursorcolumn
set laststatus=2

" tab/spaces
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab

" Virtually all terminals now are 256-color enabled, but it's common to have
" wrong TERM set, for various reasons.
set t_Co=256

" We should be using UTF-8 always
set encoding=utf-8


" Initialization of pathogen plugin
" Pathogen: https://github.com/tpope/vim-pathogen
execute pathogen#infect()


" Plugin configuration
" Syntastic:
let g:syntastic_check_on_open = 1

" NERD-Tree:
nmap <F3> :NERDTreeToggle<Enter>

" NERD-Commenter:
let NERDSpaceDelims = 1
let NERDMenuMode = 0
" <esc>c is generated on konsole with left-alt + c
nnoremap <esc>c :call NERDComment("n", "toggle")<cr>j
vnoremap <esc>c :call NERDComment("v", "toggle")<cr>

" template
" Move cursor to position marked with <+CURSOR+>, removing the marker
autocmd User plugin-template-loaded
            \    if search('<+CURSOR+>')
            \  |   execute 'normal! "_da>'
            \  | endif

" tagbar
nmap <F8> :TagbarToggle<Enter>

" Color schema
colorscheme depesz
