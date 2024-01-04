CR              .EQU     0DH
LF              .EQU     0AH

oldStackPointer	.EQU	89F0H		;Old Stack Location 
canvas     	    .EQU    0D000H       ;Canvas Location

	.ORG 9000H
			ld		(oldStackPointer), SP
			ld		sp,0FFFFH
			ld		hl, hideCursor	;Hide Cursor
			call	print
			call drawTitleScreen
            ;call    clearCanvas
    main:
            ;call    drawCanvas
            ;call    printUI
    mainLoop:
            call    input
            jp      mainLoop

include input.asm
include canvas.asm
include ui.asm
include utils.asm
include titleScreen.asm


	titleScreenImage:
		incbin "IMAGE.bin"


home            defb   	1BH,"[H",0
hideCursor	  	defb	1BH,"[?25l",0
gradient        defb    " .'`^",34,",:;Il!i><~+_-?][}{1)(|\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$",0

cursorX         defb 0
cursorY         defb 0
selctedColor    defb 01110111b
selectedChar    defb 0
flags			defb 0	