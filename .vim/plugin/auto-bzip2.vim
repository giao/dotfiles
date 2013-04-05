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
