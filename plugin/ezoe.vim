if exists('g:loaded_ezoe')
    finish
endif
let g:loaded_ezoe = 1

if !exists('g:ezoe_user')
  let g:ezoe_user = "EzoeRyou"
endif

command! -nargs=? Ezoe call ezoe#ezoe(<q-args>)

augroup clear-highlight
    autocmd! clear-highlight
    autocmd BufLeave * call clearmatches()
augroup END
