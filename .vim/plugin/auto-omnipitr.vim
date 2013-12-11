function! SetupSyntasticEnvironment()
    let l:path = expand('%:p')
    if l:path =~ '^/home/depesz/projects/omniti/omnipitr/'
        let g:syntastic_perl_lib_path = '/home/depesz/projects/omniti/omnipitr/lib/'
    endif
endfunction

augroup omnipitr
    autocmd!
    autocmd! BufReadPost,BufNewFile * call SetupSyntasticEnvironment()
augroup END
