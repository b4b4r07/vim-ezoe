if exists('g:loaded_ezoe')
    finish
endif
let g:loaded_ezoe = 1

command! -nargs=? Ezoe call ezoe#ezoe(<q-args>)

augroup clear-highlight
    autocmd! clear-highlight
    autocmd BufLeave * call clearmatches()
augroup END
