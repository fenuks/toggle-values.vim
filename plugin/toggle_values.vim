if exists('g:load_toggle_values') | finish | endif
let g:load_toggle_values = v:true

if !exists('g:toggle_values')
    let g:toggle_values = {}
endif

nnoremap <unique> <Plug>(ToggleValueNormal) :<C-u>call toggle_values#toggle_value_normal()<CR>
vnoremap <unique> <Plug>(ToggleValueVisual) :<C-u>call toggle_values#toggle_value_visual()<CR>
nnoremap <unique> <Plug>(ToggleValueOperator) :<C-u>call toggle_values#toggle_value_operator()<CR>
