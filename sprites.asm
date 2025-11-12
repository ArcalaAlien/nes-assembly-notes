;PPU uses 256 bytes of memory
;to store sprite info
;
;Each sprite object takes
;4 bytes of memory to describe,
;which means PPU has a limit of
;64 sprites it can display at
;once.
;
; 00000000 00000000 00000000 00000000
; Each byte references a different
; property of our sprite.
;
; Starting from highest (leftmost)
; 1. The Y position of the top
;   left corner of the sprite.
;
; 2. The tile number from the
;   sprite pattern table (0-255)
;
; 3. Special attribute flags
;   (horizontal flipping, etc)
;
; The third byte stores the sprite's
; flags in each bit.
;
; Bit 7 - Flips sprite vertically if 1
; Bit 6 - Flips sprite horizontally if 1
; Bit 5 - Hides sprite behind background if 1
; Bits 4-2 are unused
; Bits 1-0 are the palette for the sprite.

;The area in PPU Memory where sprite
;data is stored is called
;"Object Attribute Memory" or
;"OAM".
;
;This area has special addressses
;that the CPU can use to update
;the contents of OAM all at once,
;at high speed. Being able to write
;to OAM quickly is needed to make
;all 64 sprites move smoothly every
;frame.
;
;In order to use high-speed copying
;the CPU has to have all sprite data
;ready to go in a "page" of memory.
;One "page" of memory is a block of
;256 bytes.
;
;Usually this area is placed in
;CPU memory addresses $0200-$02ff,
;and is called the "sprite buffer".
;Inside the sprite buffer and OAM
;every four bytes defines one sprite.
;
;The first eight bytes of the sprite
;buffer could look like this:
;
;ADDR       PURPOSE
;$0200      Y position of Sprite 0
;$0201      Tile # of Sprite 0
;$0202      Attr. Flags of Sprite 0
;$0203      X position of Sprite 0
;$0204      Y position of Sprite 1
;$0205      Tile # of Sprite 1
;$0206      Attr. Flags of Sprite 1
;$0207      X position of Sprite 1
;
;After we fill the sprite buffer
;with the data we want to send to
;OAM, we will use two new MMIO
;(memory mapped input output)
;addresses to send all sprite
;data to the ppu.
;
;$2003: OAMADDR
;$4014: OAMDMA
;
;OAMADDR is used to set where
;in OAM we want to write to.
;In general this wil usually be
;$00, the beginning of the OAM
;block.
;
;OAMDMA handles the transfer
;of a page of memory into
;OAM. Writing the high byte
;of a memory address to here
;will start the transfer of
;that page
;
;OAMDMA uses "dynamic RAM"
;which is highly unstable and
;needs to be contstantly refreshed
;even if nothing has changed!!!
;
;Generally this means we will
;write to OAM once every frame.
;
;Non-Maskable Interrupts (NMI)
;This is the NES' easy to use
;system for running code once per
;frame.
;
;NMI is one of three interrupt
;vectors the 6502 microprocessor
;knows how to handle. NMI is
;triggered every time the PPU
;enters "vblank", which happens
;at the end of each frame of
;graphics.
;
;"vblank" means "vertical blank",
;and similarly there's "hblank"
;which means "horizontal blank."
;
;A "blank" is the time period when
;the electron gun in a CRT TV
;resets itself to start a new
;horizontal line from the left
;edge ("hblank"), or when it
;resets itself to start a new frame
;by moving from bottom right back
;to the top left ("vblank").
;
;"hblank" periods are ridiculously
;small, lasting only 10.9 usec,
;whereas "vblank" periods are
;marginally longer but are still
;short, lasting 1250 usec.
;
;vblank is one of the only times
;that nothing is actually being
;displayed on the screen, and
;hblank is too short to do
;anything meaningful, it is
;common practice to have
;graphical updates happen
;during vblank periods.
;
;
;
;






