        drawTitleScreen: 
                ld      bc, 4096 
                ld		hl, titleScreenImage
				ld		de,	canvas
				ldir							;Copy the title screen image
				call	drawCanvas
				ld      bc ,0604H
			    ld		de ,1A0AH 
			    ;call	DrawBox
                ld      bc ,1618H
                ld      HL,logo
                call    printAtPos
                ld      bc ,1C1DH
                ld      HL,loadMessage
                call    printAtPos

                
                ret
        
logo:
                    defb    " _________       _       _   ",0,1
                    defb    "|__  /  _ \ __ _(_)_ __ | |_ ",0,1
                    defb    "  / /| |_) / _` | | '_ \| __|",0,1
					defb    " / /_|  __/ (_| | | | | | |_ ",0,1
                    defb    "/____|_|   \__,_|_|_| |_|\__|",0,0


loadMessage:      defb    "(N)ew or (L)oad",0,0
        
