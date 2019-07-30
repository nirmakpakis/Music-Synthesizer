        .text
        .equ PIXEL_BUFFER, 0xC8000000
        .equ CHAR_BUFFER, 0XC9000000
		.equ PIXEL_X_MAX, 320
		.equ PIXEL_Y_MAX, 240
        .equ CHAR_X_MAX, 80
        .equ CHAR_Y_MAX, 60
        .global VGA_clear_pixelbuff_ASM
        .global VGA_clear_charbuff_ASM
        .global VGA_write_char_ASM
        .global VGA_write_byte_ASM
        .global VGA_draw_point_ASM


VGA_clear_pixelbuff_ASM:
	PUSH {R0-R10,LR}	
	LDR R3, =PIXEL_BUFFER
	MOV R0, #0		//index x
	MOV R1, #0		//index y
	MOV R2, #0		//use this register to store 0
	LDR R10, =PIXEL_X_MAX
	LDR R9, =PIXEL_Y_MAX

CHECK_X:
	ADD R4, R3, R0, LSL #1   // R4 = pixel adress + X*2

CHECK_Y:
	ADD R5, R4, R1, LSL #10		// (desired address) R5 = R4+ Y*1024 = pixel adress + x*2 + Y*1024
	STRH R2, [R5]
	
	ADD R1, R1, #1
	CMP R1, R9
	BLT CHECK_Y

	ADD R0, R0, #1
	CMP R0, R10
	MOVLT R1, #0
	BLT CHECK_X

	POP {R0-R10,LR}
	BX LR



VGA_clear_charbuff_ASM:
	PUSH {R0-R10,LR}		
	LDR R3, =CHAR_BUFFER
	MOV R0, #0			//x index
	MOV R1, #0			//y index
	MOV R2, #0			//store 0
	LDR R10, =CHAR_X_MAX
	LDR R9, =CHAR_Y_MAX

CHECK_XX:
	ADD R4, R3, R0, LSL #1  

CHECK_YY:
	ADD R5, R4, R1, LSL #7  // (desired address) R5 = R4+ Y*1024 = pixel adress + x*2 + Y*12
	STRH R2, [R5]
	ADD R1, R1, #1
	CMP R1, R9
	BLT CHECK_YY

	ADD R0, R0, #1
	CMP R0, R10
	MOVLT R1, #0
	BLT CHECK_XX

	POP {R0-R10,LR}	
	BX LR


VGA_write_char_ASM:             // r0= x r1= y r2= character 
	PUSH {R0-R10,LR}	
	LDR R10, =CHAR_X_MAX
	LDR R9, =CHAR_Y_MAX
	CMP R0, #0
	BLT END
	CMP R1, #0
	BLT END
	CMP R0, R10
	BGE END
	CMP R1, R9
	BGE END
	LDR R3, =CHAR_BUFFER
	ADD R3, R3, R0			
	ADD R3, R3, R1, LSL #7		// desired address = charbuff + x + 128*y
	STRB R2, [R3]

END:POP {R0-R10,LR}	
 	BX LR
	

VGA_write_byte_ASM:
	PUSH {R0-R10,LR}	
	LDR R10, =CHAR_X_MAX
	LDR R9, =CHAR_Y_MAX
	CMP R0, #0
	BLT END1
	CMP R1, #0
	BLT END1
	CMP R0, R10
	BGE END1
	CMP R1, R9
	BGE END1

	LDR R7, =CHAR_BUFFER
	ADD R8, R0, R1, LSL #7		// desired location = x+y*128 
	ADD R7, R7, R8				// char_budff + desired location

	MOV R5, R2
	LSR R5, R5, #4
	AND R5, R5, #0x0F		//first number
	AND R6, R2, #0x0F		//sencond number
	LDR R4, =ASCII
	ADD R9, R4, R6
	ADD R10, R4, R5

	LDRB R10, [R10]
	STRB R10, [R7]		//store the first number
	LDRB R9, [R9]
	ADD R7,R7,#1		//go one up in address
	STRB R9, [R7] 		//store the next number
END1:
	POP {R0-R10,LR}	
	BX LR




VGA_draw_point_ASM:  // r0= x r1=y r2=c
	PUSH {R0-R10,LR}	
	LDR R10, =PIXEL_X_MAX
	LDR R9, =PIXEL_Y_MAX
	CMP R0, #0
	BLT END2
	CMP R1, #0
	BLT END2
	CMP R0, R10
	BGE END2
	CMP R1, R9
	BGE END2

	LDR R3, =PIXEL_BUFFER
	ADD R3, R3, R0, LSL #1
	ADD R3, R3, R1, LSL #10
	STRH R2, [R3]

END2:
	POP {R0-R10,LR}	
	BX LR

ASCII:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46




	.end



