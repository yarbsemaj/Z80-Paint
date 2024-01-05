        drawTitleScreen: 
                ld      bc, 4096 
                ld		hl, titleScreenImage
				ld		de,	canvas
				ldir							;Copy the title screen image
				call	drawTitleScreenCanvas
				ld      bc ,1817H
			    ld		de ,1F09H 
			    call	DrawBox
                ld      bc ,1918H
                ld      HL,logo
                call    printAtPos
                ld      bc ,1F1BH
                ld      HL,loadMessage
                call    printAtPos
				jp		titleInput


;Input handlers
    titleInput:
			rst		10H                 ;Wait for a char to come in
			cp		' '
			and     11011111b           ;lower to uppercase
			cp		'N'
			jr		z,newImage
			cp		'L'
			jr		z,load
			cp		'H'
			cp		03h
			jr		z,exit
			jr      titleInput

	newImage:
			call	clearCanvas
			jp		main

	exit:
			ld		hl, showCursor	;Hide Cursor
			call	print
            ld		sp,(oldStackPointer)
			ret


    load:
            ld      hl, canvas
            ld      bc, 4096        ;4096 bytes to clear
    loadLoop:
            push    bc
            call	READBYTEM
			ld		(hl),a
            pop     bc
            inc     hl              ;Move to next position
            dec     bc              ;Decrement counter
            ld      a, b            ;16 bit equal to 0?
            or      c               
            jr      nz, loadLoop
			jp		main
			

        
logo:
                    defb    " _________       _       _   ",0,1
                    defb    "|__  /  _ \ __ _(_)_ __ | |_ ",0,1
                    defb    "  / /| |_) / _` | | '_ \| __|",0,1
					defb    " / /_|  __/ (_| | | | | | |_ ",0,1
                    defb    "/____|_|   \__,_|_|_| |_|\__|",0,0


loadMessage:      defb    "(N)ew, (L)oad or (H)elp",0,0
        
