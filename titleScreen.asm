        drawTitleScreen: 
                ld      bc, 4096 
                ld		hl, titleScreenImage
				ld		de,	canvas
				ldir							;Copy the title screen image
		showTitleScreen:
				call	drawTitleScreenCanvas
				ld		hl,resetSelected
				call	print
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
			cp		'E'
			jp		z,main
			cp		'H'
			jp		z,help
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

	help:
			ld      bc ,0505H
			ld		de ,3F0AH 
			call	DrawBox
            ld      bc ,0606H
            ld      HL,helpMessage
            call    printAtPos
			jr      titleInput

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


loadMessage:      	defb    "(N)ew, (E)dit or (H)elp",0,0

helpMessage:		defb	"Use WASD to move your cursor (`) around the screen.",0,1
					defb	0,1
                    defb    "Use the P key to raise and lower the pen.",0,1
					defb	0,1
                    defb    "Use the F and G keys to adjust the character to print.",0,1
					defb	0,1
                    defb    "To change the pen and ink colours,",0,1
                    defb    "use the appropriate key indicated to the right of the canvas.",0,0
        
