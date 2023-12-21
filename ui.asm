        printUI: 
        printGradient:
                ld      e, 1                    ;Row were printing
                ld      d, 0                    ;Char were printing
                ld      b, 14                   ;Number of rows
                ld      hl, gradient            ;chars to print
        gradRowPrint:
                ld      c,b
                ld      b, 5                   ;number of cols
                push    bc
                ld      c, 65
                ld      b, e
                call    moveCursor              ;Move the cursor
                pop     bc
        gradCharPrint:
                ld      a, (selectedChar)
                cp      d
                jr      z, gradPrintSelected
        gradCharRet:
                ld      a, (hl)
                rst     08H
                push    hl
                ld      hl, resetSelected
                call    print
                pop     hl
                inc     hl
                inc     d
                djnz    gradCharPrint
                inc     e
                ld      b,c
                djnz    gradRowPrint
                ret
        gradPrintSelected:
                push    hl
                ld      hl, selectedText
                call    print
                pop     hl
                jr      gradCharRet


selectedText    defb    1BH,"[104m",0
resetSelected   defb    1BH,"[0m",0

        
