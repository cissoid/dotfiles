" ================================
" File Name: filetype.vim
" Author: cissoid
" Created At: 2016-06-22T20:42:07+0800
" Last Modified: 2016-10-27T15:12:25+0800
" ================================

autocmd! BufNewFile,BufRead CMakeLists.txt set filetype=cmake
autocmd! BufNewFile,BufRead *.swig set filetype=swig
autocmd! BufNewFile,BufRead SConstruct set filetype=python
