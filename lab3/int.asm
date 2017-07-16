 ; 
 ; This is an Interrupt Processing Program.
 ; User Program.
; .ORIG x3000
; LD	R6, STACKBASE	;
; AND	R1, R1, #0	; init R0
; LD	R1, ENTRANCE	;
; STI	R1, INTV	;	
; LD  R1, MASK      	; Load Read bit into R1 
; STI R1, KBSR      	; (0100 0000 0000 0000 -> bit[14]: interrupt enable bit) 
;  ;
;  ;  User program is working.

;             START       ST	R5, SaveR5	;
;  ;
; 			LD	R5, NUM7	;
; 		        JSR	ROWODD		;
; 	    LOOPONE	JSR	WORK		; Call Subroutine
; 			LEA	R0, SPACE3	;
; 			TRAP	x22		;
; 			ADD	R5, R5, #-1	;
; 			BRp	LOOPONE		;
; 			LD	R0, NEWLINE	;
; 			TRAP	x21		; Print an newline
;  ;			
; 			LD	R5, NUM6	;
; 			JSR	ROWEVE		;
; 	    LOOPTWO	LEA	R0, SPACE3	;
; 			TRAP	x22		;
; 			JSR	WORK		;
; 			ADD	R5, R5, #-1	;
; 			BRp	LOOPTWO		;
; 			LD	R0, NEWLINE	;
; 			TRAP	x21		;
; 			LD	R5, SaveR5	;
; 			BRnzp	START
;  ;
;  ; Subroutine ROWNUM
;  ;
; 	    ROWODD	ST	R7, SaveR7	;
; 			LEA	R0, ODD		;
; 			TRAP	x22
; 			LD	R7, SaveR7
; 			RET
;  ;
; 	    ROWEVE	ST	R7, SaveR7	;
; 			LEA	R0, EVE		;
; 			TRAP	x22		;
; 			LD	R7, SaveR7	;
; 			RET			;
;  ;
;  ; End the subroutine ROWODD AND ROWEVE
;  ;
;  ; The subroutine WORK
; 	    WORK	ST	R7, SaveR7	;
; 			LEA   	R0, PromptZ  	; Print the promptZ
;                         TRAP  	x22          	; and  output to the monitor
;  ;
; 			JSR	LOW		;
; 			LEA	R0, PromptY	; Print the promptY
; 			TRAP	x22		;
;  ;
; 			JSR	LOW		;
;             	     	LEA   	R0, PromptC  	; Print the PromptC
;                         TRAP  	x22          	; and output to monitor				
;  ;
; 			JSR	LOW		;
; 			LD	R7, SaveR7	;
;                         RET			; Return to caller program
;  ;  End the subroutine WORK
 ;
 ;  Low the speed
;  ;
; LOW ST	R7, StoreR7
; ST	R4, SaveR4
; AND R4, R4, #0
; AGAIN   ADD   	R4, R4, #1
;         BRnp  	AGAIN 
; LD	R4, SaveR4
; LD	R7, StoreR7
; RET
;  ;
;  ; End the low
;  ;
; STACKBASE	.FILL	x3FFF
; SaveR4	.BLKW	1
; SaveR5	.BLKW	1
; SaveR7	.BLKW	1
; StoreR7	.BLKW	1
; KBSR        .FILL 	xFE00
; MASK        .FILL 	x4000
; INTV        .FILL 	x0180
; ENTRANCE	.FILL	x1000
; NUM7	.FILL	#7
; NUM6	.FILL	#6
; ODD		.STRINGZ "ODD:"
; EVE		.STRINGZ "EVE:"
; PromptZ     .STRINGZ "Z"
; PromptY	.STRINGZ "Y"
; PromptC     .STRINGZ "C"
; SPACE3	.STRINGZ "   "
; SPACE4  .STRINGZ "    "
; JINGHAO .STRINGZ "##"
; CHENGHAO.STRINGZ "**"
; NEWLINE	.FILL	x000A
;                    .END
.ORIG x3000
	
	LD R6, pointToR
	LD R5, ISRLOC
	STI R5, VECTOR   ;vertor table
	LD R4, MASK	
	LDI R2, KBSR1
	ADD R4, R4, R2
	STI R4, KBSR1

	LD R3, CHENGHAO

MAIN1	
	LD R2, COUNTER_7
	LD R4, SPACE

MAIN2	
	ADD R0, R3, #0			
	OUT
	OUT
	LEA R7 #2
	ST R7 SaveR7
	JSR LOW

	AND R0 R0 #0
	ADD R0 R4 #0
	OUT
	OUT
	OUT
	OUT
	LEA R7 #2
	ST R7 SaveR7
	JSR LOW

	ADD R2, R2, #-1
	BRp MAIN2

	ADD R0 R3 #0
	OUT
	OUT
	LD R0 newline
	OUT
	LD R2, COUNTER_7
	LD R0, SPACE
	OUT
	OUT
	OUT
MAIN3
	ADD R0, R3, #0			
	OUT
	OUT
	LEA R7 #2
	ST R7 SaveR7
	JSR LOW
	AND R0 R0 #0
	ADD R0 R4 #0
	OUT
	OUT
	OUT
	OUT
	LEA R7 #2
	ST R7 SaveR7
	JSR LOW
	ADD R2, R2, #-1
	BRp MAIN3
	LD R0 newline
	OUT

	BRnzp MAIN1 

HALT
;Low the speed

LOW ST	R7, SaveR7
ST	R4, SaveR4
AND R4, R4, #0
AGAIN   ADD   	R4, R4, #1
        BRnp  	AGAIN 
LD	R4, SaveR4
LD	R7, SaveR7
RET

JINGHAO	.FILL x23 	; '#'
CHENGHAO .FILL x2A  ; '*'
SPACE 	.FILL x20   ; ' '
newline	.FILL	x0A ;'\n'
COUNTER_7	.FILL	#7
ISRLOC		.FILL	x1000
pointToR	.FILL 	x3000
MASK		.FILL 	x4000
VECTOR		.FILL 	x0180 ; super vertor
KBSR1		.FILL 	xFE00
SaveR7		.FILL  	X0000
SaveR4		.FILL 	X0000
.END