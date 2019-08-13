Red []

git-log: does [
  call/wait "git log --all --date-order --pretty='%h|%p|%D|%s' -18 --output=/tmp/git-log"
  read/lines %/tmp/git-log
]

git-status: does [
  changes-list: copy ""
  call/output "git status --porcelain" changes-list
  changes-blk: split changes-list #"^/"
  remove back tail changes-blk

  changes-blk
]

git-add: func [changes-blk] [
  foreach change changes-blk [
    file: last split change #" "
    call/wait append "git add " file
  ]
]

git-commit: func [msg] [
  call/wait repend "git commit -m '" [msg "'"]
]

git-pull: does [
  call "git pull"
]

git-push: does [
  call "git push"
]
