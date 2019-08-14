Red [Needs: 'View]

#include %git-cmd.red
#include %git-graph.red

graph: copy []
git-head: copy []

load-dir: does [
  repo-dir: request-dir
  if not none? repo-dir [
    change-dir repo-dir
    win/text: to string! repo-dir
    load-repo  
  ]
]

load-repo: does [
  set [graph git-head] git-graph git-log
  canvas/draw: graph
  changes/data: git-status
  clear staged-changes/data
]

view win: layout [
  title "rgit"
    
  canvas: base 600x360 white focus
  on-key [
    case [
      all [event/key = #"^O" event/ctrl?] [load-dir]
      all [event/key = #"^P" event/ctrl?] [git-pull load-repo]
    ]
  ]

  below
  text "Branches"
  branches: text-list 300x100 data ["feature/branch"
"master"
"remotes/origin/master"]
  
  text "Staged Changes"
  staged-changes: text-list 300x100 data []
  on-dbl-click [
    append changes/data pick staged-changes/data staged-changes/selected
    remove at staged-changes/data staged-changes/selected
  ]

  text "Changes"
  changes: text-list 300x100 data []
  on-dbl-click [
    append staged-changes/data pick changes/data changes/selected
    remove at changes/data changes/selected
  ]

  message: area 300x50

  amend: check "Amend last commit" 236.236.236 [
    if all [face/data empty? message/text git-head/2] [
      message/text: git-head/2
    ]
  ]

  across
  button "commit" [
    uppercase/part message/text 1
    git-add staged-changes/data
    git-commit message/text amend/data
    ; reload
    load-repo
    message/text: ""
    amend/data: false
  ]
  button "commit & push" [
    uppercase/part message/text 1
    git-add staged-changes/data
    git-commit message/text amend/data
    git-push amend/data
    ; reload
    load-repo
    message/text: ""
    amend/data: false
  ]
  return

  rich-text 910x300 data [i b "Git" /b font 24 red " Diff " /font blue "Here!" /i]
]
