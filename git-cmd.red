Red []

git-pull: does [
  call/wait "git pull"
]

git-push: func [force?] [
  cmd: copy "git push"
  if force? [append cmd " --force-with-lease"]

  call/wait rejoin [cmd " origin"]
]

git-log: does [
  log: copy ""
  call/output/wait "git log --all --date-order --pretty='%h|%p|%D' -26" log
  log-blk: split log #"^/"
  remove back tail log-blk
  log-blk
]

git-log-hash: does [
  hash: copy ""
  call/output/wait "git log --all --date-order --pretty='%h' -26" hash
  hash-blk: split hash #"^/"
  remove back tail hash-blk
  insert hash-blk ""
  hash-blk
]

git-log-msg: does [
  msg: copy ""
  call/output/wait "git log --all --date-order --pretty='%s' -26" msg
  msg-blk: split msg #"^/"
  remove back tail msg-blk
  insert msg-blk "Local uncommitted changes"
  msg-blk
]

git-log-author: does [
  an: copy ""

  call/output/wait "git log --all --date-order --pretty='%an' -26" an
  an-blk: split an #"^/"
  remove back tail an-blk
  forall an-blk [
    short-name: copy ""
    foreach w split an-blk/1 space [
      append short-name uppercase copy/part w 1
    ]
    an-blk/1: short-name
  ]
  insert an-blk ""
  an-blk
]

git-log-date: does [
  ad: copy ""
  call/output/wait "git log --all --date-order --pretty='%ad' --date=human -26" ad
  ad-blk: split ad #"^/"
  remove back tail ad-blk
  insert ad-blk ""
  ad-blk
]

git-last-commit: does [
  msg: copy ""
  call/output "git log -1 --pretty=%B" msg
  msg
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
  err: copy ""
  call/error append copy "git checkout " branch-name err
  err
]

git-status: does [
  changes-list: copy ""
  call/output "git status --porcelain" changes-list
  changes-blk: split changes-list #"^/"
  remove back tail changes-blk
  changes-blk
]

git-show-commit: func [hash] [
  changes-list: copy ""
  call/output append copy "git show --pretty='' --name-only " hash changes-list
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

git-discard: func [change] [
  call append copy "git checkout " last split change #" "
]

git-diff: func [file] [
  diff: copy ""
  call/output/wait append copy "git diff -- " file diff
  diff-blk: split diff #"^/"
  remove/part diff-blk 4
  remove back tail diff-blk
  diff-blk
]

git-diff-commit: func [commit file] [
  diff: copy ""
  call/output/wait rejoin ["git show " commit " -- " file] diff
  diff-blk: split diff #"^/"
  remove/part diff-blk 10
  remove back tail diff-blk
  diff-blk
]
