let s:suite = themis#suite('unit')
let s:assert = themis#helper('assert')
let s:scope = themis#helper('scope')

let s:lib = s:scope.funcs('autoload/toggle_values.vim')

function! s:suite.get_next_match()
    call s:assert.equals(s:lib.get_next_match_for_rule('True',  'filetypes', '', 1), 'False')
    call s:assert.equals(s:lib.get_next_match_for_rule('true',  'filetypes', '', 1), v:null)
    call s:assert.equals(s:lib.get_next_match_for_rule('False', 'filetypes', '', 1), 'True')
    call s:assert.equals(s:lib.get_next_match_for_rule('false', 'filetypes', '', 1), v:null)
endfunction

function! s:suite.get_next_match_subfiletype()
    setlocal filetype=unknown.ignore
    call s:assert.equals(s:lib.get_next_value_for_buffer('True', 1),   'False')
    call s:assert.equals(s:lib.get_next_value_for_buffer('lala', 1),   v:null)
    call s:assert.equals(s:lib.get_next_value_for_buffer('Monday', 1), 'Tuesday')
endfunction

function! s:suite.get_next_match_OverrideInsensitive()
    call s:assert.equals(s:lib.get_next_match_for_rule('YES', 'filetypes', '', 1), 'no')
    call s:assert.equals(s:lib.get_next_match_for_rule('yes', 'filetypes', '', 1), 'no')
    call s:assert.equals(s:lib.get_next_match_for_rule('NO',  'filetypes', '', 1), 'yes')
    call s:assert.equals(s:lib.get_next_match_for_rule('no',  'filetypes', '', 1), 'yes')
endfunction

function! s:suite.get_next_match_DefaultInsensitive()
    call s:assert.equals(s:lib.get_next_match_for_rule('false', 'filetypes', 'ignore', 1), 'True')
    call s:assert.equals(s:lib.get_next_match_for_rule('False', 'filetypes', 'ignore', 1), 'True')
    call s:assert.equals(s:lib.get_next_match_for_rule('true',  'filetypes', 'ignore', 1), 'False')
    call s:assert.equals(s:lib.get_next_match_for_rule('True',  'filetypes', 'ignore', 1), 'False')
endfunction

function! s:suite.get_next_match_OverrideSensitive()
    call s:assert.equals(s:lib.get_next_match_for_rule('vi', 'filetypes',   'ignore', 1), 'vim')
    call s:assert.equals(s:lib.get_next_match_for_rule('VI', 'filetypes',   'ignore', 1), v:null)
    call s:assert.equals(s:lib.get_next_match_for_rule('vim',  'filetypes', 'ignore', 1), 'vi')
    call s:assert.equals(s:lib.get_next_match_for_rule('VIM',  'filetypes', 'ignore', 1), v:null)
endfunction

function! s:suite.get_next_match_keep_case()
    call s:assert.equals(s:lib.get_next_match_for_rule('on', 'filetypes', 'ignore', 1), 'off')
    call s:assert.equals(s:lib.get_next_match_for_rule('oN', 'filetypes', 'ignore', 1), 'off')
    call s:assert.equals(s:lib.get_next_match_for_rule('ON', 'filetypes', 'ignore', 1), 'OFF')
endfunction

function! s:suite.get_next_match_NoConfigEntry()
    setlocal filetype=ignore
    call s:assert.equals(s:lib.get_next_match_for_rule('404',   'filetypes', '',                 1), v:null)
    call s:assert.equals(s:lib.get_next_match_for_rule('404',   'filetypes', 'ignore',           1), v:null)
    call s:assert.equals(s:lib.get_next_match_for_rule('false', 'filetypes', 'no-such-filetype', 1), v:null)
endfunction

function! s:suite.get_next_value_for_buffer_spell()
    setlocal spelllang=en_GB,en
    call s:assert.equals(s:lib.get_next_value_for_buffer('INPROGRESS', 1), v:null)
endfunction
