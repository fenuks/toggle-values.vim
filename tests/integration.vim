let s:suite = themis#suite('integration')
let s:assert = themis#helper('assert')

nmap gt <Plug>(ToggleValueNormal)
nmap gr <Plug>(ToggleValueOperator)
vmap gs <Plug>(ToggleValueVisual)

" vint: -ProhibitCommandRelyOnUser
function! s:suite.ToggleValueNormal()
    % delete _
    0put ='True or False'
    1put ='unrelated'
    call setpos('.', [0, 1, 1, 0])
    call toggle_values#toggle_value_normal()
    call s:assert.equals(getline(1, '$'), ['False or False', 'unrelated', ''])
endfunction

function! s:suite.ToggleValueNormal_count()
    set filetype=nonexisting.ignore
    % delete _
    0put ='Monday 1'
    1put ='unrelated'
    call setpos('.', [0, 1, 1, 0])
    normal gt
    call s:assert.equals(getline(1, '$'), ['Tuesday 1', 'unrelated', ''])
    normal 4gt
    call s:assert.equals(getline(1, '$'), ['Monday 1', 'unrelated', ''])
endfunction

function! s:suite.ToggleValueNormal_emptyFile()
    % delete _
    normal gt
    call s:assert.equals(getline(1, '$'), [''])
endfunction

function! s:suite.ToggleValueVisual()
    % delete _
    0put ='Monday 1'
    1put ='unrelated'
    call setpos('.', [0, 1, 1, 0])
    normal vegs
    call s:assert.equals(getline(1, '$'), ['Tuesday 1', 'unrelated', ''])
    normal 4gs
    call s:assert.equals(getline(1, '$'), ['Monday 1', 'unrelated', ''])
endfunction

function! s:suite.ToggleValueVisual_unknown_selection()
    % delete _
    0put ='unknown 1'
    1put ='unrelated'
    call setpos('.', [0, 1, 1, 0])
    normal vegs
    call s:assert.equals(getline(1, '$'), ['unknown 1', 'unrelated', ''])
endfunction

" doesn't work since normal gr2e doesn't work with operator pending mapping
" function! s:suite.ToggleValueOperator()
"     setlocal filetype=
"     % delete _
"     0put ='not True 1'
"     1put ='unrelated'
"     call setpos('.', [0, 1, 1, 0])
"     normal gr2e
"     call s:assert.equals(getline(1, '$'), ['not False 1', 'unrelated', ''])
" endfunction
