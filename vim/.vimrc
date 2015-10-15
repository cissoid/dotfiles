runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
Helptags

set shell=/bin/bash

filetype on
filetype plugin on

set incsearch
set ignorecase
set nocompatible
set wildmenu

set background=dark
colorscheme molokai
let g:molokai_original=1
let g:rehash256=1

set laststatus=2
set ruler
set number
set cursorline
" set cursorcolumn
set hlsearch

set nowrap
let g:Powerline_colorscheme='solarized256'

syntax enable
syntax on

filetype indent on
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

