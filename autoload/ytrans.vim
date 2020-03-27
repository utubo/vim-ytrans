let s:save_cpo = &cpo
set cpo&vim" properties

func! s:createCurlCommand(text, lang) abort
  let l:text = substitute(a:text, '\\', '\\', 'g')
  let l:text = substitute(l:text, "'", "'\"'\"'", 'g')
  let command = printf(
    \ "curl " .
    \ "  'https://translate.yandex.net/api/v1.5/tr.json/translate'" .
    \ "  --get -sS" .
    \ "  --data 'key=%s'" .
    \ "  --data 'lang=%s'" .
    \ "  --data-urlencode 'text=%s'",
    \ g:ytrans_api_key, a:lang, l:text)
  return l:command
endfunc

" On Windows, curl doesn't encode in UTF-8, so ytrans uses Powershell.
func! s:createPSCommand(text, lang) abort
  let l:text = substitute(a:text, '`', '``', 'g')
  let l:text = substitute(l:text, '"', '"""', 'g')
  let l:text = substitute(l:text, "'", "'+\"\"\"'\"\"\"+'", 'g')
  let l:new_line = '_NL_'
  let l:i = 0
  while match(l:text, l:new_line) != -1
    let l:i += 1
    let l:new_line = '_NL' . l:i . '_'
  endwhile
  let l:text = join(split(l:text, "\n"), l:new_line)
  let l:command = printf(
    \ 'chcp 65001 > nul && powershell -Command "&{ ' .
    \ "$url = 'https://translate.yandex.net/api/v1.5/tr.json/translate';" .
    \ "$body = @{" .
    \ "  key='%s';" .
    \ "  lang='%s';" .
    \ "  text=('%s').Replace('%s', \"\"\"`n\"\"\");" .
    \ "};" .
    \ "$ret = (Invoke-RestMethod -Method 'Post' -Uri $url -Body $body);" .
    \ "Write-Host -NoNewLine $ret.text;" .
    \ '}"',
    \ g:ytrans_api_key, a:lang, l:text, l:new_line)
  return l:command
endfunc

func! ytrans#translate(text, lang = '', callback = '') abort
  if empty(get(g:, 'ytrans_api_key', ''))
    throw 'g:ytrans_api_key is empty.'
  endif
  if empty(a:lang)
    let l:lang = g:ytrans_default_lang
  elseif a:lang == '.'
    let l:lang = get(b:, 'ytrans_buf_lang', g:ytrans_default_lang)
  else
    let l:lang = a:lang
  endif
  let l:command = has('win32')
    \ ? s:createPSCommand(a:text, l:lang)
    \ : s:createCurlCommand(a:text, l:lang)
  if empty(a:callback)
    let l:stdout = system(l:command)
    return s:GetResult(l:stdout)
  endif
  let l:Callback = type(a:callback) == v:t_string ? function(a:callback) : a:callback
  let l:CallbackChain = function('s:TranslateCb', [l:Callback])
  if has('win32')
    let l:command = 'cmd /C ' .l:command
  else
    let l:command = ['sh', '-c', l:command]
  endif
  call job_start(l:command, { 'close_cb': l:CallbackChain })
endfunc

func! s:TranslateCb(callback, ch) abort
  let l:lines = []
  while ch_status(a:ch, {'part': 'out'}) == 'buffered'
    let l:lines += [ch_read(a:ch)]
  endwhile
  let l:stdout = join(l:lines, "\n")
  let l:result = s:GetResult(l:stdout)
  call a:callback(l:result)
endfunc

func! s:GetResult(stdout) abort
  if has('win32')
    return a:stdout
  endif
  let l:json = json_decode(a:stdout)
  if !has_key(l:json, 'text')
    throw a:stdout
  endif
  return join(l:json.text, "\n")
endfunc

func! ytrans#get_selection() abort
  let l:org = @"
  silent normal! gvy
  let l:text = @"
  let @" = l:org
  return l:text
endfunc

func! ytrans#replace(lang = '') abort
  if empty(a:lang)
    return
  endif
  call ytrans#translate(ytrans#get_selection(), a:lang, 's:ReplaceCb')
endfunc

func! s:ReplaceCb(result) abort
  let b:ytrans_text = a:result
  execute "normal! gvs\<C-R>=b:ytrans_text\<CR>"
  unlet! b:ytrans_text
endfunc

func! ytrans#popup(text, lang = '') abort
  call ytrans#translate(a:text, a:lang, 's:PopupCb')
endfunc

func! s:PopupCb(result) abort
  call popup_atcursor(split(a:result, "\n"), #{})
endfunc

func! ytrans#input_lang()
  echoh Question
  let l:lang = input('lang(from-to): ')
  echoh None
  if !empty(l:lang)
    let b:ytrans_buf_lang = l:lang
  endif
  return l:lang
endfunc

let &cpo = s:save_cpo
unlet s:save_cpo

