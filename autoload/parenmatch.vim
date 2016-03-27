" =============================================================================
" Filename: autoload/parenmatch.vim
" Author: itchyny
" License: MIT License
" Last Change: 2016/03/27 14:42:14.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! parenmatch#highlight() abort
  if !get(g:, 'parenmatch_highlight', 1) | return | endif
  highlight parenmatch term=underline cterm=underline gui=underline
endfunction

let s:paren = {}
let s:matchpairs = ''
function! parenmatch#update() abort
  if s:matchpairs !=# &l:matchpairs | call parenmatch#setup() | endif
  let insert = mode() ==# 'i' || mode() ==# 'R'
  let col0 = col('.') - insert
  let char = getline('.')[col0 - 1]
  silent! call matchdelete(w:parenmatch)
  if !has_key(s:paren, char) | return | endif
  let [open, closed, backward, stop] = s:paren[char]
  let line0 = line('.')
  if insert | let pos = getcurpos() | call cursor(line0, col0) | endif
  let [line1, col1] = searchpairpos(open, '', closed, backward . 'nW', '', line(stop), 100)
  if insert | call setpos('.', pos) | endif
  if line1 > 0 | let w:parenmatch = matchaddpos('parenmatch', [[line0, col0], [line1, col1]]) | endif
endfunction

function! parenmatch#setup() abort
  let s:matchpairs = &l:matchpairs
  let s:paren = {}
  for [open, closed] in map(split(&l:matchpairs, ','), 'split(v:val, ":")')
    let s:paren[open] = [ escape(open, '[]'), escape(closed, '[]'), '', 'w$' ]
    let s:paren[closed] = [ escape(open, '[]'), escape(closed, '[]'), 'b', 'w0' ]
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
