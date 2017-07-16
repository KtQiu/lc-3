.ORIG x3000
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0 ; init the data in order to work continuously
DATA	.BLKW	#50 x0000		; store the input data
BASE	.FILL	x4000			; the node which is gived to search
START	LEA R0 PROMPT    ; print the sentence "Type a name and press Enter"
		PUTS
GETCHAR	GETC		;get char one by one
		OUT	
		ADD R2 R0 #-10   ; if the R0 is '\n', this means the input part is over
		BRz SKIP
						  ; load the input data
		LEA R2 DATA       ; R2 is the first address of the inputed name
		LD R1 LEN          
		ADD R2 R2 R1	; load the R1 + R2 as the loaction 
						; of the char which is inputed right now
		STR R0 R2 #0	; store the inputed char	
		ADD R2 R1 #1		
		ST R2  LEN		; renew the length	
		BRnzp GETCHAR

SKIP	LDI R2 BASE		;Start check
		ADD R2 R2 #0	; turn to the next node
		BRz	nodeOver	;no one needed to prosessed 
		LEA R7 #3	
		ST R7 SAVE7
		LEA R4 SEARCH
		JMP R4
		BRnzp SKIP
nodeOver	LD R2 isNone  ; check if at least one name is satisfy
		BRnp EXIT      ; isNone == 0 that means found the name
						; otherwise we need to print NOTFOUND
		LEA R0 NOTFOUND
		PUTS;TRAP x22
EXIT	HALT
;================search part =====================================
SEARCH	AND R1 R1 0
		ST  R1 firstName	;init
		ADD R1 R2 #2	; goto the third element of the R1
		LDR R1 R1 #0	
		LEA R5  #2		
		LEA R4 isMatch
		JMP R4
		LD R4 firstName ; check whether the firstname is satisfy
						; if firstname is satisfy (not zero)
						; we will ignore the last name check
		BRnp notCheckLastName
		ADD R1 R2 #3	; goto check lastname
		LDR R1 R1 #0	
		LEA R5    #2			
		LEA R4 isMatch
		JMP R4
		; goto the next node (Turn to BASE's next address)
notCheckLastName	
		LD R3 BASE
		LDR R3 R3 #0 ; R3 added itself (or we can say go to the next step
		ST R3 BASE   ; renew BASE 
		LD R7 SAVE7
		RET
; ====================isMatch part codes==========================
isMatch 		ST R5 SAVE5			
				LEA R4	DATA		;load R4 as the address of the data inputed 
matchLoop		LDR R3 R1 0			;R3 is the given data's(firstname or lastname) first alphabet
				BRnp notOver
				BRz checkOver		; if the first name is checked over
									; turn to judge the other is over or not 			
notOver			LDR R5 R4 0
				NOT R5 R5
				ADD R5 R5 #1    ; do nagetive R5
				ADD R3 R3 R5    
				BRnp quit       ;if R3 != R5 then not match and exit
				ADD R1 R1 #1	; otherwise turn to judge the next alphabet
				ADD R4 R4 #1
				BRnzp matchLoop
checkOver		LDR R5 R4 0		;load R5 as the first alphabet of input
				BRz isSame      ; if the other is also checked over 
								; the name is the identical  
				BRnp quit       ; else the two strings are destinguish
isSame			AND R4 R4 0		; two stings are the same
				ADD R4 R4 1
				ST R4 isNone
				ST R4 firstName
				LEA R3 printInformation
				JMP R3
				BRnzp quit
quit			LD R5 SAVE5    ; load the initial R5 sothat we can JMP back
				JMP R5     
;======================print part codes======================
printInformation	
			 		; print the result using the required format		
	
	ADD R2 R2 #1
	LDR R0 R2 #0
	PUTS
	LD R1 space
	ADD R0 R1 #0
	OUT
	ADD R2 R2 #1
	LDR R0 R2 #0
	PUTS
	LD R1 space
	ADD R0 R1 #0
	OUT		
	ADD R2 R2 #1
	LDR R0 R2 #0
	PUTS
	LD R1 changeLine
	ADD R0 R1 #0
	OUT			
	BRnzp quit
;==============================================================
PROMPT	.STRINGZ "Type a name and press Enter:"		
NOTFOUND	.STRINGZ "No Entry"
SAVE7	.FILL 	x0000
SAVE5	.FILL 	x0000
LEN		.FILL	x0000	
isNone	.FILL	x0000	; judge whethe needed to print NOTFOUND
firstName	.FILL	x0000	;if firstName is not zero, lastName will not be checked.
isCheck	.FILL 	x0000	; the node need not to check
changeLine			.FILL x0A     ;'\n'           
space				.FILL x20 
.END	