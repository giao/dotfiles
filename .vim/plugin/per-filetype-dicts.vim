function! Use_Filetype_Based_Dictionary()
    if exists('b:current_syntax')
        set complete-=k complete+=k
        let &dictionary = '~/.vim/dict/' . b:current_syntax . '.dict'
    endif
endfunction
autocmd! BufRead,BufNewFile  *       call Use_Filetype_Based_Dictionary()
