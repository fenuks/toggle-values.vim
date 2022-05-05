function! s:convert_case(old, new) abort
    if s:islowercase(a:old)
        return tolower(a:new)
    elseif s:isuppercase(a:old)
        return toupper(a:new)
    else
        return a:new
    end
endfunction

function! s:islowercase(str) abort
    let l:lowercase = tolower(a:str)
    return l:lowercase ==# a:str
endfunction

function! s:isuppercase(str) abort
    let l:uppercase = toupper(a:str)
    return l:uppercase ==# a:str
endfunction

function! s:next_list_item(values, word, ignore_case, keep_case, count) abort
    let l:i = index(a:values, a:word, 0, a:ignore_case)
    if l:i ==# -1
        return v:null
    endif
    let l:length = len(a:values)
    let l:next_i = (l:i + a:count) % l:length
    let l:next = a:values[l:next_i]
    if a:keep_case
        let l:next = s:convert_case(a:word, l:next)
    endif
    return l:next
endfunction

function! s:get_next_match_for_rule(word, ruletype, rulename, count, tried_rulenames) abort
    let l:definitions = get(g:toggle_values, a:ruletype, {})
    let l:definition = get(l:definitions, a:rulename, [])
    let l:rules = l:definition
    let l:extend = ['']
    let l:definition_ignore_case = v:false
    let l:definition_keep_case = v:false
    if type(l:definition) ==# v:t_dict
        let l:definition_ignore_case = get(l:definition, 'ignore_case', v:false)
        let l:rules = get(l:definition, 'definitions', [])
        let l:extend = get(l:definition, 'extend', [''])
        let l:definition_keep_case = get(l:definition, 'keep_case', v:false)
    endif
    for l:rule in l:rules
        if type(l:rule) ==# v:t_dict
            let l:rule_ignore_case = get(l:rule, 'ignore_case', l:definition_ignore_case)
            let l:rule_keep_case = get(l:rule, 'keep_case', l:definition_keep_case)
            let l:values = get(l:rule, 'values', [])
            let l:matching_word = s:next_list_item(l:values, a:word, l:rule_ignore_case, l:rule_keep_case, a:count)
        else
            let l:matching_word = s:next_list_item(l:rule, a:word, l:definition_ignore_case, l:definition_keep_case, a:count)
        endif
        if l:matching_word !=# v:null
            return l:matching_word
        endif
    endfor
    for l:extended_rulename in l:extend
        if index(a:tried_rulenames, l:extended_rulename) != -1
          continue
        endif
        call add(a:tried_rulenames, l:extended_rulename)
        return s:get_next_match_for_rule(a:word, a:ruletype, l:extended_rulename, a:count, a:tried_rulenames)
    endfor
    return v:null
endfunction

function s:get_marks_text(left, right) abort
    let [l:line_start, l:column_start] = getpos("'" . a:left)[1:2]
    let [l:line_end, l:column_end] = getpos("'". a:right)[1:2]
    let l:lines = getline(line_start, line_end)
    if len(l:lines) == 0
        return ''
    endif

    let l:lines[-1] = l:lines[-1][: l:column_end - 1]
    let l:lines[0] = l:lines[0][l:column_start - 1:]
    return join(l:lines, "\n")
endfunction

function! s:split_at(text, separator) abort
  if a:separator ==# '.'
    return split(a:text, '\.')
  end
  return split(a:text, a:separator)
endfunction

function! s:get_next_value_for_ruleset(value, ruletype, rulekey, separator, count) abort
    let l:next_value = s:get_next_match_for_rule(a:value, a:ruletype, a:rulekey, a:count, [])
    if l:next_value ==# v:null && stridx(a:rulekey, a:separator) !=# -1
        for l:subrulekey in s:split_at(a:rulekey, a:separator)
            let l:next_value = s:get_next_match_for_rule(a:value, a:ruletype, l:subrulekey, a:count, [])
            if l:next_value !=# v:null
                return l:next_value
            endif
        endfor
    endif
    return l:next_value
endfunction

function! s:get_next_value_for_buffer(value, count) abort
    if a:value ==# ''
        return v:null
    end
    let l:next_value = s:get_next_value_for_ruleset(a:value, 'filetypes', &filetype, '.', a:count)
    if l:next_value ==# v:null
        let l:next_value = s:get_next_value_for_ruleset(a:value, 'languages', &spelllang, ',', a:count)
    endif
    return l:next_value
endfunction

" PUBLIC FUNCTIONS
function! toggle_values#toggle_value_normal() abort
    let l:value_at_cursor = expand('<cword>')
    let l:next_value = s:get_next_value_for_buffer(l:value_at_cursor, v:count1)
    if l:next_value != v:null
        execute 'normal ciw' . l:next_value
    else
        echo 'No value found for "' . l:value_at_cursor . '"'
    end
endfunction

function! toggle_values#toggle_value_visual() abort
    let l:selected_value = s:get_marks_text('<', '>')
    let l:next_value = s:get_next_value_for_buffer(l:selected_value, v:count1)
    if l:next_value != v:null
        execute 'normal! gvc' . l:next_value
        normal! `[v`]h
    else
        echo 'No value found for "' . l:selected_value . '"'
    end
endfunction

function! toggle_values#toggle_value_operator() abort
    let s:count = v:count1
    set operatorfunc=toggle_values#operator
    call feedkeys('g@')
endfunction

function! toggle_values#operator(type) abort
    let l:selected_value = s:get_marks_text('[', ']')
    let l:next_value = s:get_next_value_for_buffer(l:selected_value, s:count)
    if l:next_value != v:null
        execute 'normal! `[v`]c' . l:next_value
    else
        echo 'No value found for "' . l:selected_value . '"'
    end
endfunction
