" =============================================================================
" Filename: plugin/parenmatch.vim
" Author: itchyny
" License: MIT License
" Last Change: 2016/03/27 14:22:20.
" =============================================================================

if exists('g:loaded_parenmatch') || v:version < 703 || !exists('*matchaddpos')
  finish
endif
let g:loaded_parenmatch = 1

let s:save_cpo = &cpo
set cpo&vim

augroup parenmatch
  autocmd!
  autocmd VimEnter,ColorScheme * call parenmatch#highlight()
  autocmd CursorMoved,CursorMovedI * call parenmatch#update()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
