			.text
			.equ FIFO_SPACE, 0xFF203044
			.equ LEFT_DATA, 0xFF203048
			.equ RIGHT_DATA, 0xFF20304C
			.global audio_ASM

audio_ASM:
			LDR R1, =FIFO_SPACE 
			LDR R2, =LEFT_DATA 
			LDR R3, =RIGHT_DATA

			AND R7, R1, #0xFF000000 // WSLC
			CMP R7, #0    // if R4 == 0 then return 0
			BEQ RETURN_ZERO 
			AND R6, R1, #0x00FF0000 // WSRC
			CMP R6, #0 		// if R5== 0 then return 0
			BEQ RETURN_ZERO

			STR R0, [R2] // Store in Leftdata
			STR R0, [R3] // Store in RightData
			MOV R0, #1 // Return 1
			BX LR

RETURN_ZERO:	
			MOV R0, #0 // Return 0
			BX LR

			.end
