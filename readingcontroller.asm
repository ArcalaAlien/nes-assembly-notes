; copy pasted from here:
; https://nerdy-nights.nes.science/#main_tutorial-7
Better Controller Reading
The controllers are accessed through memory port addresses $4016 and $4017.  First you have to write the value $01 then the value $00 to port $4016.  This tells the controllers to latch the current button positions.  Then you read from $4016 for first player or $4017 for second player.  The buttons are sent  one at a time, in bit 0.  If bit 0 is 0, the button is not pressed.  If bit 0 is 1, the button is pressed.
Button status for each controller is returned in the following order: A, B, Select, Start, Up, Down, Left, Right.
Now that you can set up subroutines, you can do much better controller reading.  Previously the controller was read as it was processed.  With multiple game states, that would mean many copies of the same controller reading code.  This is replaced with one controller reading subroutine that saves the button data into a variable.  That variable can then be checked in many places without having to read the whole controller again.
;The controller is a serial port, so it sends one bit at a time.


ReadController:
  LDA #$01         ;Set low bit to 0001
  STA $4016        ;Store to controller Port 1
  LDA #$00         ;Set high bit to 0
  STA $4016        ;Store to controller Port 1
  LDX #$08         ;Set X as our incrementor (Decrementor in this case)
ReadControllerLoop:
  LDA $4016                 ; Read from Controller Port 1
  LSR A                     ; Shift all bits right once
                            ; The lowest bit will be pushed to carry
  ROL buttons               ; Shift all bits left once
                            ; The carry flag is pushed back to
                            ; the lowest bit.
  DEX                       ; Decrement our incrementor
  BNE ReadControllerLoop    ; If our incrementor is not 0, loop!
  RTS                       ; Otherwise we can leave



This code uses two new instructions.  The first is LSR (Logical Shift Right).  This takes each bit in A and shifts them over 1 position to the right.  Bit 7 is filled with a 0, and bit 0 is shifted into the Carry flag.

bit number      7 6 5 4 3 2 1 0  carry
original data   1 0 0 1 1 0 1 1  0
                \ \ \ \ \ \ \  \
                 \ \ \ \ \ \ \  \
shifted data    0 1 0 0 1 1 0 1  1


Each bit position is a power of 2, so LSR is the same thing as divide by 2.
The next new instruction is ROL (ROtate Left) which is the opposite of LSR.  Each bit is shifted to the left by one position.  The Carry flag is put into bit 0.  This is the same as a multiply by 2.
These instructions are used together in a clever way for controller reading.  When each button is read, the button data is in bit 0.  Doing the LSR puts the button data into Carry.  Then the ROL shifts the previous button data over and puts Carry back to bit 0.  The following diagram shows the values of Accumulator and buttons data at each step of reading the controller:

                      Accumulator                               buttons data

bit:             7  6  5  4  3  2  1  0  Carry           7  6  5  4  3  2  1  0  Carry
read button A    0  0  0  0  0  0  0  A  0               0  0  0  0  0  0  0  0  0
LSR A            0  0  0  0  0  0  0  0  A               0  0  0  0  0  0  0  0  A
ROL buttons      0  0  0  0  0  0  0  0  A               0  0  0  0  0  0  0  A  0

read button B    0  0  0  0  0  0  0  B  0               0  0  0  0  0  0  0  A  0
LSR A            0  0  0  0  0  0  0  0  B               0  0  0  0  0  0  0  A  B
ROL buttons      0  0  0  0  0  0  0  0  0               0  0  0  0  0  0  A  B  0

read button SEL  0  0  0  0  0  0  0 SEL 0               0  0  0  0  0  0  0  A  0
LSR A            0  0  0  0  0  0  0  0 SEL              0  0  0  0  0  0  0  A SEL
ROL buttons      0  0  0  0  0  0  0  0  0               0  0  0  0  0  A  B SEL 0

read button STA  0  0  0  0  0  0  0 STA 0               0  0  0  0  0  0  0  A  0
LSR A            0  0  0  0  0  0  0  0 STA              0  0  0  0  0  0  0  A STA
ROL buttons      0  0  0  0  0  0  0  0  0               0  0  0  0  A  B SEL STA 0

The loop continues for a total of 8 times to read all buttons.  When it is done there is one button in each bit:

bit:       7     6     5     4     3     2     1     0  ; This is different for some reason on my handler.
button:    A     B   select start  up   down  left right


If the bit is 1, that button is pressed.
