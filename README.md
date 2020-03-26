⚠ **This plugin is a draft.**  
# vim-ytrans
Yandex Translate in Vim.  
see also https://tech.yandex.com/translate/

## Required
- Yandex API-key. Get it on the [Yandex](https://translate.yandex.com/developers/keys).
- curl or Powershell.

## Install
(dein)
```vimscript
call dein#add('utubo/vim-ytrans')
```
  
and set up ytrans
```vimscript
let g:ytrans_api_key = 'API-key here'
let g:ytrans_default_lang = 'en'
```

## Let's try!
Select this text in visual-mode.
```
私はペンを持っています。
```
Type `<Leader>`,`t`, `r` and input `ja-en`.
```
I pen to have.
```
🙃

## Languages
see [here](https://tech.yandex.com/translate/doc/dg/concepts/api-overview-docpage/#api-overview__languages).  
and  
`.` is last used language.  
### examples
- `ja-en` ... Japanese to English
- `en` ... Automatically to English

## API

### Pop up the translated text.
ytrans#popup(text, lang = g:ytrans_default_lang)
```vimscript
call ytrans#popup('test', 'ja-en')
```

### Replace visual selection.
ytrans#replace(lang = g:ytrans_default_lang)
```vimscript
call ytrans#replace('ja-en')
```

### Get the translated text.
ytrans#translate(text, lang = g:ytrans_default_lang, callback = '')
```vimscript
echo ytrans#translate('test')
```

### Utility
ytrans#get_selection()  
get visual selection.
```vimscript
vnoremap <Leader>te :<C-u>call ytrans#popup(ytrans#get_selection(), 'en')<CR>
```

## Mapping
see [/plugin/ytrans.vim](/plugin/ytrans.vim)

## License
[MIT](https://opensource.org/licenses/mit-license.php).

