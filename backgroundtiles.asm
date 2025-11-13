.include "constants.inc"
.include "bgconstants.inc"
.include "header.inc"

.segment "RODATA" ;Read Only Data
  palettes:
    .byte $0F, $09, $19, $29 ;BG palette one
    .byte $0F, $05, $15, $25 ;BG palette two
    .byte $0F, $07, $17, $27 ;BG palette three
    .byte $0F, $04, $14, $24 ;BG palette four

    .byte $0F, $01, $21, $3C ;sprite palette one
    .byte $0F, $08, $1A, $2B ;sprite palette two
    .byte $0F, $15, $26, $3A ;sprite palette three
    .byte $0F, $13, $25, $36 ;sprite palette four
  sprites:
    .byte $70, $05, $00, $80 ;Sprite One
    .byte $70, $06, $01, $88 ;Sprite Two
    .byte $78, $07, $02, $80 ;Sprite Three
    .byte $78, $08, $03, $88 ;Sprite Four

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
  LDA #$00;Set background scroll values
  STA $2005 ;Set Scroll X?
  STA $2005 ;Set Scroll Y?
  RTI
.endproc

.import reset_handler


.export main
.proc main
    LDX PPUSTATUS
    LDX #$3f
    STX PPUADDR
    LDX #$00
    STX PPUADDR

    load_palettes:
      LDA palettes,X
      STA PPUDATA
      INX
      CPX #$20
      BNE load_palettes

    LDX PPUSTATUS ;Reset incrementor and PPUSTATUS
    load_sprites:
      LDA sprites,X
      STA $0200,X
      INX
      CPX #$10
      BNE load_sprites

    ;Write H
    LDA PPUSTATUS ;refresh PPU
    LDA #$20      ;Load high-byte of address
    STA PPUADDR
    LDA #$C8      ;Load low-byte of address
    STA PPUADDR   ;Set address to BG Tile we want to set
    LDX #LETTERH  ;Load BG Tile H
    STX PPUDATA   ;Set BG tile

    ;Write E
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$C9
    STA PPUADDR
    LDX #LETTERE
    STX PPUDATA

    ;Write L1
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$CA
    STA PPUADDR
    LDX #LETTERL
    STX PPUDATA

    ;Write L2
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$CB
    STA PPUADDR
    STX PPUDATA

    ;Write L3
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$ED
    STA PPUADDR
    STX PPUDATA

    ;Write O1
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$CC
    STA PPUADDR
    LDX #LETTERO
    STX PPUDATA

    ;Write O2
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$EB
    STA PPUADDR
    STX PPUDATA

    ;Write W
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$EA
    STA PPUADDR
    LDX #LETTERW
    STX PPUDATA

    ;Write R
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$EC
    STA PPUADDR
    LDX #LETTERR
    STX PPUDATA

    ;Write D
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$EE
    STA PPUADDR
    LDX #LETTERD
    STX PPUDATA

    ;Write !1
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$EF
    STA PPUADDR
    LDX #PUNCX
    STX PPUDATA

    ;Write !2
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$F0
    STA PPUADDR
    STX PPUDATA

    ;Write !3
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$F1
    STA PPUADDR
    STX PPUDATA

    ;Write Eye One
    LDA PPUSTATUS
    LDA #$21
    STA PPUADDR
    LDA #$4B
    STA PPUADDR
    LDX #TILEWH
    STX PPUDATA

    ;Write Eye Two
    LDA PPUSTATUS
    LDA #$21
    STA PPUADDR
    LDA #$4D
    STA PPUADDR
    STX PPUDATA

    ;Write Smile One
    LDA PPUSTATUS
    LDA #$21
    STA PPUADDR
    LDA #$8A
    STA PPUADDR
    LDX #TILELG
    STX PPUDATA

    ;Write Smile Two
    LDA PPUSTATUS
    LDA #$21
    STA PPUADDR
    LDA #$AB
    STA PPUADDR
    STX PPUDATA

    ;Write Smile Three
    LDA PPUSTATUS
    LDA #$21
    STA PPUADDR
    LDA #$AC
    STA PPUADDR
    STX PPUDATA

    ;Write Smile Four
    LDA PPUSTATUS
    LDA #$21
    STA PPUADDR
    LDA #$AD
    STA PPUADDR
    STX PPUDATA

    ;Write Smile Five
    LDA PPUSTATUS
    LDA #$21
    STA PPUADDR
    LDA #$8E
    STA PPUADDR
    STX PPUDATA

    ;Now we write the BG attribute table.
    LDA PPUSTATUS   ;Refresh PPU status
    LDA #$23        ;Load high-byte of attribute table address
    STA PPUADDR
    LDA #$CA        ;Load low-byte of attribute table address
    STA PPUADDR     ;Set PPUADDR to address of 2x2 tile
                    ;table
    LDX #%10100000  ;Set sections 4 and 6 to palette 2
    STX PPUDATA

    LDA PPUSTATUS
    LDA #$23
    STA PPUADDR
    LDA #$CB
    STA PPUADDR
    LDX #%11110000
    STX PPUDATA

    LDA PPUSTATUS
    LDA #$23
    STA PPUADDR
    LDA #$CC
    STA PPUADDR
    LDX #%00100000
    STX PPUDATA

    LDA PPUSTATUS
    LDA #$23
    STA PPUADDR
    LDA #$CC
    STA PPUADDR
    LDX #%00100000
    STX PPUDATA

vblankwait:
    BIT PPUSTATUS
    BPL vblankwait

    LDA #%10010000
    STA PPUCTRL
    LDA #%00011110
    STA PPUMASK
forever:
    JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "graphics.chr"
