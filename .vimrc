" Enable syntax hilighting
syntax on
" Enable filetype support
filetype plugin indent on


" Searching options
set incsearch
set ignorecase
set smartcase
set hlsearch
" This map makes <enter> in normal mode hide search hilights
nnoremap  <Enter>  :nohlsearch<Enter>


" Initialization of pathogen plugin
" Pathogen: https://github.com/tpope/vim-pathogen
execute pathogen#infect()


" Plugin configuration
" Syntastic:
let g:syntastic_check_on_open = 1
