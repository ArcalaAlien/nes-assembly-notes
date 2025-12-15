;---LOAD/STORE---
LDA ;Load to accumulator
LDX ;Load to X register
LDY ;Load to Y register

STA ;Store from accumulator
STX ;Store from x register
STY ;Store from y Register

TAX ;Transfer accumulator to X
TAY ;Transfer accumulator to Y
TXA ;Transfer X to Accumulator
TYA ;Transfer Y to Accumulator
TXY ;Transfer X to Y
TYX ;Trasnfer Y to X

TSX ;Transfer stack pointer to x
    ;Copies the contents of the
    ;stack register to the X register

TXS ;Transfer X to Stack Pointer
    ;Copies the contents of the X
    ;register to the stack register.

;---ARTHIMETIC---
INX ;increment X register
INY ;increment Y register
INC ;increment memory location

DEX ;decrement X register
DEY ;decrement Y register
DEC ;decrement accumulator

ADC ;Add with Carry
    ;Add to accumulator with carry bit
    ;If overflow occurs, the carry bit
    ;is set.

SBC ;Subtract with Carry
    ;Subtract from accumulator with
    ;the NOT of the carry bit
    ;If overflow occurs the carry
    ;bit is clear.

ASL ;Arithmetic Shift Left
    ;Shift all bits left once
    ;Multiplies by 2
    ;Sets carry flag if overflow

LSR ;Logical Shift Right
    ;Shifts all bits right once
    ;Divides by 2
    ;The carry flag is old bit 0

ROL ;Rotate Left
    ;See ASL, not sure exact differences

ROR ;Rotate right
    ;See LSR, not sure differences

;---LOGIC---
NOP ;No operation

BRK ;Forces the generation of an IRQ (interrupt request)
    ;Needs further explanation

RTI ;Return From Interrupt
RTS ;Return from subroutine

CLC ;Clear carry flag
CLD ;Clear decimal mode
CLI ;Clear interrupt disable
CLV ;Clear overflow flag

SEC ;Set Carry Flag
SED ;Set Decimal Flag
SEI ;Set Interrupt Disable


PHA ;Push accumulator onto stack
PHP ;Push status flags onto stack
PLA ;Pull a value from stack to accumulator
PLP ;Pull a value from stack to processor status

;=BRANCHING=
JMP ;Jump to label
JSR ;Jump to subroutine

BNE ;Branch if Zero flag is not set
BEQ ;Branch if Zero flag is set
BCC ;Branch if Carry flag is not set
BCS ;Branch if Carry flag is set
BVC ;Branch if Overflow flag is not set
BVS ;Branch if Overflow flag is set


;This checks for signed integers,
;so the negative flag is bit 7!
;S Number
;0 0000000
;
;1 1111111 = -128
;0 1111111 = +128
BPL ;Branch if positive, more specifically
    ;branch if the negative flag is clear!!!

BMI ;Branch if negative, more specifically
    ;branch if the negative flag is set!!

;=COMPARING=
BIT ;Modifies flags
    ;but does not change
    ;content of memory or
    ;registers
    ;
    ;Zero flag is set depending on the
    ;result of (accumulator AND (&) memory)
    ;
    ;Bits 7 and 6 are automatically loaded
    ;into the negative and overflow register flags
    ;

AND ;Performs a logical AND on the
    ;accumulator using the contents
    ;of a byte of memory.

EOR ;Exclusive OR
    ;Performs a logical XOR on the
    ;accumulator using the contents
    ;of a byte of memory.

ORA ;Inclusive Or
    ;Performs a logical OR on the
    ;accumulator using the contents
    ;of a byte of memory.


;CMP Flags use subtraction to
;compare two values.
;
;After subtraction is performed,
;the carry and zero flags are set
;as needed and the result is discarded.
;
;We have 3 possible outcomes when
;we compare values
;
;Carry Flag Set, Zero Flag Clear
;   Register > Comparison Value
;
;Carry Flag and Zero Flag Set
;   Register == Comparison Value
;
;Carry Flag and Zero Flag Clear
;   Register < Comparison Value
;
;After comparing we can call one of
;the branch opcodes to check the result.
;
BEQ ;Branch Equal To (Register == Comparison Value)
BCS ;Branch Carry Set (Register > Comparison)
;   Call after BEQ, as the carry flag is
;   set in both possible outcomes, but
;   the zero flag is only set in one.
BCC ;Branch Carry Clear (Register < Comparison)


CMP ;Compare to value in accumulator
CPX ;Compare to value in X register
CPY ;Compare to value in Y register
