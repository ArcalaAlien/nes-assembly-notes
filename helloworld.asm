.segment "HEADER"
;ROM HEADER SEGMENT

;.byte instructs the assembler to insert these
;as literal numbers
.byte $4e, $45, $53, $1a, $02, $01, $00, $00
;      N    E    S  \eof

.segment "CODE"
;CODE SEGMENT

;There are three interrupt vectors
;irq_handler
;nmi_handler
;reset_handler

;These are processes that we can hook into
;to tell the cpu to do something different
;when they are triggered

.proc irq_handler ;.proc or Processes are similar to
                  ;namespaces from C++
                  ;The irq_handler ("Interrupt Request") can
                  ;be triggered from the APU and other hardware
  RTI ;Return From Interrupt
.endproc

.proc nmi_handler ;The nmi_handler ("Non-Maskable Interrupt")
                  ;is triggered every time the PPU prepares the
                  ;next frame to be displayed
  RTI
.endproc

.proc reset_handler ;The reset_handler is triggered
                    ;when the user presses the reset button
                    ;or when the system is first turned on.

  SEI ;Set Interrupt Ignore Bit
      ;Anything after this instruction that would
      ;trigger an interrupt request (IRQ)
      ;does nothing instead.
      ;We call this first because we don't want
      ;to jump to the IRQ handler before
      ;things are set up.

  CLD ;Clear Decimal Mode Bit
      ;Disables binary-coded decimal mode on the 6502.
      ;We don't need to work with floats on the NES

  LDX #$40  ;These four lines
  STX $4017 ;disable audio IRQs which are handled
  LDX #$FF  ;separately from the SEI and set up
  TXS       ;the "stack"*
            ;
            ;*The guide is not going into this part
            ;quite yet.

  INX ;Not covered yet, moves null to register?

  STX $2000 ;PPUCTRL address, not covered yet
            ;but is similar to PPUMASK.
            ;
            ;Bit 7 of PPUCTRL's value controls whether
            ;an NMI will trigger each frame.
            ;After INX, register X holds $00
            ;So by storing X to PPUCTRL
  STX $2001 ;and to PPUMASK we turn off
            ;NMIs and disable screen rendering
            ;so we don't draw random garbage
            ;during boot.

  STX $4010 ;Writing $00 to this address turns off
            ;DMC IRQs which is part of the APU
            ;Doing this helps prevent difficult glitches

  ;Here we check PPUSTATUS ($2002)
  ;to see if it is ready.
  ;
  ;BIT and BPL are not covered yet
  ;so they are currently magic.
  BIT $2002
vblankwait:
  BIT $2002
  BPL vblankwait
vblankwait2:
  BIT $2002
  BPL vblankwait2
  JMP main  ;We don't end with RTI (Return From Interrupt)
            ;Because after the system turns on we want
            ;to move to our main process
.endproc

.proc main
  LDX $2002 ;Load PPUSTATUS address to register X
            ;This lets us check the status of the PPU (Picture Processing Unit)
            ;This also resets the "address latch" for PPUADDR
            ;See more below

  LDX #$3f  ;Load literal byte 3f to register X
  STX $2006 ;Store value in register X to PPUADDR address
            ;First byte stored wil be the "high" byte of the address
            ;aka the left most byte

  LDX #$00  ;Load literal byte 00 to register X
  STX $2006 ;Store value in register X to PPUADDR
            ;This is the "low" byte of the the address
            ;aka the right most byte.
            ;Now we've wrote a full address to PPUADDR
            ;address 3f00, which represents the first color in the first palette

  LDA #$06  ;Load the value that corresponds to the color we want
  STA $2007 ;Store it in the PPUDATA address

  LDA #%00011000 ;Load a binary value representing
                 ;the flags the ppu will use to draw to the screen
                 ;TODO Make cheatsheet
  STA $2001      ;Store value to the PPUMASK address

  end:
    JMP end
.endproc

.segment "VECTORS"
; This segment stores the addresses to the
; interrupt processes.
.addr nmi_handler, reset_handler, irq_handler
;Using .addr will have the assembler link
;the labels listed to their addresses in the VECTOR segment
;assuming they exist.

.segment "CHARS"
.res 8192
.segment "STARTUP"
