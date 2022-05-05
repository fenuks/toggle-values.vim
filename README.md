# Toggle Values

Plugin to toggle/cycle between values in the buffer.

## Features

- supports normal, visual and operator mappings
- mappings accept count
- rules can be global or per `&filetype` or language (if `&spelllang` is set)
- subfiletypes are supported (if `&filetype` is `vimwiki.markdown`) plugin
  will attempt to use first matching rule in ['vimwiki.markdown',
  'vimwiki', 'markdown', '']
- rules can be defined independently from `&filetype` for languages
  (`&spelllang` option is read, just as with `&filetype`, languages are split,
  and first matching rule is used)
- rules can be made case-insensitive per `&filetype` or `&spelllang` level
  or just per rule level
- rules can extend other rules (e.g. rules for `cpp` might extend `c` rules); by
  default `extends: ['']`
- rules can specify that toggled value inherits casing of original world (only 
  useful if rule is also case insensitive)
- code is covered with tests

## Configuration
### Mappings
No default mappings are set, and must be added manually, e.g.:

```vim
nmap <unique> <silent> st <Plug>(ToggleValueNormal)
vmap <unique> <silent> st <Plug>(ToggleValueVisual)
nmap <unique> <silent> so <Plug>(ToggleValueOperator)
imap <unique> <silent> <a-t> <C-o><Plug>(ToggleValueNormal)<right>
```

### Rules
No rules are added by default, and must be added manually e.g.:

```vim
let g:toggle_values = {
\    'filetypes': {
\        '': [
\                ['True', 'False'],
\                ['true', 'false'],
\        ],
\        'sql': {
\            'ignore_case': v:true,
\            'keep_case': v:true,
\            'extend': [''],
\            'definitions': [
\                ['SELECT', 'INSERT'],
\                {'ignore_case': v:false, 'keep_case': v:false, 'values': ['DROP', 'drop']}]}},
\    'languages': {
\        'en': [
\            ['yes', 'no']
\        ]
\    }
\}
```

Rules can be either specified as list or dictionary. Using dictionary allows finer control over rule behaviour.

Fields `ignore_case` and `keep_case` can be added at definition or rule level. By default, both are `v:false`.

## Licence
Copyright (c) fenuks. Distributed under the same terms as Vim itself. See `:help license`.
