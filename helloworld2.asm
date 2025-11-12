.include "constants.inc" ;Include files similar to C
.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00    ;Load literal value 0 to accumulator
  STA OAMADDR ;Tell OAM to prepare for a write starting at byte 0
  LDA #$02    ;Load literal value 2 to accumulator
  STA OAMDMA  ;Store value to OAMDMA
              ;This tells the CPU to transfer
              ;256 bytes from addresses $0200-02ff
              ;into OAM.
.endproc

.import reset_handler ;Imports the reset_handler proc from another .asm file
                      ;in this case, src/reset.asm


.export main ;Creates a main label to allow other asm files to
             ;reference back to the main process
.proc main
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
  LDA #$27
  STA PPUDATA
  LDA #%00011110
  STA PPUMASK
forever:
  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.res 8192
