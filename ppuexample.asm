.include "constants.inc" ;Include files similar to C
.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00    ;Load value 0 to accumulator
  STA OAMADDR ;Tell OAM to prepare for a write starting at
              ;the beginning of the OAM block.

  LDA #$02    ;Load the high byte of the addresses we want to
              ;transfer to OAM into the accumulator.

  STA OAMDMA  ;Store value to OAMDMA
              ;This initializes the transfer of
              ;addresses $0200-$02ff (1 page of memory)
              ;into OAM.
.endproc

.import reset_handler ;Imports the reset_handler proc from another .asm file
                      ;in this case, src/reset.asm


.export main ;Creates a main label to allow other asm files to
             ;reference back to the main process
.proc main
    ;Write a full palette
    LDX PPUSTATUS ;Trigger VBLANK, clear PPU
    LDX #$3f      ;Load high bit of palette we want.
    STX PPUADDR   ;Store it into PPUADDR
    LDX #$00      ;Load low bit of palette we want.
    STX PPUADDR   ;Store it in PPUADDR
                  ;PPUADDR now points to $3f00, the
                  ;first palette in the PPU

    ;Since we've already stored an address to
    ;a palette in PPUADDR, we don't need to store
    ;it again to keep modifying the palette
    ;as every time we write to PPUDATA
    ;we increment PPUADDR by 1
    LDA #$29    ;Color 0 (BG)
    STA PPUDATA
    LDA #$19    ;Color 1
    STA PPUDATA
    LDA #$09    ;Color 2
    STA PPUDATA
    LDA #$0f    ;Color 3
    STA PPUDATA

    ;write sprite data
    ;all sprite data is stored between
    ;$0200 and $02ff
    ;each sprite takes 4 bytes that
    ;controls different sprite attributes
    LDA #$70
    STA $0200 ;y-coordinate of first sprite.
    LDA #$05
    STA $0201 ;tile number of first sprite
    LDA #$00
    STA $0202 ;attributes of first sprite (h flip, v flip)
    LDA #$80
    STA $0203 ;x-coordinate of first sprite.

vblankwait: ;wait for another vblank before continuing
    BIT PPUSTATUS
    BPL vblankwait

    LDA #%10010000 ;turn on NMIs, sprites use first pattern table
    STA PPUCTRL
    LDA #%00011110 ;turn on screen
    STA PPUMASK
forever:
    JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "graphics.chr" ;Include the graphics.chr file in the CHR-ROM
