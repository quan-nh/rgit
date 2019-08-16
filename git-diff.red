Red []

diff-layout: func [diff] [
  rtf: copy []
  i: 0 step: 18
  foreach line diff [
    layout: none
    switch/default copy/part line 1 [
      "@" [layout: rtd-layout reduce [73.196.208 line] layout/size/x: 900]
      "+"  [layout: rtd-layout reduce [72.196.61 line] layout/size/x: 900]
      "-"  [layout: rtd-layout reduce [211.74.53 line] layout/size/x: 900]
    ] [layout: line]

    append rtf reduce ['text as-pair 10 i * step + 10 layout]
    i: i + 1
  ]
  rtf
]
