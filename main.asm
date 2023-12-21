CR              .EQU     0DH
LF              .EQU     0AH

oldStackPointer	.EQU	89F0H		;Old Stack Location 
canvas     	    .EQU    0A000H       ;Canvas Location

	.ORG 9000H
			ld		(oldStackPointer), SP
			ld		sp,0FFFFH
            call    clearCanvas
    main:
            call    clearCanvas
    mainLoop:
            call    drawCanvas
            call    printUI
            call    input
            jp      mainLoop

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
            add     hl, bc              ;add the canvas address to the offset, canvas address is now in h;
            ret


;Input handlers
    input:
			rst		10H                 ;Wait for a char to come in
			and     11011111b           ;lower to uppercase
			cp		'W'
			jr		Z,moveUp
			cp		'A'
			jr		Z,moveLeft
			cp		'S'
			jr		Z,moveDown
			cp		'D'
			jr		Z,moveRight
            cp      'P'
            jr      Z,placeChar
            cp      'F'                 ;Move char left
            jr      Z,charPickerDown
            cp      'G'                 ;Move char right
            jr      Z,charPickerUp
			jr      input

    moveUp:
            ld      (lastDirection), a
            ld      a, (cursorY)
            dec     a
            and     00011111b           ;Mask off upprt unudrf bits, this will cause the cursor to loop
            ld      (cursorY), a
            ret

    moveDown:
            ld      (lastDirection), a
            ld      a, (cursorY)
            inc     a
            and     00011111b           ;Mask off upprt unudrf bits, this will cause the cursor to loop
            ld      (cursorY), a
            ret

    moveLeft:
            ld      (lastDirection), a
            ld      a, (cursorX)
            dec     a
            and     00111111b           ;Mask off upprt unudrf bits, this will cause the cursor to loop
            ld      (cursorX), a
            ret

    moveRight:
            ld      (lastDirection), a
            ld      a, (cursorX)
            inc     a
            and     00111111b           ;Mask off upprt unudrf bits, this will cause the cursor to loop
            ld      (cursorX), a
            ret

    placeChar:
            call    cursorPosToCanvasAddress
            ld      a, (selectedChar)
            ld      (hl), a             ;Save char
            inc     hl
            ld      a, (selctedColor)
            ld      (hl), a
            ret

    charPickerDown:
            ld      a, (selectedChar)
            or      a
            ret     z                   ;IF the char select is 0, do nithing
            dec     a                   ; elese reduce it and return
            ld      (selectedChar), a
            ret

    charPickerUp:
            ld      a, (selectedChar)
            cp      69                  
            ret     z                   ;IF the char select is at the end, do nithing
            inc     a                   ; elese increase it and return
            ld      (selectedChar), a
            ret

    ;Draw the whole screen
    drawCanvas:
            ld		hl, home		    ;Clear screen
			call	print
            ld      hl, canvas
            ld      b, 32              ;32 rows
    drawCol:
            push    bc
            ld      b, 64              ;64 Colums
    drawColLoop:
            ld      a, (hl)
            ld      e, a
            ld      d, 0                ;Load offset int BC
            push    hl
            ld      hl,gradient
            add     hl, de              ;offset address into gradient array
            ld      a,(hl)
            pop     hl
            rst     08H
            inc     hl
            inc     hl
            djnz    drawColLoop
            call    newline             ;todo, position colum
            pop     bc
            djnz    drawCol
            ret

include ui.asm
include utils.asm


home            defb   1BH,"[H",0
gradient        defb    " .'`^",34,",:;Il!i><~+_-?][}{1)(|\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$",0

cursorX         defs 1
cursorY         defs 1
selctedColor    defs 1
selectedChar    defb 0
lastDirection   defs 1