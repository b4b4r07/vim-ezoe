scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

    highlight Question cterm=NONE ctermfg=NONE ctermfg=Red   gui=NONE guifg=Red   guibg=NONE
    highlight Emphasis cterm=NONE ctermfg=NONE ctermfg=White gui=NONE guifg=White guibg=NONE
let s:highlights = '質問ではない。\?\|不\?自由'

function! ezoe#ezoe(...)
    if a:0 == 0 || a:1 == ""
        call ezoe#list()
    else
        call ezoe#post(a:1)
    endif
endfunction

function! ezoe#post(question)
    let res = webapi#http#get(printf("http://ask.fm/%s", g:ezoe_user))
    let dom = webapi#html#parse(res.content)
    let token = dom.find("input").attr["value"]
    if token == ""
        echoerr "token not set"
        return
    endif

    let ctx = {
                \ 'authenticity_token':        token,
                \ 'question[question_text]':   a:question,
                \ 'question[force_anonymous]': "force_anonymous",
                \ }

    let res = webapi#http#post(printf("http://ask.fm/%s/questions/create", g:ezoe_user),
                \ ctx,
                \ { "Referer": printf("http://ask.fm/%s", g:ezoe_user) },
                \)

    if res.status != 200
        echoerr "error"
    endif
endfunction

function! ezoe#list()
    hide enew
    setlocal buftype=nofile nowrap nolist nonumber bufhidden=wipe
    setlocal modifiable nocursorline nocursorcolumn
    for item in webapi#feed#parseURL(printf("http://ask.fm/feed/profile/%s.rss", g:ezoe_user))
        call matchadd("Emphasis", s:highlights)
        call matchaddpos("Question", [ line('.') + 1 ])
        call append(0, item.link)
        call append(1, "  " . item.title)
        call append(2, "  " . item.content)
        call append(3, "  ")
    endfor
    setlocal nomodifiable
endfunction
