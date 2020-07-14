                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
__Vectors
				DCD  0x20001000     ; stack pointer value when stack is empty
				DCD  Reset_Handler  ; reset vector

				AREA	myCode, CODE, READONLY
				ENTRY
Reset_Handler
	
			; write your code here
			; Roozbeh Bazargani 9523012
			
			
			; INITIALIZATION
			;MOV r13, #0x20001000 ; stack pointer value when stack is empty (type: ed)
			
			; START POINT
			LDR r0, rownum ; r0 := M[rownum] = a
			ADR r1, rows ; r1 := rows
			LDR r2, [r1, #4]! ; r2 := row2
			MOV r3, #1 ; r3 := j
			ADD r4, r3, r2 ; r4 := start point
			ADD r5, r0, #2 ; r5 := Num present point (start point)
			SUB r6, r0, #1
			MUL r6, r0, r6
			SUB r6, r6, #1 ; r6 = a*(a-1) - 1
			MOV r7, #0 ; r7 Entered direction
			MOV r12, #0 ; size of stack (global)
			
			; LEFT_HAND 
LEFT_HAND	teq r5, r6
			STREQ r5, [r13], #-4 ; stack push
			ADDEQ r12, r12, #1 ; increment size of stack
			BEQ FIND_ROUTE ; searching ends
			MOV r9, r7
ZERO		teq r7, #0 ; CASE r7 = 0
			BNE ONE
			
			ADD r3, r3, #1
			ADD r4, r3, r2
			LDRB r8, [r4]
			teq r8, #1 ; neighbour byte is one?
			SUBNE r3, r3, #1
			MOVNE r7, #1 ; next neighbour
			STREQ r5, [r13], #-4 ; stack push
			ADDEQ r12, r12, #1 ; increment size of stack
			MOVEQ r7, #3 ; next point
			ADDEQ r5, r5, #1 ; Num of next point
			BEQ LEFT_HAND
			teq r7, r9
			BEQ BACK_TRACK
ONE			teq r7, #1 ; CASE r7 = 1
			BNE TWO
			
			LDR r2, [r1, #4]!
			ADD r4, r3, r2
			LDRB r8, [r4]
			teq r8, #1 ; neighbour byte is one?
			LDRNE r2, [r1, #-4]!
			MOVNE r7, #2 ; next neighbour
			STREQ r5, [r13], #-4 ; stack push
			ADDEQ r12, r12, #1 ; increment size of stack
			MOVEQ r7, #0 ; next point
			ADDEQ r5, r5, r0 ; Num of next point
			BEQ LEFT_HAND
			teq r7, r9
			BEQ BACK_TRACK
TWO			teq r7, #2 ; CASE r7 = 2
			BNE THREE
			
			SUB r3, r3, #1
			ADD r4, r3, r2
			LDRB r8, [r4]
			teq r8, #1 ; neighbour byte is one?
			ADDNE r3, r3, #1
			MOVNE r7, #3 ; next neighbour
			STREQ r5, [r13], #-4 ; stack push
			ADDEQ r12, r12, #1 ; increment size of stack
			MOVEQ r7, #1 ; next point
			SUBEQ r5, r5, #1 ; Num of next point
			BEQ LEFT_HAND
			teq r7, r9
			BEQ BACK_TRACK
THREE		teq r7, #3 ; CASE r7 = 3
			BNE BACK_TRACK
			
			LDR r2, [r1, #-4]!
			ADD r4, r3, r2
			LDRB r8, [r4]
			teq r8, #1 ; neighbour byte is one?
			LDRNE r2, [r1, #4]!
			MOVNE r7, #0 ; next neighbour
			STREQ r5, [r13], #-4 ; stack push
			ADDEQ r12, r12, #1 ; increment size of stack
			MOVEQ r7, #2 ; next point
			SUBEQ r5, r5, r0 ; Num of next point
			BEQ LEFT_HAND
			teq r7, r9
			BNE ZERO
BACK_TRACK	ADD r13, r13, #4 ; stack pop
			SUBEQ r12, r12, #1 ; decrement size of stack
			b LEFT_HAND
			
			
			; FIND ROUTE
FIND_ROUTE	LDR r2, proute ; start point
			MOV r0, #0 ; pointer
			MOV r1, #0 ; length of route
			
			
LOAD_STACK	teq r12, #0
			BEQ SWAP
			
			LDR r3, [r13, #4]! ; r3 = stack data
			SUB r12, r12, #1 ; decrement size of stack
LOOP		teq r0, r1
			STREQ r3, [r2, r0, lsl #2]
			ADDEQ r1, r1, #1
			MOVEQ r0, #0
			BEQ LOAD_STACK
			
			LDR r4, [r2, r0, lsl #2] ; r4 = check data
			teq r4, r3
			MOVEQ r1, r0 ; deleting next datas
			BEQ LOAD_STACK
			
			ADD r0, r0, #1
			B LOOP
			
			; SWAP
SWAP		SUB r1, r1, #1 ; tail
			MOV r0, #0 ; head
LOOP1		LDR r3, [r2, r0, lsl #2] ; r3 = first data
			LDR r4, [r2, r1, lsl #2] ; r4 = second data
			STR r4, [r2, r0, lsl #2]
			STR r3, [r2, r1, lsl #2]
			ADD r0, r0, #1
			SUB r1, r1, #1
			CMP r1, r0
			BHI LOOP1
			
endloop		B		endloop

;rownum		DCD		8
;rows		DCD		row1,row2,row3,row4,row5,row6,row7,row8
;row1		DCB		0, 0, 0, 0, 0, 0, 0, 0
;row2		DCB		0, 1, 0, 0, 1, 1, 1, 0
;row3		DCB		0, 1, 1, 1, 1, 0, 1, 0
;row4		DCB		0, 0, 1, 0, 1, 0, 1, 0
;row5		DCB		0, 1, 1, 1, 0, 1, 1, 0
;row6		DCB		0, 0, 1, 1, 0, 1, 0, 0
;row7		DCB		0, 0, 1, 0, 0, 1, 1, 0
;row8		DCB		0, 0, 0, 0, 0, 0, 0, 0


;rownum		DCD		12
;rows		DCD		row1,row2,row3,row4,row5,row6,row7,row8,row9,row10,row11,row12
;row1		DCB		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;row2		DCB		0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0
;row3		DCB		0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0
;row4		DCB		0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0
;row5		DCB		0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0
;row6		DCB		0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0
;row7		DCB		0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0
;row8		DCB		0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0
;row9		DCB		0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0
;row10		DCB		0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0
;row11		DCB		0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0
;row12		DCB		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

rownum		DCD		12
rows		DCD		row1,row2,row3,row4,row5,row6,row7,row8,row9,row10,row11,row12
row1		DCB		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
row2		DCB		0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0
row3		DCB		0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0
row4		DCB		0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0
row5		DCB		0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0
row6		DCB		0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0
row7		DCB		0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0
row8		DCB		0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0
row9		DCB		0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0
row10		DCB		0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0
row11		DCB		0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0
row12		DCB		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


proute		DCD		route			

			AREA	myData, DATA, READWRITE	
			
route		DCD		0
			
			END
