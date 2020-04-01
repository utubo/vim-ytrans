let s:save_cpo = &cpo
set cpo&vim" properties

if exists('g:ytrans_loaded')
  finish
endif
let g:ytrans_loaded = 1

let g:ytrans_default_lang = get(g:, 'ytrans_default_lang', 'en')

nnoremap <silent> <plug>(ytrans-popup-cword)    :<C-u>call ytrans#popup(expand('<cword>'))<CR>
nnoremap <silent> <plug>(ytrans-popup-cword-en) :<C-u>call ytrans#popup(expand('<cword>'), 'en')<CR>
nnoremap <silent> <plug>(ytrans-popup-line)     :<C-u>call ytrans#popup(getline('.'))<CR>
vnoremap <silent> <plug>(ytrans-popup)          :<C-u>call ytrans#popup(ytrans#get_selection())<CR>gv
vnoremap <silent> <plug>(ytrans-popup-en)       :<C-u>call ytrans#popup(ytrans#get_selection(), 'en')<CR>gv
vnoremap <silent> <Plug>(ytrans-replace)        :<C-u>call ytrans#replace(ytrans#input_lang())<CR>
vnoremap <silent> <Plug>(ytrans-replace-repeat) :<C-u>call ytrans#replace('.')<CR>

if get(g:, 'ytrans_default_key_mappings', 1)
  nmap <Leader>tp <Plug>(ytrans-popup-cword)
  nmap <Leader>te <Plug>(ytrans-popup-cword-en)
  nmap <Leader>tl <Plug>(ytrans-popup-line)
  vmap <Leader>tp <Plug>(ytrans-popup)
  vmap <Leader>te <Plug>(ytrans-popup-en)
  vmap <Leader>tr <Plug>(ytrans-replace)
  vmap <Leader>tt <Plug>(ytrans-replace-repeat)
endif

let &cpo = s:save_cpo
unlet s:save_cpo

