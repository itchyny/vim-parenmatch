" =============================================================================
" Filename: autoload/parenmatch.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/02/09 00:17:20.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! parenmatch#highlight() abort
  if !get(g:, 'parenmatch_highlight', 1) | return | endif
  highlight ParenMatch term=underline cterm=underline gui=underline
endfunction

let s:paren = {}
function! parenmatch#update(...) abort
  if !get(b:, 'parenmatch', get(g:, 'parenmatch', 1)) | return | endif
  let i = a:0 ? a:1 : mode() ==# 'i' || mode() ==# 'R'
  let c = matchstr(getline('.'), '.', col('.') - i - 1)
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

if has('timers')
  let s:timer = 0
  function! parenmatch#cursormoved() abort
    if get(w:, 'parenmatch')
      silent! call matchdelete(w:parenmatch)
      let w:parenmatch = 0
    endif
    call timer_stop(s:timer)
    let s:timer = timer_start(50, 'parenmatch#timer_callback')
  endfunction
  function! parenmatch#timer_callback(...) abort
    call parenmatch#update()
  endfunction
else
  function! parenmatch#cursormoved() abort
    call parenmatch#update()
  endfunction
endif

if !has('vim_starting')
  call parenmatch#highlight()
endif

let &cpo = s:save_cpo
unlet s:save_cpo
