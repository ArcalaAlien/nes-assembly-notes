; An addressing mode is a way to
; store data using an opcode.
;
; There are 11 addressing modes

; $  (Absolute Mode)   - Denotes an address         ($2002, address to PPUSTATUS)
LDA $2002

; #$ (Immediate Mode)  - Denotes a literal value    (#$FF, literal value 255)
LDA #$FF

; #% (Binary Mode)     - Denotes a literal binary value (01100101, literal value 101)
LDA #%101100100

; Address,Register (Index Mode) - Returns value at (address + value of register)
LDX #$04
LDA $0200,X ;Load value at memory address $0204
; Using index mode allows us to move over a range of memory
; addresses easily and effeciently.
; Here's an example that will clear a page in memory:

LDA #$00 ;Load literal value 0 to accumulator.
TAX      ;Transfer accumulator to X register.

clear_memory:
    STA $0300,X ;Store value of accumulator at address $0300 + X
                ;X Starts at 0, so the first address is $0300
    INX         ;Increment our value in X to act as our next index
                ;Now X is 1, so the next memory address at line 26
                ;will be $0301 ($0300 + 1)

    BNE clear_memory ;Repeat this process until the X
                     ;register overflows and becomes 0.
