; Processor Flags
0000 0000
NV1B DIZC

; N - Negative Flag
; Is the value in the register negative?
;
; BIT will load bit 7 of an address
; into the negative flag.

; V - Overflow Flag
; Did the value in the register go
; over 255?

; 1 - No Effect, always 1

; B - "Break Flag", special case
; https://www.nesdev.org/wiki/Status_flags#The_B_flag

; D - Decimal Flag
; Enables the use of floating points
; (unused, NES only works in integers)

; I - Interrupt Disable Flag
; When set IRQ (Interrupt Requests)
; are disabled.

; Z - Zero Flag
; This flag is set when the result
; is equal to zero, and cleared otherwise.

; C - Carry Flag
; After ADC (Add with Carry) this is the
; carry result of the addition
;
; After SBC or CMP (both do subtraction)
; This will be set if the result was
; greater than or equal to
;
; After a shift instruction this contains
; the bit that was shifted out.
; (ASL, LSR, ROL, ROR)

; Branching is similar to if statements,
; however every branching opcode checks
; the CPU Proccessor Flags.
;
; The CPU Flags are not directly accessable,
; instead several opcodes check
; the flags register and do something
; depending on the result.
;
; CARRY FLAG
; Think of adding 13 to 29.
; 3 + 9 = 12, but that's too big
; to fit in one digit, so we write
; down 2 and move the 1 over to the left.
; then we do 1 + 2 + 1 (the carry)
; which is 4, so the answer is 42.
; The carry flag is the same thing,
; but for bytes.
;
; Normally before adding we'll clear the
; carry bit to ensure we don't accidentally
; use the carry bit from a different operation,
; then we'll perform the addition.
;
; Subtraction works the similarly to
; addition, except we'll actually set the
; carry bit before we subtract numbers.
; If the number being subtracted is larger,
; for instance 15 - 17 = -2, the result is
; less than zero. In this case
; we need to "borrow" from the next
; lowest bit-column and "use up"
; the carry flag we set beforehand.
;
; Bytes "wrap around" or "overflow"
; when adding beyond 255 or subtracting
; beyond 0. For example, if a value is
; at 253 and you add 7 to it, the result
; won't be 260. It will be 4, but
; with the CPU's carry flag set.
; Or if the value is 4 and you subtract
; 7, the result will be 253 without a
; carry flag and not -3.
;
; You might want to keep a carry flag
; if you're adding multi-byte numbers
; together.
;
; First add the lowest bytes
; of the two numbers, then let the
; carry flag be set if needed.
;
; Then, when you add the next
; lowest bytes of the two numbers
; the carry flag will already be
; added in.
;
; NOTE!!!!!
; Increment and decrement opcodes
; DO NOT affect the carry flag.
;
; There are only a couple opcodes
; that do (ADC, SBC, ASL, LSR, CLC, SEC)
