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
    call/wait append "git add --force -- " file
  ]
]

git-commit: func [msg amend?] [
  cmd: copy "git commit"
  if amend? [append cmd " --amend"]

  call/wait rejoin [cmd " -m '" msg "'"]
]

git-pull: does [
  call/wait "git pull"
]

git-push: func [force?] [
  cmd: copy "git push"
  if force? [append cmd " --force-with-lease"]

  call/wait rejoin [cmd " origin"]
]
