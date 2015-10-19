runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
Helptags

set shell=/bin/bash

let mapleader=";"

filetype on
filetype plugin on

set incsearch  "实时搜索
set ignorecase  "忽略大小写
set nocompatible  "关闭兼容模式
set wildmenu  "智能补全

set background=dark
"colorscheme solarized
colorscheme molokai

set gcr=a:block-blinkon0
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=m
set guioptions-=T

set laststatus=2
set ruler
set number
set cursorline
set cursorcolumn
set hlsearch

set guifont=Consolas\ 11.5
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

set foldmethod=syntax
set nofoldenable

