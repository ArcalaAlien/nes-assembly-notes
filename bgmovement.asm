;The NES can scroll background tiles by
;as little as one pixel.
;
;The NES is able to pull this off
;because of some special addresses
;in the PPU, as well as the way
;backgrounds are laid out in memory.
;
;The PPU's memory map has space for
;four nametables (backgrounds), but
;only enough physical space for two!
;Those two nametables can have a
;vertical layout where $2000 and
;$2800 are considered "real"
;(called Horizontal Mirroring), or
;a horizontal layout in which
;$2000 and $2400 are considered "real"
;(called Vertical Mirroring)
;
;Which layout is used is usually
;dependant on how the cartridge is
;manufactured. Older carts had
;"V" and "H" solder pads on the board,
;whichever one has solder on it was the
;layout that would be used.
;
;In most cases though, scrolling is
;controlled via writes to the
;PPUSCROLL ($2005) MMIO address during
;vblank (in the NMI Handler).
;You should always write to PPUSCROLL
;twice, once to determine the X scroll
;position in pixels, and once more to
;write the Y scroll position in pixels.
;
;WRITES TO PPUSCROLL SHOULD ALWAYS
;HAPPEN AT THE END OF THE NMI HANDLER
;TO AVOID OVERWRITING VALUES. THE
;PPU USES THE SAME INTERNAL REGISTERS
;FOR MEMORY ACCESS AND SCROLL INFO!!!
;
;You can make a "split-screen" effect
;by manipulating the internal working of
;the PPU requiring writes to PPUSCROLL
;and PPUCTRL within a very short timeframe
;(when the PPU has almost finished drawing
;the scanline before the split)
;
;What the X and Y "scroll positions"
;mean can vary depending on the cartridge's
;nametable layout and what's been written
;to PPUCTRL. The PPU keeps track of a
;"current" or "base" nametable, which can be
;set via writes to PPUCTRL. The lowest two bits
;of a byte written to PPUCTRL set the base
;nametable, with 00 representing the
;nametable at $2000, 01 representing
;$2400, 10 representing $2800, and 11
;representing $2c00. Once the base nametable
;is set, the X and Y scroll positions are
;actually offets from that base nametable.
;
;In a standard horizontal-layout game
;there are two nametables - $2000 and
;$2400. If we set the base nametable to
;$2000 and set both scroll positions to
;0, the resulting bg image that will be
;displayed on screen will be the entire
;nametable at $2000.
;
;Here's an example of what this looks like.
;
;end of NMI handler
LDA #$00
STA PPUSCROLL ;set X scroll
STA PPUSCROLL ;set Y scroll
;
;
;Now if we wanted to move the "camera" to
;the right 20px, in a horizontal layout we
;would see everything but the leftmost
;20 pixels of nametable $2000 lined up with
;the left edge of the screen, and the right
;side would be the leftmost 20px of
;nametable $2400
;
;Here's an example of what it looks like in code
;
LDA #20 ;decimal 20 because no $
STA PPUSCROLL ;set X scroll
LDA #$00
STA PPUSCROLL ;set Y scroll
;
;If we used the above code in a game
;with vertical layout, the scroll
;position would be moved beyond the bounds
;of two "real" nametables and would
;cause the viewport to wrap-around instead.
;Most games don't use this functionality
;however and will usually have a way to
;prevent scrolling in the incorrect direction
;
;There are a couple different times
;that we would want to scroll the bg.
;Here are a couple of basic camera system
;techniques that were common on the NES:
;
;Position Locking
;The simplest camera system, this
;keeps the player in the same place on
;screen the entire time, and scrolls the
;background every time player "moves"
;
;Position locking can be useful when
;the player needs a consistent view
;distance around their character on
;screen.
;
;Check out Micro Machines for an example
;
;Camera Windows
;Sometimes, you may want to give players
;more freedom to move around without
;shifting the viewport.
;A camera window specifies a region
;of the screen in which the player
;can move without causing the
;screen to scroll. Attempting to
;move outside of the window
;
;Check out Crystalis for an example
;
;Auto-scroll
;In an auto-scroll camera system,
;the player does not have any control
;over the camera movement, instead
;the camera constantly moves on its own
;with the player either remaining in the
;same position or letting the player sprite
;move while the bg scrolls below.
;
;Check out Star Soldier for an example
;
