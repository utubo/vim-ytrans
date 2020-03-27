let s:save_cpo = &cpo
set cpo&vim" properties

if exists('g:ytrans_loaded')
  finish
endif
let g:ytrans_loaded = 1

let g:ytrans_default_lang = get(g:, 'ytrans_default_lang', 'en')

nmap <plug>(ytrans-popup-cword)    :<C-u>call ytrans#popup(expand('<cword>'))<CR>
nmap <plug>(ytrans-popup-cword-en) :<C-u>call ytrans#popup(expand('<cword>'), 'en')<CR>
nmap <plug>(ytrans-popup-line)     :<C-u>call ytrans#popup(getline('.'))<CR>
vmap <plug>(ytrans-popup)          :<C-u>call ytrans#popup(ytrans#get_selection())<CR>gv
vmap <plug>(ytrans-popup-en)       :<C-u>call ytrans#popup(ytrans#get_selection(), 'en')<CR>gv
vmap <Plug>(ytrans-replace)        :<C-u>call ytrans#replace(ytrans#input_lang())<CR>
vmap <Plug>(ytrans-replace-repeat) :<C-u>call ytrans#replace('.')<CR>

if get(g:, 'ytrans_default_key_mappings', 1)
  nmap <silent> <Leader>tp <Plug>(ytrans-popup-cword)
  nmap <silent> <Leader>te <Plug>(ytrans-popup-cword-en)
  nmap <silent> <Leader>tl <Plug>(ytrans-popup-line)
  vmap <silent> <Leader>tp <Plug>(ytrans-popup)
  vmap <silent> <Leader>te <Plug>(ytrans-popup-en)
  vmap <silent> <Leader>tr <Plug>(ytrans-replace)
  vmap <silent> <Leader>tt <Plug>(ytrans-replace-repeat)
endif

let &cpo = s:save_cpo
unlet s:save_cpo

