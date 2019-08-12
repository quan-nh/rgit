Red [Needs: 'View]

do %git-graph.red

load-dir: does [
    repo-dir: request-dir
    if not none? repo-dir [
        win/text: to string! repo-dir
        load-git-history repo-dir
        canvas/draw: git-graph read/lines %/tmp/git-log
    ]
]

load-git-history: func [dir] [
    change-dir dir
    call/wait "git log --all --date-order --pretty='%h|%p|%D|%s' -30 --output=/tmp/git-log"
]

view win: layout [
    title "rgit"
    origin 10x10 space 10x10
    button "Load" [load-dir]
    button "Quit" [Quit]
    return
    canvas: base 800x600 white
]
