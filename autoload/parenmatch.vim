" =============================================================================
" Filename: autoload/parenmatch.vim
" Author: itchyny
" License: MIT License
" Last Change: 2016/09/16 00:00:00.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! parenmatch#highlight() abort
  if !get(g:, 'parenmatch_highlight', 1) | return | endif
  highlight ParenMatch term=underline cterm=underline gui=underline
endfunction

let s:paren = {}
function! parenmatch#update() abort
  if !get(b:, 'parenmatch', get(g:, 'parenmatch', 1)) | return | endif
  let i = mode() ==# 'i' || mode() ==# 'R'
  let c = getline('.')[col('.') - i - 1]
  silent! call matchdelete(w:parenmatch)
  if !has_key(s:paren, c) | return | endif
  let [open, closed, flags, stop] = s:paren[c]
  let q = [line('.'), col('.') - i]
  if i | let p = getcurpos() | call cursor(q) | endif
  let r = searchpairpos(open, '', closed, flags, '', line(stop), 10)
  if i | call setpos('.', p) | endif
  if r[0] > 0 | let w:parenmatch = matchaddpos('ParenMatch', [q, r]) | endif
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
