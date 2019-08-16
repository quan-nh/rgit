Red []

git-log: does [
  log: copy ""
  call/output/wait "git log --all --date-order --pretty='%h|%p|%D' -27" log
  log-blk: split log #"^/"
  remove back tail log-blk
  log-blk
]

git-log-hash: does [
  hash: copy ""
  call/output/wait "git log --all --date-order --pretty='%h' -27" hash
  hash-blk: split hash #"^/"
  remove back tail hash-blk
  hash-blk
]

git-log-msg: does [
  msg: copy ""
  call/output/wait "git log --all --date-order --pretty='%s' -27" msg
  msg-blk: split msg #"^/"
  remove back tail msg-blk
  msg-blk
]

git-log-author: does [
  an: copy ""

  call/output/wait "git log --all --date-order --pretty='%an' -27" an
  an-blk: split an #"^/"
  remove back tail an-blk
  forall an-blk [
    short-name: copy ""
    foreach w split an-blk/1 space [
      append short-name uppercase copy/part w 1
    ]
    an-blk/1: short-name
  ]
  an-blk
]

git-log-date: does [
  ad: copy ""
  call/output/wait "git log --all --date-order --pretty='%ad' --date=human -27" ad
  ad-blk: split ad #"^/"
  remove back tail ad-blk
  ad-blk
]

git-last-commit: does [
  msg: copy ""
  call/output "git log -1 --pretty=%B" msg
  msg
]

git-status: does [
  changes-list: copy ""
  call/output "git status --porcelain" changes-list
  changes-blk: split changes-list #"^/"
  remove back tail changes-blk
  changes-blk
]

git-show: func [commit-hash] [
  changes-list: copy ""
  call/output append copy "git show --pretty='' --name-only " commit-hash changes-list
  changes-blk: split changes-list #"^/"
  remove back tail changes-blk
  changes-blk
]

git-add: func [changes-blk] [
  foreach change changes-blk [
    file: last split change #" "
    call/wait append copy "git add --force -- " file
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

git-branch: does [
  b: copy ""
  call/output/wait "git branch -a --no-color" b
  blk: split b #"^/"
  remove back tail blk
  blk
]

git-new-branch: func [branch-name] [
  call/wait append copy "git branch " branch-name
]

git-checkout-branch: func [branch-name] [
  call/console append copy "git checkout " branch-name
]

git-diff: func [file] [
  diff: copy ""
  call/output/wait append copy "git diff -- " file diff
  diff-blk: split diff #"^/"
  remove/part diff-blk 4
  remove back tail diff-blk
  diff-blk
]
