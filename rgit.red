Red [Needs: 'View]

#include %git-cmd.red
#include %git-diff.red
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
  branches-tlf/data: git-branch
  changes/data: git-status
  clear staged-changes/data
  message/text: ""
  amend/data: false
  diff-rtf/draw: none
]

view win: layout [
  title "rgit"
  
  below
  space 10x0
  panel [
    origin 0x0
    button "Open" [load-dir]
    button "Pull" [git-pull load-repo]
    button "Push" [git-push load-repo]
  ]
 
  canvas: base 600x500 white focus
  on-key [
    switch event/key [
      #"^O" [load-dir]
      #"^R" [git-pull load-repo]
    ]
  ]
  return

  space 10x10
  text "Branches"
  branches-tlf: text-list 300x100 data []
  
  text "Staged Changes"
  staged-changes: text-list 300x100 data [] [
    diff-rtf/draw: diff-layout git-diff pick staged-changes/data staged-changes/selected
  ]
  on-dbl-click [
    append changes/data pick staged-changes/data staged-changes/selected
    remove at staged-changes/data staged-changes/selected
  ]

  text "Changes"
  changes: text-list 300x100 data [] [
    diff-rtf/draw: diff-layout git-diff pick changes/data changes/selected
  ]
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
  ]
  button "commit & push" [
    uppercase/part message/text 1
    git-add staged-changes/data
    git-commit message/text amend/data
    git-push amend/data
    ; reload
    load-repo
  ]
  return

  diff-rtf: rich-text 910x300
]
