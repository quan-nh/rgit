Red [Needs: 'View]

do %git-graph.red

load-dir: does [
  repo-dir: request-dir
  if not none? repo-dir [
    win/text: to string! repo-dir
    
    change-dir repo-dir
    call/wait "git log --all --date-order --pretty='%h|%p|%D|%s' -18 --output=/tmp/git-log"
    
    changes-list: copy ""
    call/output "git status --porcelain" changes-list
    changes/data: split changes-list #"^/"
    remove back tail changes/data

    canvas/draw: git-graph read/lines %/tmp/git-log
  ]
]

view win: layout [
  title "rgit"

  origin 10x10 space 10x10
  button "Open" [load-dir]
  button "Pull"
  button "Push" [call "git push"]
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
  button "commit"
  button "commit & push" [
    foreach change staged-changes/data [
      c: split change #" "
      file: last c
      mode: first back back tail c
      switch mode [
        "M"  [call/wait append "git add " file]
        "MM" [call/wait append "git add " file]
      ]
    ]
    call/wait repend "git commit -m '" [message/text "'"]
    call/wait "git push"
  ]

  return

  rich-text 910x300 data [i b "Git" /b font 24 red " Diff " /font blue "Here!" /i]
]
