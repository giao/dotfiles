setlocal iskeyword+=-

" Copy <body> content (without <body> tags) to * buffer - system clipboard
nnoremap <buffer> <C-b> gg/<body<enter>"*yit

" Move current selection inside <pre lang="sql">
vnoremap <buffer> <C-p> di<pre lang="sql"><enter></pre><esc>P
