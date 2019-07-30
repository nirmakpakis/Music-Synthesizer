#include <stdio.h>
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/VGA.h"
#include "./drivers/inc/PS2.h"
#include "./drivers/inc/AUDIO.h"

void test_char(){
	int x,y;
	char c = 70;
	for(y=0;y<=59;y++){
		for(x=0;x<=79;x++){
			VGA_write_char_ASM(x,y,c++);
		}
	}
}

void test_byte(){
	int x,y;
	char c =0;
	for(y=0;y<=59;y++){
		for(x=0;x<=79;x+=3){
			VGA_write_byte_ASM(x,y,c++);
		}
	}
}

void test_pixel(){
	int x,y;
	unsigned short colour = 0;
	for(y=0;y<=239;y++)
		for(x=0;x<=319;x++)
			VGA_draw_point_ASM(x,y,colour++);
}


void question_one(){
while(1) {								
		if(read_PB_data_ASM()== 1){						// 1st button is pressed
			if (read_slider_switches_ASM() != 0)      	// if none of the slider switch are on
				test_byte(); 							// display bytes
			else 										// if any of the slider switch is open
				test_char();							// display char
	}														
		if(read_PB_data_ASM()== 2)						// 2nd button is pressed
			test_pixel();								// display colors
		if(read_PB_data_ASM()== 4)						// 3rd button is pressed
			VGA_clear_charbuff_ASM();					// clear buffer
		if(read_PB_data_ASM()== 8)						// 4th button is pressed
			VGA_clear_pixelbuff_ASM();										
	}
}


void question_two(){
	VGA_clear_charbuff_ASM();							
	VGA_clear_pixelbuff_ASM();
    int x = 0;
    int y = 0;
	int x_range= 80;							
    int y_range= 60;
    while(1){
        char input;
        if(read_PS2_data_ASM(&input)){                // set input to the key pressed from keyboard
            VGA_write_byte_ASM(x,y,input);            // write that on the char buffer
            x=x+3;
            if(x>x_range) {                       	
                x=0;
                y++;
                if(y>y_range){
                    VGA_clear_charbuff_ASM();
                    x = 0;
                    y = 0;
                }
            }
        }
    }
}
// 48000 samples - 100 Hz wave cycle
// 1 wave cycle is 480 sample
// 240 of the are 1 and 240 of them are 0
void question_three() {
	int i = 0;
	while(1){
		for(i=0;i<240;i++){
			if(audio_ASM(0x00FFFFFF) ==0)   
				i--;
		}
		for(i=0;i<240;i++){
			if(audio_ASM(0x00000000) ==0)
				i--;
		}
	}
}



void test_char();

void test_byte();

void test_pixel();



 int main() {

question_one();
//question_two();
//question_three();
return 0;
}







