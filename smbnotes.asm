; NOTE: Most code for SMB is handled in the NMI!
; NOTE: Disassembly taken from https://github.com/threecreepio/smb-disassembly

;-------------------------------------------------------------------------------------

; OperMode will probably be
; either $00, $01, $02, $03

OperModeExecutionTree:
      lda OperMode     ;this is the heart of the entire program,
      jsr JumpEngine   ;most of what goes on starts here

      .word TitleScreenMode
      .word GameMode
      .word VictoryMode
      .word GameOverMode

;-------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------
;$04 - address low to jump address
;$05 - address high to jump address
;$06 - jump address low
;$07 - jump address high

JumpEngine:
       asl                      ;shift bit from contents of A
       tay
       pla                      ;pull saved return address from stack
       sta rtnAddrPointerLo        ;save to indirect
       pla
       sta rtnAddrPointerHi
       iny
       lda (rtnAddrPointerLo),y    ;load pointer from indirect
       sta jmpPointerLo         ;note that if an RTS is performed in next routine
       iny                      ;it will return to the execution before the sub
       lda (rtnAddrPointerLo),y    ;that called this routine
       sta jmpPointerHi
       jmp (jmpPointerLo)       ;jump to the address we loaded

;-------------------------------------------------------------------------------------
