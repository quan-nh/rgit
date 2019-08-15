Red []

git-log: does [
  call/wait "git log --all --date-order --pretty='%h|%p|%D|%s' -25 --output=/tmp/git-log"
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
    cmd: copy "git add --force -- "
    append cmd last split change #" "
    call/console/wait cmd
  ]
]

git-commit: func [msg amend?] [
  cmd: copy "git commit"
  if amend? [append cmd " --amend"]

  call/console/wait rejoin [cmd " -m '" msg "'"]
]

git-pull: does [
  call/wait "git pull"
]

git-push: func [force?] [
  cmd: copy "git push"
  if force? [append cmd " --force-with-lease"]

  call/console/wait rejoin [cmd " origin"]
]

git-branch: does [
  b: copy ""
  call/output/wait "git branch -a --no-color" b
  blk: split b #"^/"
  remove back tail blk

  blk
]
