# Music-Synthesizer

ECSE 324 Lab:
* Nihal Irmak Pakis
* Abdallah Basha 
* Fouad El Bitar

## VGA
### Description:
 * In the main function we check which push button is pressed. If the first button is
pressed then we check if any of the switches are on. If any of them is on, then we write bytes, else we write characters on the screen. If the second push button is pressed display pixels, using test_pixel function. Test_pixel function inputs different values of color in each iteration. Therefore each address stores different color until the maximum point in the range of colors. Then it starts displaying the colors again, starting from the first color. If the 3rd push button is displayed, it cleans the character buffer. And if the 4th one is pressed, it clears the pixel buffer.
 * Clearing the the buffers involves accessing each address in the buffers and setting them to 0. In order to access to desired address, we first iterate through the y axis. Unit change in y axis, changes the address location by 1024 in pixel buffer and 128 in character buffer. Which corresponds to 2^10 and 2^7. Unit change in x axis, changes the address location by 2 in pixel buffer and 1 in character buffer. Which corresponds to 2^0 and 2^1. (all the numbers we are multiplying corresponds to a number in terms of 2s power, which allows us to used Left Shift function) In order to access each bit in the buffer, we can either iterate through each row or each column. We chose to iterate through each column. Therefore when we are accessing the pixel buffer, each time we store a value, we increment the address by 1024 till the column end. Once the column ends, we start the second column, by setting y to 0 and incrementing x by 2. We continue till the end on the buffers.
 * In order to write in the buffer we first need to access the desired memory location and then change it to the required setting depending on which button is pushed.
 * In VGA_write_byte_ASM function, we need to store the binary number as hexadecimal. First, we check the 5th to 8th bit of the register, turn it into its hexadecimal representation and write it in the desired address. Then we check the 1st bit to 4th bit, and turn it into its hexadecimal representation and store it into the next byte address.
 * When we write bytes, we need to access the next memory location as well, to account for the next iteration/ access.
 * VGA_draw_point_ASM and VGA_write_char_ASM are similar functions, but one accesses to character buffer and the other one accesses to pixel buffer.
### Problems and improvements:
 * Comparing registers with numbers created a problem, therefore we needed to
assign a new register with a that number and compare two registers.
 * It took sometime to figure out how to connect the FPGA to a display and to
change the display settings to display the output of the FPGA.
 * Instead of storing each color into a byte, we could have store each color in
multiple bytes to see the color range of the computer.


## Keyboard
### Description:
 * For this section, we needed to access to the keyboard. The ‘read_PS2_data_ASM’ function receives input from the keyboard and checks if it is valid. It then reads the data if it is valid. In the main function we use this function to read the value and we use the ‘VGA_write_byte_ASM’ function from the first question to output it on the screen.
### Problems and improvements:
 * We did not run into problems in this section.
 * An improvement would be to convert the output to regular characters then
displayed them instead of displaying the output as hexadecimals.


## Audio
### Description:
 * Accessing WSRC and WSLC allows us to determine if availability to store data. If
they are not available the function returns 0. If they are available, then it stores
the input of the function and it returns 1.
 * Since the standard sampling rate of the board is 48,000 samples per second we
know that 24,000 samples per second need to be positive values of the square wave. If we want the frequency to be 100 Hz, we want there to be 100 periods of the square wave in a second. To achieve this we need to split up the 24,000 positive samples by 100, hence we need 240 samples to be positive, 240 to be 0.
 * To implement this we simply wrote two for loops, the first one loops 240 times and each time adds to the WSRC and WSLC FIFO buffers. However, to account for the fact that there might not be space and some of our 240 positive inputs will not be accounted for, we simply added a conditional statement that would decrease the counter if in that loop the value was not added to the buffer. This way it will only start with the 0 values when all 240 samples of the positive have been played.
### Problems and improvements:
 * The issue with this method of constantly looping is that we are wasting our CPU
power as the speed of sending the values in the for loop is faster than the audio can handle due to the 48,000 sampling rate. A solution to this could be to use a counter and every 1/50,000 seconds we set up a timer and when it’s done counting we add the sample value.
 * In addition, we did not allow for the user to change the value of the positive. This could have been done and we could have also made it so that the user could input the frequency they want, and with a little math on the 48,000 value we output the wanted sound.
