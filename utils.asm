    newline:			
			push 	af
			ld		a, CR
			rst 	08H
			ld		a, LF
			rst 	08H
			pop 	af
			ret



    print:  push 	af				; Preserve AF				
    printLoop:  
            ld      a,(hl)          ; Get character
            or      a               ; Is it $00 ?
            jr     	z,printret      ; Then return on terminator
            rst     08H             ; Print it
            inc     hl              ; Next Character
            jr      printLoop       ; Continue until $00

    printret:
            pop		af
			ret

;move cursor to (C,B)				
moveCursor:		
				push	HL
				push	AF
				ld		A,$1B
				rst     08H
				ld		A,'['
				rst     08H
				ld		L,B
				ld		H,0
				call	HLToDec
				ld		A,$3B
				rst     08H
				ld		L,C
				ld		H,0
				call	HLToDec
				ld		A,'f'
				rst     08H
				pop		AF
				pop		HL
				ret

;set colour c = colour				
setConsoleColour:		
				push	HL
				ld		A,$1B
				rst     08H
				ld		A,'['
				rst     08H
				ld		L,C
				ld		H,0
				call	HLToDec
				ld		A,'m'
				rst     08H
				pop		HL
				ret

;Prints	hl as decimal			
HLToDec:
				push	AF
				push	BC
				call	DispHL
				pop		BC
				pop		AF
				ret
DispHL:
				ld		bc,-10000
				call	Num1
				ld		bc,-1000
				call	Num1
				ld		bc,-100
				call	Num1
				ld		c,-10
				call	Num1
				ld		c,-1
Num1:			ld		a,'0'-1
Num2:			inc		a
				add		hl,bc
				jr		c,Num2
				sbc		hl,bc
				rst     08H
				ret

;--------Print textBlockAtPos
	;HL Start of sprite
	;C  Sprite X
	;B  Sprite Y

printAtPos:		PUSH 	AF					; Preserve AF				
printAtPosLoop: CALL	moveCursor			; Move cursor to start of line
				CALL	print				; Print Line
				INC		B
				INC		HL
				LD      A,(HL)          	; Get character
                OR      A               	; Is it $00 ?
				INC		HL
                JR      NZ,printAtPosLoop   ; Continue until $00		
				POP		AF
				RET

;------------Draw Box
;C Start X
;B Start Y

;D Width
;E Height
drawBox:
				DEC		E
				DEC		E
				CALL	moveCursor			; Move cursor to start of line
				PUSH	BC
				LD		B,D
topLineLoop:	LD		A,'#'
				RST		08H
				DJNZ	topLineLoop			;Print Top line
				DEC		D					;Remove padding for left and right bars
				DEC		D
				LD		B,E
boxBodyLoop:	LD		E,B
				POP		BC
				INC		B
				CALL	moveCursor
				PUSH	BC
				LD		A,'#'
				RST		08H
				LD		B,D
boxContentLoop:	LD		A,' '
				RST		08H
				DJNZ	boxContentLoop
				LD		A,'#'
				RST		08H
				LD		B,E
				DJNZ	boxBodyLoop
				POP		BC
				INC		B
				CALL	moveCursor			; Move cursor to start of line
				INC		D
				INC		D
				LD		B,D
bottomLineLoop:	LD		A,'#'
				RST		08H
				DJNZ	bottomLineLoop			;Print Top line
				RET