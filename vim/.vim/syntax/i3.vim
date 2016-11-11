" File Name: i3.vim
" Author: cissoid
" Created At: 2016-11-09T15:25:37+0800
" Last Modified: 2016-11-10T13:42:09+0800
scriptencoding utf-8

if exists('b:current_syntax')
    finish
endif

let b:current_syntax = 'i3'

syntax region i3String start='\v\C\'' skip='\v\C\\\'' end='\v\C\'' oneline
syntax region i3String start='\v\C\"' skip='\v\C\\\"' end='\v\C\"' oneline
" syntax match i3Comment '\v\C#.*$'
syntax match i3ModKey '\v\C\$mod>'
syntax match i3Key '\v\C<(Mod[0-9])|(Return)|(Shift)|(Escape)|(Space)>'
syntax match i3Color '\v\C<#[a-zA-Z0-9]{6}>'

syntax match i3LineBegin '\v\C^\s*' nextgroup=i3Comment,i3Command skipwhite

" exec command.
syntax keyword i3Command exec contained nextgroup=i3ExecFlag skipwhite
syntax match i3ExecFlag '\v\C\-\-(no\-startup\-id)>' contained

" split command.
syntax keyword i3Command split contained nextgroup=i3SplitOption skipwhite
syntax keyword i3SplitOption vertical horizontal toggle contained

" layout command.
syntax keyword i3Command layout contained nextgroup=i3LayoutOption,i3LayoutToggle skipwhite
syntax keyword i3LayoutOption default tabbed stacking splitv splith contained
syntax keyword i3LayoutToggle toggle contained nextgroup=i3LayoutToggleOption skipwhite
syntax keyword i3LayoutToggleOption split all contained

" focus command.
syntax keyword i3Command focus contained nextgroup=i3FocusOption,i3FocusOutput skipwhite
syntax keyword i3FocusOption left right up down parent child floating tilling mode_toggle contained
syntax keyword i3FocusOutput output contained nextgroup=i3FocusOutputOption skipwhite
syntax keyword i3FocusOutputOption left right up down contained

" move command.
syntax keyword i3Command move contained nextgroup=i3MoveOption,i3MovePixel,i3MovePos,i3MoveAbsPos skipwhite
syntax keyword i3MoveOption left right up down contained
syntax match i3MovePixel '\v\C[0-9]+ px' contained
syntax keyword i3MovePos position contained nextgroup=i3Move2Pixel,i3MovePosOption skipwhite
syntax match i3Move2Pixel '\v\C[0-9]+ px [0-9]+ px' contained
syntax keyword i3MovePosOption center mouse contained
syntax keyword i3MoveAbsPos absolute contained nextgroup=i3MovePos skipwhite

" sticky command.
syntax keyword i3Command sticky contained nextgroup=i3StickyOption skipwhite
syntax keyword i3StickyOption enable disable toggle contained

" workspace command.
syntax match i3WorkspaceNum '\v\C[0-9]+' contained
syntax cluster i3WorkspaceName contains=i3WorkspaceNum

syntax keyword i3Command workspace contained nextgroup=i3WorkspaceOption,@i3WorkspaceName,i3WorkspaceNameFlag skipwhite
syntax keyword i3WorkspaceOption next prev next_on_output prev_on_output back_and_forth contained
syntax match i3WorkspaceNameFlag '\v\C\-\-(no\-auto\-back\-and\-forth)>' contained nextgroup=@i3WorkspaceName skipwhite

" workspace move command.
syntax keyword i3Command move contained nextgroup=i3MoveWorkspaceOption,i3MoveWorkspaceFlag skipwhite
syntax keyword i3MoveWorkspaceOption window container contained nextgroup=i3MoveWorkspaceTo skipwhite
syntax match i3MoveWorkspaceFlag '\v\C\-\-(no\-auto\-back\-and\-forth)>' contained nextgroup=i3MoveWorkspaceOption skipwhite
syntax match i3MoveWorkspaceTo '\v\C<(to )?workspace>' contained nextgroup=@i3WorkspaceName,i3MoveWorkspaceToOption skipwhite
syntax keyword i3MoveWorkspaceToOption prev next current contained

" workspace rename command.
syntax keyword i3Command rename contained nextgroup=i3RenameWorkspaceTo,i3RenameWorkspaceOldName skipwhite


highlight link i3String String
highlight link i3Comment Comment
highlight link i3ModKey Special
highlight link i3Key Define
highlight link i3Color Constant

highlight link i3Command Keyword

highlight link i3ExecFlag Constant

highlight link i3SplitOption Constant

highlight link i3LayoutOption Constant
highlight link i3LayoutToggle Constant
highlight link i3LayoutToggleOption Constant

highlight link i3FocusOption Constant
highlight link i3FocusOutput Constant
highlight link i3FocusOutputOption Constant

highlight link i3MoveOption Constant
highlight link i3MovePixel Number
highlight link i3MovePos Constant
highlight link i3Move2Pixel Number
highlight link i3MovePosOption Constant
highlight link i3MoveAbsPos Constant

highlight link i3StickyOption Constant

highlight link i3WorkspaceNum Number
highlight link i3WorkspaceOption Constant
highlight link i3WorkspaceNameFlag Constant

highlight link i3MoveWorkspaceOption Constant
highlight link i3MoveWorkspaceFlag Constant
highlight link i3MoveWorkspaceTo Keyword
highlight link i3MoveWorkspaceToOption Constant
