.include "../include/ppu_addresses.inc"

.segment "ZEROPAGE"
.import ptrLo, ptrHi

.segment "CODE"
.export DrawScreen
.proc DrawScreen
    ; Turn Off The Screen
    LDA #$00
    STA PPUMASK

    ; Wait for a VBlank so we can start writing stuff
    VBlankWait:
        BIT PPUSTATUS
        BPL VBlankWait

    BIT PPUSTATUS ;Refresh the PPU to get ready for load
    ;Set up address to the first nametable in PPU $2000
    LDA #$20
    STA PPUADDR
    LDA #$00
    STA PPUADDR

    ;Store the bytes set up in X and Y
    ;prior to calling this function into
    ;the pointer variables
    STX ptrLo
    STY ptrHi

    LDX #$00 ;Set our incrementors
    LDY #$00
    ; This is similar to a nested for loop
    ; for (int i; i<4; i++)
    ;   for (int j; j<256; j++)
    LoadScreenLoopX:
        LoadScreenLoopY:
            ; [],X is called Indirect Indexed addressing
            ; [] acts as the low byte of a 16 bit pointer
            ; it will automatically load the high byte of
            ; the 16 bit pointer to the accumulator, at
            ; index Y.
            ;
            ; So effectively, if ptrLo was 00 and ptrHi was 02
            ; with index Y being #$00
            ; calling LDA ptrLo,Y is the same as calling LDA $0200.
            ; then when we loop again and call LDA ptrLo,Y
            ; We'll call $0201. We can check for an overflow in our
            ; counter to index the high pointer and move to the next
            ; page.
            ;
            ; We woud just call INC ptrHi, then we would be
            ; looking at $0300.
            LDA (ptrLo), Y
            STA PPUDATA

            INY
            CPY #$00
            BNE LoadScreenLoopY

        INC ptrHi
        INX
        CPX #$04
        BNE LoadScreenLoopX

    ;Turn the screen back on
    LDA #$1E
    STA PPUMASK
    RTS
.endproc
