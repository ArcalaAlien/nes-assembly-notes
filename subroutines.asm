; A subroutine is a .proc
; that ends in RTS.
;
; In order to call a subroutine
; use the opcode JSR <subroutine name>
.proc subOne
LDA #$00    ;Load 0
INC         ;increment twice
INC
STA $0201   ;store accumulator
RTS         ;leave subroutine
.endproc

.proc main
JSR subOne  ;call subroutine
; Do stuff
.endproc
;
; When the 6502 sees a JSR opcode
; it pushes the current value of the
; program counter (A special register
; that holds the memory address of the
; next instruction) onto the stack.
;
; The stack in the 6502 is 256 bytes
; in size (1 page) and is located between
; $0100 - $01FF. The 6502 uses a special
; register called the "stack pointer" to
; indicate where the "top" of the stack is.
;
; When the system initializes, it sets the
; stack pointer to $FF. Then every time
; something is stored to the stack, its
; written to $0100 plus the address on
; the pointer (The first write would be
; stored at $01FF) The pointer is then
; decremented by one. When a value is
; "popped" or removed from the stack
; the pointer is incremented by one.
;
; Writing more than 256 bytes at once to the
; stack causes the pointer to overflow.
