Red []

prompt-popup: function [
    "Prompts for a string.  Has OK/Cancel"
    msg [string!] "Message to display"
] [
    result: none ;-- in case user closes window with 'X'
    view/flags/options [
        title ""
        msg-text: text msg center return
        in-field: field return
        yes-btn: button "OK" [result: in-field/text unview]
        no-btn: button "Cancel" [result: false unview]
        do [
            gap: 10 ;--between OK and Cancel
            ;-- enlarge text if small
            unless msg-text/size/x > (yes-btn/size/x + no-btn/size/x + gap) [
                msg-text/size/x: yes-btn/size/x + no-btn/size/x + gap
            ]

            win-centre: (2 * msg-text/offset/x + msg-text/size/x) / 2 ;-- centre buttons
            yes-btn/offset/x: win-centre - yes-btn/size/x - (gap / 2)
            no-btn/offset/x: win-centre + (gap / 2)
            in-field/size/x: 150
            in-field/offset/x: win-centre - (in-field/size/x / 2)
        ]
    ] [modal popup] [offset: 800x70]
    result
]
