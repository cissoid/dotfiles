" File Name: ini.vim
" Author: cissoid
" Created At: 2016-11-04T15:27:42+0800
" Last Modified: 2016-11-09T11:33:23+0800
scriptencoding utf-8

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = 'ini'

syntax match iniNumber '\v\C[0-9]+'
syntax match iniComment '\v\C\;.*$'

syntax region iniSection matchgroup=iniSectionParan start='\v\C(^\s*)@<=\[' end='\v\C\]' oneline
syntax match iniKey '\v\C(^\s*)@<=[^;=\[]+' nextgroup=iniEqual skipwhite
syntax match iniEqual '\v\C\=' contained

highlight link iniNumber Number
highlight link iniComment Comment

highlight link iniSection Keyword
highlight link iniSectionParan SpecialChar
highlight link iniKey Identifier
highlight link iniEqual Operator
