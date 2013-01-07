setlocal autoindent
setlocal textwidth=200
setlocal backspace=indent,eol,start
setlocal tabstop=4
setlocal expandtab
setlocal shiftwidth=4
setlocal shiftround
setlocal matchpairs+=<:>

setlocal iskeyword+=:

setlocal complete+=k~/.vim_extras/local.perl.modules

setlocal include=^\\s*use\\s\\+\\zs\\k\\+\\ze
setlocal includeexpr=substitute(v:fname,'::','/','g')
setlocal suffixesadd=.pm
execute 'setlocal path+=' . substitute($PERL5LIB, ':', ',', 'g')

function! PerlCheck()
    let currentfilename = expand("%")
    let basewindow = winnr()
    let compilationlog  = currentfilename . '.clog'
    let clogwin = bufwinnr(compilationlog)
    if clogwin > 0
        exec 'wincmd w '.clogwin
        close!
    endif
    let tempdata = system('perl -Twc "'.currentfilename.'" > "'.compilationlog.'" 2>&1')
    let tempdata = substitute(system('cat "'.compilationlog.'" | grep -E " syntax OK$" | wc -l'),"[     \n\r]","","g")
    if tempdata > 0
        echo "OK"
    else
        let tempdata = substitute(system('cat "'.compilationlog.'" | wc -l'),"[   \n\r]","","g")
        exec "split ".compilationlog
        set readonly
        set nomodifiable
        let clogwin=winnr()
        exec 'wincmd w '.basewindow
        wincmd K
        exec 'wincmd w '.clogwin
        exec "resize ".tempdata
        normal 1
        let findpos = search('line \d\+\.$','')
        if findpos == 0
            exec 'wincmd w '.basewindow
            return
        endif
        let cline = substitute(getline(findpos),'^.* \(\d\+\)\.[\n\r    ]*$','\1','')
        exec 'wincmd w '.basewindow
        exec cline
        echohl ErrorMsg 
        echo "Problem w linii ".cline."!!!" 
        echohl None
    endif
endfun

map <F9> :call PerlCheck()

function! GetPerlFold()
   if getline(v:lnum) =~ '^\s*sub\s'
      return ">1"
   elseif getline(v:lnum) =~ '\}\s*$'
      let my_perlnum = v:lnum
      let my_perlmax = line("$")
      while (1)
         let my_perlnum = my_perlnum + 1
         if my_perlnum > my_perlmax
            return "<1"
         endif
         let my_perldata = getline(my_perlnum)
         if my_perldata =~ '^\s*\(\#.*\)\?$'
            " do nothing
         elseif my_perldata =~ '^\s*sub\s'
            return "<1"
         else
            return "="
         endif
      endwhile
   else
      return "="
   endif
endfunction
setlocal foldexpr=GetPerlFold()
setlocal foldmethod=expr 
setlocal number
setlocal cursorline
setlocal cursorcolumn
nmap + zo
nmap - zc
nmap = zR
nmap - zM

function! Perltidy() range
    let s:ptdy = "!perltidy -i=" . &sw
    if &et
        let s:ptdy = s:ptdy . " -nt"
    else
        let s:ptdy = s:ptdy . " -et=" . &ts
    endif
    execute a:firstline . "," . a:lastline . s:ptdy
    unlet s:ptdy
endfunction

nmap <F4> :%call Perltidy()<CR>
vmap <F4> :call Perltidy()<CR>
