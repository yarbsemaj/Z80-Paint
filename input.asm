;Input handlers
    input:
			rst		10H                 ;Wait for a char to come in
			cp		' '
			jr		c,inputDefinedChar	;If chars are i9n rangfe ' ' to '@', we want to change the colour
			cp		'@' + 1
			jr		nc,inputDefinedChar
			jr		setColour

	inputDefinedChar:
			and     11011111b           ;lower to uppercase
			cp		'W'
			jr		z,moveUp
			cp		'A'
			jr		z,moveLeft
			cp		'S'
			jr		z,moveDown
			cp		'D'
			jr		z,moveRight
            cp      'P'
            jp      z,togglePen
            cp      'F'                 ;Move char left
            jp      z,charPickerDown
            cp      'G'                 ;Move char right
            jp      z,charPickerUp
			jr      input

	setColour:
			cp		'0'					;IF char char is greater than '0' then were setting the forground
			jr		nc, setFG
	setBG:
			sub		' '					;Normalise the char so ' '= 0 '!' = 1
			sla		a					;Shift Left, to get the number into the top 4 bits
			sla		a
			sla		a
			sla		a
			ld		b,a					;Store that result in b for later
			ld		a,(selctedColor)	;Get the curent colour
			and		00001111b			;set the curent BG colour to 0
			or		b					;set the BG colour (in the top 4 bits)
			ld		(selctedColor),a	;save the selected colour
            call    printSelectedPallet
			ret

	setFG:		
			sub		'0'					;Normalise the char, so '0' = 0 '1' = 1 etc
			ld		b,a					;Store that result in b for later
			ld		a,(selctedColor)	;Get the curent colour
			and		11110000b			;set the curent FG colour to 0
			or		b					;set the GF colour
			ld		(selctedColor),a	;save the selected colour
            call    printSelectedPallet
			ret

    moveUp:
            call    drawCanvasAtCursor
            ld      a, (cursorY)
            dec     a
            and     00011111b           ;Mask off upprt unudrf bits, this will cause the cursor to loop
            ld      (cursorY), a
            call    placeChar
            call    drawCursor
            ret

    moveDown:
            call    drawCanvasAtCursor
            ld      a, (cursorY)
            inc     a
            and     00011111b           ;Mask off upprt unudrf bits, this will cause the cursor to loop
            ld      (cursorY), a
            call    placeChar
            call    drawCursor
            ret

    moveLeft:
            call    drawCanvasAtCursor
            ld      a, (cursorX)
            dec     a
            and     00111111b           ;Mask off upprt unudrf bits, this will cause the cursor to loop
            ld      (cursorX), a
            call    placeChar
            call    drawCursor
            ret

    moveRight:
            call    drawCanvasAtCursor
            ld      a, (cursorX)
            inc     a
            and     00111111b           ;Mask off upprt unudrf bits, this will cause the cursor to loop
            ld      (cursorX), a
            call    placeChar
            call    drawCursor
            ret

    togglePen:
            ld      a,(flags)
            xor     00000001b
            ld      (flags),a
            bit     0,a
            call    nz,placeChar
            call    drawCursor
            ret    
    

    charPickerDown:
            ld      a, (selectedChar)
            or      a
            ret     z                   ;IF the char select is 0, do nothing
            dec     a                   ; elese reduce it and return
            ld      (selectedChar), a
            call    printUI
            ret

    charPickerUp:
            ld      a, (selectedChar)
            cp      69                  
            ret     z                   ;IF the char select is at the end, do nothing
            inc     a                   ; elese increase it and return
            ld      (selectedChar), a
            call    printUI
            ret

    placeChar:
            ld      a,(flags)           ;Is the pen down
            bit     0,a
            ret     z
            call    cursorPosToCanvasAddress
            ld      a, (selectedChar)
            ld      (hl), a             ;Save char
            inc     hl
            ld      a, (selctedColor)
            ld      (hl), a
            call    drawCanvasAtCursor
            ret
