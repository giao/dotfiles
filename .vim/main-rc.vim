if has('gui_running')
    set guioptions+=M
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions+=e
endif

syntax on

filetype plugin indent on

" Virtually all terminals now are 256-color enabled, but it's common to have
" wrong TERM set, for various reasons.
set t_Co=256

function! ToggleOption (option)
    execute 'setlocal ' . a:option . '!'
    execute 'echo "' . a:option . ':" strpart("offon",3*&' . a:option .  ',3)' 
endfunction

function! Use_Filetype_Based_Dictionary()
    if exists('b:current_syntax')
        set complete-=k complete+=k 
        let &dictionary = '~/.vim/dict/' . b:current_syntax . '.dict'
    endif 
endfunction

function! Insert_Tab_Wrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-n>"
    endif
endfunction

if exists('&autochdir')
    set autochdir
endif

set autoindent
set background=dark
set backspace=indent,eol,start
set cindent
set cpoptions=aABceFsmq
set directory=~/.vim/swap
set encoding=utf-8
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list
set listchars=tab:»·,trail:·
set mouse=
set nobackup
set nocompatible
set noexrc
set nostartofline
set nowrap
set pastetoggle=<F6>
set scrolloff=0
set shiftround
set shiftwidth=4
set showbreak=>>>·
set showcmd
set showmatch
set showmode
set smartcase
set smartindent
set smarttab
set statusline=%-3.30([%F]%)%(%r%m%h%w%y%)%=[0x%02B(%03b)][line\ %l\ of\ %L][%c/%v][%P]
set tabstop=4
set tags=./tags,./TAGS,tags,TAGS,~/.tags
set textwidth=100000
set virtualedit=block
set visualbell
set wildmenu
set wildmode=list:longest

augroup all_files
    autocmd!
    autocmd BufRead,BufNewFile  *       call Use_Filetype_Based_Dictionary()
    autocmd BufRead,BufNewFile  *       setlocal formatoptions=t1nql  nocindent comments&
augroup END

augroup cprog
    autocmd!
    autocmd BufRead *.c,*.h             setlocal formatoptions=r1noql cindent   comments=sr:/*,mb:*,el:*/,://
augroup END

augroup gzip
    autocmd!
    autocmd BufReadPre,FileReadPre      *.gz setlocal bin
    autocmd BufReadPre,FileReadPre      *.gz setlocal modifiable
    autocmd BufReadPre,FileReadPre      *.gz let ch_save = &ch|setlocal ch=2
    autocmd BufReadPost,FileReadPost    *.gz '[,']!gunzip
    autocmd BufReadPost,FileReadPost    *.gz setlocal nobin
    autocmd BufReadPost,FileReadPost    *.gz let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.gz execute ":doautocmd BufReadPost " . expand("%:r")
    autocmd BufWritePost,FileWritePost  *.gz !mv <afile> <afile>:r
    autocmd BufWritePost,FileWritePost  *.gz !gzip <afile>:r
    autocmd FileAppendPre               *.gz !gunzip <afile>
    autocmd FileAppendPre               *.gz !mv <afile>:r <afile>
    autocmd FileAppendPost              *.gz !mv <afile> <afile>:r
    autocmd FileAppendPost              *.gz !gzip <afile>:r
augroup END

augroup bzip2
    autocmd!
    autocmd BufReadPre,FileReadPre      *.bz2 setlocal bin
    autocmd BufReadPre,FileReadPre      *.bz2 setlocal modifiable
    autocmd BufReadPre,FileReadPre      *.bz2 let ch_save = &ch|setlocal ch=2
    autocmd BufReadPost,FileReadPost    *.bz2 setlocal cmdheight=2|'[,']!bunzip2
    autocmd BufReadPost,FileReadPost    *.bz2 setlocal cmdheight=1 nobin|execute ":doautocmd BufReadPost " . expand("%:r")
    autocmd BufReadPost,FileReadPost    *.bz2 let &ch = ch_save|unlet ch_save
    autocmd BufWritePost,FileWritePost  *.bz2 !mv <afile> <afile>:r
    autocmd BufWritePost,FileWritePost  *.bz2 !bzip2 <afile>:r
    autocmd FileAppendPre               *.bz2 !bunzip2 <afile>
    autocmd FileAppendPre               *.bz2 !mv <afile>:r <afile>
    autocmd FileAppendPost              *.bz2 !mv <afile> <afile>:r
    autocmd FileAppendPost              *.bz2 !bzip2 -9 --repetitive-best <afile>:r
augroup END

" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff <wouter@blub.net>
augroup encrypted
    autocmd!
    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre      *.gpg setlocal viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.gpg setlocal noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre      *.gpg setlocal bin
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|setlocal ch=2
    autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt 2> /dev/null
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.gpg setlocal nobin
    autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost  *.gpg u
augroup END

autocmd BufRead,BufNewFile *.are            setlocal filetype=mudarea
autocmd BufRead,BufNewFile *.tt2            setlocal filetype=xhtml
autocmd BufNewFile,BufRead *.tt             setlocal filetype=xhtml
autocmd BufRead,BufNewFile .vim*            setlocal filetype=vim
autocmd BufNewFile,BufRead *nginx/sites-*/* setlocal filetype=nginx
autocmd BufNewFile,BufRead *openvpn*/*.conf setlocal filetype=openvpn
autocmd BufRead,BufNewFile *.vcl            setlocal filetype=vcl
"au! Syntax vcl source ~/.vim/syntax/vcl.vim
autocmd! BufRead,BufNewFile *.ics setfiletype icalendar

inoremap <C-a> <Esc>I
inoremap <C-e> <Esc>A
inoremap <F11> <Esc>:call ToggleOption('wrap')<CR>a
inoremap <tab> <c-r>=Insert_Tab_Wrapper()<CR>
nnoremap <CR>  :nohlsearch<CR>
nnoremap <F11> :call ToggleOption('wrap')<CR>
" Zoom current view
nnoremap <F5>  <C-w>_
vnoremap <c-c> :!~/.vim/addons/blog-code<CR>
vnoremap <c-p> :!~/.vim/addons/blog-pre-sql<CR>
nnoremap <F12> :NERDTreeToggle<CR>

let NERDSpaceDelims=1
nnoremap c :call NERDComment(0, "toggle")<cr>j
vnoremap c :call NERDComment(1, "toggle")<cr>

" opensuse is broken, and we need to fix it
    map <ESC>[5~   <PageUp>
    map <ESC>[6~   <PageDown>
    map <ESC>[5;2~ <PageUp>
    map <ESC>[6;2~ <PageDown>
    map <ESC>[5;5~ <PageUp>
    map <ESC>[6;5~ <PageDown>
" opensuse is broken, and we need to fix it

" When shifting, retain selection over multiple shifts..., code from Damian Donway vimrc
vmap <expr> > KeepVisualSelection(">")
vmap <expr> < KeepVisualSelection("<")

function! KeepVisualSelection(cmd)
    if mode() ==# "V"
        return a:cmd . "gv"
    else
        return a:cmd
    endif
endfunction

source ~/.vim/set_color_scheme.vim

