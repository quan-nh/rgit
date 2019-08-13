Red [Needs: 'View]

do %git-cmd.red
do %git-graph.red

load-dir: does [
  repo-dir: request-dir
  if not none? repo-dir [
    change-dir repo-dir
    win/text: to string! repo-dir
    canvas/draw: git-graph git-log
    changes/data: git-status
  ]
]

view win: layout [
  title "rgit"

  origin 10x10 space 10x10
  button "Open" [load-dir]
  button "Pull" [git-pull]
  button "Push" [git-push]
  return
    
  canvas: base 600x360 white

  below
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

  across
  button "commit" [
    git-add staged-changes/data
    git-commit message/text
    ; cleanup
    message/text: ""
  ]
  button "commit & push" [
    git-add staged-changes/data
    git-commit message/text
    git-push
    ; cleanup
    message/text: ""
  ]
  return

  rich-text 910x300 data [i b "Git" /b font 24 red " Diff " /font blue "Here!" /i]
]
