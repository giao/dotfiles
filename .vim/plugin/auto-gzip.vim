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
