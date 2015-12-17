augroup xz
    autocmd!
    autocmd BufReadPre,FileReadPre      *.xz setlocal bin
    autocmd BufReadPre,FileReadPre      *.xz setlocal modifiable
    autocmd BufReadPre,FileReadPre      *.xz let ch_save = &ch|setlocal ch=2
    autocmd BufReadPost,FileReadPost    *.xz setlocal cmdheight=2|'[,']!unxz
    autocmd BufReadPost,FileReadPost    *.xz setlocal cmdheight=1 nobin|execute ":doautocmd BufReadPost " . expand("%:r")
    autocmd BufReadPost,FileReadPost    *.xz let &ch = ch_save|unlet ch_save
    autocmd BufWritePost,FileWritePost  *.xz !mv <afile> <afile>:r
    autocmd BufWritePost,FileWritePost  *.xz !xz <afile>:r
    autocmd FileAppendPre               *.xz !unxz <afile>
    autocmd FileAppendPre               *.xz !mv <afile>:r <afile>
    autocmd FileAppendPost              *.xz !mv <afile> <afile>:r
    autocmd FileAppendPost              *.xz !xz -9 <afile>:r
augroup END
