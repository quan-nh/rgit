Red [Needs: 'View]

#include %git-cmd.red
#include %git-diff.red
#include %git-graph.red
#include %dialogs.red

hashes: copy []

load-dir: does [
  repo-dir: request-dir
  if not none? repo-dir [
    change-dir repo-dir
    win/text: to string! repo-dir
    load-repo  
  ]
]

load-repo: does [
  canvas/draw: git-graph/draw-graph git-log
  hashes: git-log-hash
  msg-tlf/data: git-log-msg msg-tlf/selected: 1
  author-tlf/data: git-log-author
  date-tlf/data: git-log-date
  branches-tlf/data: git-branch
  changes/data: git-status
  clear staged-changes/data
  clear message/text
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
 
  panel [
    origin 0x0 space 0x0
    canvas: base 180x510 white
    msg-tlf: text-list 300x510 no-border data [] [
      either empty? hash: pick hashes msg-tlf/selected [
        changes/data: git-status
        clear staged-changes/data
      ] [
        staged-changes/data: git-show-commit hash
        clear changes/data
      ]      
    ]
    author-tlf: text-list 30x510 no-border data []
    date-tlf: text-list 120x510 no-border data []
  ]
  return

  panel [
    origin 0x0
    text "Branches"
    button "+ branch" [
      if branch-name: prompt-popup "Branch Name:" [
        git-new-branch branch-name
        git-checkout-branch branch-name
        load-repo
      ]
    ]
    button "+ feature" [
      if branch-name: prompt-popup "Feature Branch Name:" [
        branch-name: append copy "feature/" branch-name
        git-new-branch branch-name
        git-checkout-branch branch-name
        load-repo
      ]
    ]
  ]
  branches-tlf: text-list 270x100 data []
  on-dbl-click [
    branch-name: pick branches-tlf/data branches-tlf/selected
    remove/part branch-name 2
    err: git-checkout-branch branch-name
    either find err "Aborting" [
      alert-popup err
    ] [load-repo]
  ]
  
  space 10x10
  text "Staged Changes"
  staged-changes: text-list 270x100 data [] [
    either msg-tlf/selected = 1 [
      diff-rtf/draw: diff-layout git-diff pick staged-changes/data staged-changes/selected
    ] [
      diff-rtf/draw: diff-layout git-diff-commit pick hashes msg-tlf/selected pick staged-changes/data staged-changes/selected
    ]
    
  ]
  on-dbl-click [
    append changes/data pick staged-changes/data staged-changes/selected
    remove at staged-changes/data staged-changes/selected
    diff-rtf/draw: none
  ]

  panel [
    origin 0x0
    text "Changes"
    button "Discard" [
      if positive? changes/selected [
        git-discard pick changes/data changes/selected
        remove at changes/data changes/selected
        diff-rtf/draw: none
      ]
    ]
  ]
  space 10x0
  changes: text-list 270x100 data [] [
    diff-rtf/draw: diff-layout git-diff pick changes/data changes/selected
  ]
  on-dbl-click [
    append staged-changes/data pick changes/data changes/selected
    remove at changes/data changes/selected
    diff-rtf/draw: none
  ]

  space 10x10
  message: area 270x50

  amend: check "Amend last commit" 236.236.236 [
    if all [face/data empty? message/text] [
      message/text: git-last-commit
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

  diff-rtf: rich-text 910x300 focus
  on-key [
    switch event/key [
      #"^O" [load-dir]
      #"^R" [git-pull load-repo]
    ]
  ]
]
