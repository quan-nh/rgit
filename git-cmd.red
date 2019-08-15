Red []

git-log: does [
  log: copy ""
  call/output/wait "git log --all --date-order --pretty='%h|%p|%D|%s' -25" log
  log-blk: split log #"^/"
  remove back tail log-blk
  log-blk
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
    call/console/wait append copy "git add --force -- " file
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

git-new-branch: func [branch-name] [
  call/wait append copy "git branch --no-track " branch-name
  call append copy "git checkout " branch-name
]

git-checkout-branch: func [branch-name] [
  call append copy "git checkout " branch-name
]

git-diff: func [file] [
  diff: copy ""
  call/output/wait append copy "git diff -- " file diff
  diff-blk: split diff #"^/"
  remove/part diff-blk 4
  remove back tail diff-blk
  diff-blk
]
