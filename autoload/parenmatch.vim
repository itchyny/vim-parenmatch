" =============================================================================
" Filename: autoload/parenmatch.vim
" Author: itchyny
" License: MIT License
" Last Change: 2016/03/30 00:59:48.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! parenmatch#highlight() abort
  if !get(g:, 'parenmatch_highlight', 1) | return | endif
  highlight parenmatch term=underline cterm=underline gui=underline
endfunction

let s:paren = {}
function! parenmatch#update() abort
  let insert = mode() ==# 'i' || mode() ==# 'R'
  let char = getline('.')[col('.') - insert - 1]
  silent! call matchdelete(w:parenmatch)
  if !has_key(s:paren, char) | return | endif
  let [open, closed, flags, stop] = s:paren[char]
  let q = [line('.'), col('.') - insert]
  if insert | let p = getcurpos() | call cursor(q) | endif
  let r = searchpairpos(open, '', closed, flags, '', line(stop), 10)
  if insert | call setpos('.', p) | endif
  if r[0] > 0 | let w:parenmatch = matchaddpos('parenmatch', [q, r]) | endif
endfunction

let s:matchpairs = ''
function! parenmatch#setup() abort
  if s:matchpairs ==# &l:matchpairs
    return
  endif
  let s:matchpairs = &l:matchpairs
  let s:paren = {}
  for [open, closed] in map(split(&l:matchpairs, ','), 'split(v:val, ":")')
    let s:paren[open] = [ escape(open, '[]'), escape(closed, '[]'), 'nW', 'w$' ]
    let s:paren[closed] = [ escape(open, '[]'), escape(closed, '[]'), 'bnW', 'w0' ]
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
