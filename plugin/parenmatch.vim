" =============================================================================
" Filename: plugin/parenmatch.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/02/01 12:00:00.
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
  autocmd VimEnter * execute
    \ 'autocmd parenmatch WinEnter,BufEnter,BufWritePost * call parenmatch#update()'
  autocmd CursorMoved,CursorMovedI * call parenmatch#cursormoved()
  autocmd InsertEnter * call parenmatch#update(1)
  autocmd InsertLeave * call parenmatch#update(0)
  autocmd VimEnter,WinEnter,BufWinEnter,FileType * call parenmatch#setup()
  autocmd OptionSet matchpairs call parenmatch#setup()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
