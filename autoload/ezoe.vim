scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:highlights = '質問ではない'

function! ezoe#ezoe(...)
    if a:0 == 0 || a:1 == ""
        call ezoe#list()
    else
        call ezoe#post(a:1)
    endif
endfunction

function! ezoe#post(question)
    let res = webapi#http#get("http://ask.fm/EzoeRyou")
    let dom = webapi#html#parse(res.content)
    let token = dom.find("input").attr["value"]
    if token == ""
        return
    endif

    let ctx = {
                \ 'authenticity_token':          token,
                \ 'question["question_text"]':   a:question,
                \ 'question["force_anonymous"]': "force_anonymous",
                \ }

    let res = webapi#http#post("http://ask.fm/EzoeRyou/questions/create",
                \ ctx,
                \ { "Referer": "http://ask.fm/EzoeRyou" },
                \)

    if res.status != 200
        echoerr "error"
    endif
endfunction

function! ezoe#list()
    highlight Question cterm=NONE ctermfg=NONE ctermfg=Red   gui=NONE guifg=Red   guibg=NONE
    highlight Emphasis cterm=NONE ctermfg=NONE ctermfg=White gui=NONE guifg=White guibg=NONE
    for item in webapi#feed#parseURL('http://ask.fm/feed/profile/EzoeRyou.rss')
        echo item.link
        echohl Question
        echo "  " item.title
        echohl NONE

        if item.content =~ s:highlights
            echohl Emphasis
        endif
        echo "  " item.content
        echo "  "
        echohl NONE
    endfor
endfunction
