" ================================
" File Name: filetype.vim
" Author: cissoid
" Created At: 2016-06-22T20:42:07+0800
" Last Modified: 2017-04-06T18:00:55+0800
" ================================

autocmd! BufNewFile,BufRead *.md set filetype=markdown
autocmd! BufNewFile,BufRead CMakeLists.txt set filetype=cmake
autocmd! BufNewFile,BufRead *.swig set filetype=swig
autocmd! BufNewFile,BufRead SConstruct set filetype=python
