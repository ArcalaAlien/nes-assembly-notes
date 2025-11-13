;Originally we hardcoded our sprites directly
;However if we want to move them we can no
;longer hardcode them.
;
;Instead, we'll use a space called
;"Zero-Page RAM"
;A page of memory is a continuous block of
;256 bytes of memory.
;
;For memory addresses, the high byte
;determines the page number, and the
;low byte determines the specific address
;in the page.
;Range $0200 to $02FF is "Page $02"
;Range $8000 to $80FF is "Page $80"
;
;"Zero-Page RAM" is the address
;range of $0000 to $00FF. The
;6502 Processor has a special addressing
;mode for handling operations on
;Zero-Page RAM which makes it way faster
;than handling the same operation on
;other memory addresses.
;
;In order to use Zero-Page RAM, use
;1 Byte instead of 2 Bytes when calling
;an address.
;
; WRONG:
; LDA $002B (Absolute Addressing)
; LDA #$2B (Immediate Addressing)
;
; CORRECT:
; LDA $2B (Zero-Page Addressing)
;
; Using Zero-Page addressing gives
; access to 256 bytes of extremely fast
; memory, which is ideal for storing variables
; that you may change often such as player
; position, player level, player score.
;
; However we can't write to zero page values
; directly, we have to tell the assembler to
; reserve space in Zero-Page RAM for us
; to use.
;
.segment "ZEROPAGE"
player_x: .res 1 ;reserve 1 byte for player X pos
player_y: .res 1 ;reserve 1 byte for player y pos
;
;After reserving memory, we need to
;initialize it. We could initialize
;inside our main process, but instead
;the book wants us to initialize it in
;the reset handler.
;
;
; In reset.asm
; Reset Handler Code...
LDA #$80
STA player_x
LDA #$a0
STA player_y
JMP main
;
; However the linker will yell at you
; because reserved memory names are usually
; only valid in the file they're defined in.
; We can get around this by using the
; assembler's .exportzp directive in the
; file where the variables are defined
; and an .importzp directive in the
; file they're needed in.
;
; in main.asm
;
; code...
.segment "ZEROPAGE"
player_x: .res 1
player_y: .res 1
.exportzp player_x, player_y
; code...
;
; in reset.asm
;
;code...
.segment "ZEROPAGE"
.importzp player_x, player_y
;code...
