        printUI: 
                call    printGradient
                call    printFGColourPallet
				call    printBGColourPallet
				call	printSelectedPallet
                ret
;Forground
        printFGColourPallet:
                ld      c, 65
                ld      b, 17
                call    moveCursor              ;Move the cursor
                ld      hl,fgLable
                call    print
                ld      e, 18                   ;Row were printing
                ld      a, 48                   ;Char were printing
				ld      b, 4                   	;Number of rows
		printFGPlaletRow:
                ld      c,b
                ld      b, 4                   	;number of cols
                push    bc
                ld      c, 65
                ld      b, e
                call    moveCursor              ;Move the cursor
                pop     bc
		printFGPlaletChar:
				push	bc
				push	af
				cp		56						;Are we dealing with bright or dim charicters
				jr		c, fgDark
				add		34
				jr		fgPalletColPrint
		fgDark:
				sub		18
		fgPalletColPrint:
				ld		c,a
				call	setConsoleColour
				pop		af
                rst     08H						;Print char
				pop		bc
				inc		a
				djnz    printFGPlaletChar
				inc     e
                ld      b,c
                djnz    printFGPlaletRow
                ret
;Background
		printBGColourPallet:
                ld      c, 65
                ld      b, 23
                call    moveCursor              ;Move the cursor
                ld      hl,bgLable
                call    print
                ld      e, 24                   ;Row were printing
                ld      a, 32                   ;Char were printing
				ld      b, 4                   	;Number of rows
		printBGPlaletRow:
                ld      c,b
                ld      b, 4                   	;number of cols
                push    bc
                ld      c, 65
                ld      b, e
                call    moveCursor              ;Move the cursor
                pop     bc
		printBGPlaletChar:
				push	bc
				push	af
				cp		40						;Are we dealing with bright or dim charicters
				jr		c, bgDark
				add		50
				jr		bgPalletColPrint
		bgDark:
				sub		2
		bgPalletColPrint:
				ld		c,a
				call	setConsoleColour
				pop		af
                rst     08H						;Print char
				pop		bc
				inc		a
				djnz    printBGPlaletChar
				inc     e
                ld      b,c
                djnz    printBGPlaletRow
                ret


        printGradient:
                ld      c, 65
                ld      b, 1
                call    moveCursor              ;Move the cursor
                ld      hl,palletLable
                call    print
                ld      e, 2                    ;Row were printing
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

	printSelectedPallet:
			ld      c, 66
            ld      b, 29
            call    moveCursor          ;Move the cursor

			ld      a, (selctedColor)	;Now get the colour

			and		00001111b			;Mask the FG colour
			cp		8					;Are we dealing with a "bright" colour
			jr		c,printSelectedPalletFGDim
			add		92
			jr		printSelectedPalletFGDimSetCol
	printSelectedPalletFGDim:
			add		40
	printSelectedPalletFGDimSetCol:
			ld		c,a
			call	setConsoleColour	;Set FG Colour
			ld		a,' '
			rst     08H

	;Now do the BG Colour
			ld      a, (selctedColor)	;Now get the colour
			srl		a					;Move the upper 4 bits into the lower 4 bits
			srl		a
			srl		a
			srl		a
			cp		8					;Are we dealing with a "bright" colour
			jr		c,printSelectedPalletBGDim
			add		92
			jr		printSelectedPalletBGSetCol
	printSelectedPalletBGDim:
			add		40
	printSelectedPalletBGSetCol:
			ld		c,a
			call	setConsoleColour	;Set BG Colour
			ld		a,' '
			rst     08H
			ld		hl,resetSelected
			call	print
			ret

selectedText    defb    1BH,"[104m",0
resetSelected   defb    1BH,"[0m",0

palletLable     defb    1BH,"[30;107m","Pen",1BH,"[0m",0
fgLable         defb    1BH,"[30;107m","Ink",1BH,"[0m",0
bgLable         defb    1BH,"[30;107m","Paper",1BH,"[0m",0

        
