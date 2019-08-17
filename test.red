Red [need: 'view]

view [
    panel 320x100 white [
        origin 4x4 space 0x0 rt: rich-text 300 "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?" 
        pad 0x-4 scroller 16x100 [
            rt/offset/y: 0 - to-integer max 0 min rt/size/y - face/size/y face/data / face/steps * lh
        ] on-created [
            face/steps: 1.0 / (1.0 * rt/size/y / (lh: rich-text/line-height? rt 1)) face/selected: 1.0 * face/size/y / rt/size/y
]]]
