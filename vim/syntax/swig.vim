" File Name: swig.vim
" Author: cissoid
" Created At: 2016-08-03T17:10:13+0800
" Last Modified: 2016-08-05T13:56:35+0800
scriptencoding utf-8

if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
    let main_syntax = 'html'
endif

runtime! syntax/html.vim
runtime! syntax/javascript.vim
unlet b:current_syntax

let b:current_syntax = 'swig'


syntax cluster HTML contains=htmlHead,htmlTitle,htmlString,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,htmlLink,String

syntax region swigString start='\v\C\"' skip='\v\C\\.' end='\v\C\"' contained
syntax region swigString start='\v\C\'' skip='\v\C\\.' end='\v\C\'' contained
syntax match swigNumber '\v\C[0-9]+' contained
syntax match swigNumber '\v\C0x[0-9a-fA-F]+' contained
syntax match swigFloat '\v\C[0-9]+\.[0-9]+(e[0-9]+)?' contained
syntax keyword swigBoolean true false contained
syntax match swigOperator '\v\C[\=\|]'
syntax cluster swigType contains=swigString,swigNumber,swigFloat,swigBoolean,swigOperator

syntax match swigFilterPipe '\v\C\|\s*' contained
syntax keyword swigFilter upper lower capitalize title contained
syntax keyword swigFilter addslashes join replace reverse sort contained
syntax keyword swigFilter escape safe raw striptags contained
syntax keyword swigFilter default first last groupBy uniq contained
syntax keyword swigFilter date json url_encode url_decode contained
syntax region swigFilterArgs start='\v\C\(' end='\v\C\)' nextgroup=swigFilterPipe contains=@swigType contained
syntax match swigVarBracket '\v\C(\{\{)|(\}\})' contained
syntax region swigVarBlock start='\v\C\{\{' end='\v\C\}\}' matchgroup=swigVariableBracket contains=swigVarBracket,@swigType,swigFilter.* containedin=@HTML oneline keepend

syntax keyword swigTag autoescape filter raw set contained
syntax keyword swigConditionalTag if elif else endif contained
syntax keyword swigRepeatTag for in endfor contained
syntax keyword swigIncludeTag extends import include parent contained
syntax keyword swigBlockTag block endblock contained
syntax keyword swigMacroTag macro endmacro contained
syntax keyword swigSpacelessTag spaceless endspaceless contained
syntax match swigTagBracket '\v\C(\{\%)|(\%\})' contained
syntax region swigTagBlock start='\v\C\{\%' end='\v\C\%\}' matchgroup=swigTagBracket contains=swigTagBracket,@swigType,swigVarBlock,swig.*Tag containedin=@HTML oneline fold

syntax region swigComment start='\v\C\{\#' end='\v\C\#\}' keepend


highlight link swigString String
highlight link swigNumber Number
highlight link swigFloat Float
highlight link swigBoolean Boolean
highlight link swigOperator Operator

highlight link swigFilterPipe Operator
highlight link swigFilter Function
highlight link swigVarBracket Identifier

highlight link swigConditionalTag Conditional
highlight link swigRepeatTag Repeat
highlight link swigIncludeTag PreProc
highlight link swigBlockTag PreProc
highlight link swigMacroTag PreProc
highlight link swigSpacelessTag PreProc

highlight link swigTagBracket Identifier

highlight link swigComment Comment
