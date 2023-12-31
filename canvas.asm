    clearCanvas:
            ld      hl, canvas
            ld      bc, 4096        ;4096 bytes to clear
    clearCanvasLoop:
            ld      (hl), 0         ;Set position to 0
            inc     hl              ;Move to next position
            dec     bc              ;Decrement counter
            ld      a, b            ;16 bit equal to 0?
            or      c               
            jr      nz, clearCanvasLoop
            ret
    
    cursorPosToCanvasAddress:
            ld      a, (cursorY)
            ld      l, a
            ld      h, 0
                                        ;Move down rows
            add     hl, hl              ;Multipy by 64 (32 rows x2 bytes ber cell)
            add     hl, hl
            add     hl, hl
            add     hl, hl
            add     hl, hl
            add     hl, hl
            add     hl, hl
                                        ;Move collum
            ld      a,(cursorX)
            ld      c,a
            ld      b, 0
            add     hl,bc
            add     hl,bc               ;Add the row position to the colum position, twice (2 bytes per cell)
            ld      bc, canvas
            add     hl, bc              ;add the canvas address to the offset, canvas address is now in hl
            ret

;Draw the canvas at a particular cursor position screen position
    drawCanvasAtCursor:
            ld      a,(cursorY)
			inc		a
            ld      b,a
            ld      a,(cursorX)
			inc		a
            ld      c,a
            call    moveCursor          ;Move the cursor to the canvas pos
            call    cursorPosToCanvasAddress
            call    drawCellToCanvas
            ret

;Draw the cursor
	drawCursor:
            ld      a,(cursorY)
			inc		a
            ld      b,a
            ld      a,(cursorX)
			inc		a
            ld      c,a
            call    moveCursor          ;Move the cursor to the canvas pos

			ld      a,(flags)           ;Is the pen down
            bit     0,a
            jr     	nz,cursorDown
			ld		hl, cursorU
            call    print
            ret
	cursorDown:
            ld		hl, cursorD
            call    print
            ret



;Draw the whole screen
    drawCanvas:
            ld		hl, home		    ;Clear screen
	        call    print
            ld      hl, canvas
            ld      b, 32              ;32 rows
    drawCol:
            push    bc
            ld      b, 64              ;64 Colums
    drawColLoop:
            call    drawCellToCanvas    ;draw cell
            djnz    drawColLoop
            call    newline             ;todo, position colum
            pop     bc
            djnz    drawCol
			call	drawCursor
            ret

;Draw cell in address HL
    drawCellToCanvas:
            ld      e, (hl)
            ld      d, 0                ;Load offset int BC
            push    hl
            ld      hl,gradient
            add     hl, de              ;offset address into gradient array
            ld      d,(hl)				;d now contains the char to print
            pop     hl
            inc     hl
	setCellColour:
			ld      a, (hl)				;Now get the colour
			ld		e,a					;

			and		00001111b			;Mask the FG colour
			cp		8					;Are we dealing with a "bright" colour
			jr		c,fgDim
			add		82
			jr		fgSetCol
	fgDim:
			add		30
	fgSetCol:
			ld		c,a
			call	setConsoleColour	;Set FG Colour
	;Now do the BG Colour
			ld		a,e					;Save it for later

			srl		a					;Move the upper 4 bits into the lower 4 bits
			srl		a
			srl		a
			srl		a
			cp		8					;Are we dealing with a "bright" colour
			jr		c,bgDim
			add		92
			jr		bgSetCol
	bgDim:
			add		40
	bgSetCol:
			ld		c,a
			call	setConsoleColour	;Set BG Colour

			ld		a,d
			rst     08H

            inc     hl
            ret

cursorD     defb    1BH,"[30;107m","`",1BH,"[0m",0
cursorU     defb    1BH,"[97;40m","`",1BH,"[0m",0