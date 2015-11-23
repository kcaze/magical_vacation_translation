; This is the variable width font routine. Inject this at 0x007DF750
.gba
.open "hacked.gba", 0x08000000

;-----------------------------------------------------;
; Change script to read 1 byte at a time instead of 2 ;
;-----------------------------------------------------;
.org 0x0800C18C
add r0, 0x02

;---------------------------------------------------;
; Disable dma, x-coordinate, and tile index updates ;
;---------------------------------------------------;
.org 0x0800BA74
nop

.org 0x0800C19C
nop

.org 0x0800C1AE
nop

; Skip jump to case where only one 16x8 tile is drawn. Always draw two 16x8
; tiles.
.org 0x0800C1B4
nop

; Not quite sure about the following change.
.org 0x0800C218
mov r9, r4
add r2, r4, 0x02

.org 0x0800C248
nop

.org 0x0800C2E6
nop

.org 0x0800C2F2
nop

; What does this do???
.org 0x0800CFE8
bx r4

;-----------------------------------------;
; Insert control character function table ;
;-----------------------------------------;
.org 0x0800B844
.incbin vwf/control_characters.bin

;---------------------------------------------------;
; Hijack the old glyph drawing routine and use ours ;
;---------------------------------------------------;
.org 0x0800CFD8
mov r4, 0x08
lsl r4, r4, 0x08
add r4, 0x7D
lsl r4, r4, 0x08
add r4, 0xF7
lsl r4, r4, 0x08
add r4, 0x50
mov r15, r4

;-----------------;
; The VWF routine ;
;-----------------;
.org 0x087DF750

; Important Addresses
; -------------------
; 0x006035AC: Base address for 1bpp glyph tile data
; 0x020097B0: Base address for glyph tile data in WRAM. The nibbles
;             are stored in reverse orders. For example, 2FF22222 would
;             actually be copied into the tile data as 22222FF2.

; Function Parameters
; -------------------
; r0: Index into 0x086035AC of the glyph to draw
; r1: The palette color used to draw the glyph

; Variables in RAM
; ----------------
; 0x02009930: x-coordinate in bg3 that we draw tile
; 0x02009954: Index into tile destination index to copy data from wram to.
; 0x0203FFF0: x offset to draw current glyph (1 byte)
; 0x0203FFF1: offset into previous character (1 byte)
; 0x0203FFF2: index of previous character into 0x0806035AC (1 byte)
;             set to 0 if no remaining part to draw
; 0x0203FFF3: flag set to 1 if need to shift right 1 pixel when drawing previous
;             character

; Registers
; ---------
; r0: Passed in and preserved.
; r1 to r7: Scratch registers
; r8:

; r8 will hold the input glyphs
; r9 will hold the palette color
; r10 will hold the amount to truncate the glyph by, used when drawing the
; remaining portion of a glyph.
mov r8, r0
mov r9, r1
mov r7, 0x0
mov r10, r7

; Update the tile x and offset
ldr r7, =0x0203FFF1
ldrb r6, [r7]
mov r5, 0x00
strb r5, [r7]

ldr r7, =0x02009930
ldrh r5, [r7]
add r5, r5, r6
strh r5, [r7]

lsl r6, 0x01
ldr r7, =0x02009954
ldrh r5, [r7]
add r5, r5, r6
strh r5, [r7]

draw_glyph_begin:
  ; Extract current glyph to draw and store in r0.
  mov r0, r8
  mov r7, 0xFF
  and r0, r7

    ;-------------------------------------------------
    ; r0 = Base address of current glyph to draw.
    ; r1 = X-offset of current glyph (0x0203FFF0)
    ; r2 = Loop counter. Mask with 0x7 to get column.
    ; r3 = Row of 1 bpp glyph
    ; r4 = Row of 2's and F's
    ;-------------------------------------------------
    ldr r7, =0x08603900
    lsl r0, 0x04
    add r0, r0, r7
    ldr r7, =0x0203FFF0
    ldrb r1, [r7]
    mov r2, 0x00
  draw_initial_begin:
      ; Load 1bpp row.
      lsr r2, 0x03
      ldrb r3, [r0, r2]
      mov r7, r10
      lsr r3, r7

      ; Load RAM row.
      lsl r2, 0x02
      ldr r7, =0x020097B0
      ldr r4, [r7, r2]
      lsl r2, 0x01
    draw_initial_row_begin:
      ; r5 = The palette color to draw. We use a trick to avoid branching. It
      ;      assumes that the palette color in r9 is greater than 0x02.
      mov r7, r9
      sub r7, r7, 0x02
      mov r5, 0x01
      and r5, r3
      mul r5, r7
      add r5, r5, 0x02

      ; Shift r5 by the appropriate amount.
      mov r7, 0x07
      and r7, r2
      add r7, r7, r1
      lsl r7, 0x02
      lsl r5, r7
      cmp r5, 0x00
      beq draw_initial_row_end

      ; Clear out the existing nibble in the row and add the new nibble.
      mov r6, 0xF
      lsl r6, r7
      and r6, r4
      sub r4, r6
      add r4, r4, r5
    draw_initial_row_end:
      lsr r3, 0x01

      add r2, 0x01
      mov r7, 0x07
      and r7, r2
      cmp r7, 0x00
      bne draw_initial_row_begin
  draw_initial_end:
    ; Store the new row.
    ldr r7, =0x020097B0
    mov r6, r2
    sub r6, 0x08
    lsr r6, 0x01
    str r4, [r7, r6]

    cmp r2, 0x80
    bne draw_initial_begin
draw_glyph_end:
  ; DMA transfer
  ldr r7, =0x040000D4
  ldr r6, =0x020097B0
  str r6, [r7]
  ldr r6, =0x02009954
  ldrh r6, [r6]
  ldr r5, =0x0203FFF1
  ldrb r5, [r5]
  lsl r5, 0x01
  add r6, r6, r5
  lsl r6, r6, 0x05
  ldr r5, =0x06004000
  add r6, r6, r5
  str r6, [r7, 0x04]
  ldr r6, =0x80000040
  str r6, [r7, 0x08]
  ldr r6, [r7, 0x08] ; I think this instruction is unnecessary?

  ; Get the width of the glyph drawn
  mov r0, r8
  mov r7, 0xFF
  and r0, r7
  ldr r7, =0x087DF900
  ldrb r7, [r7, r0]
  add r6, r7, r1
  mov r7, r10
  sub r6, r6, r7
  cmp r6, 0x07
  blt no_tile_update
  ; Update tile x and offset
  ldr r7, =0x0203FFF1
  ldrb r5, [r7]
  add r5, 0x01
  strb r5, [r7]
  ; Clear RAM glyph
  ldr r7, =0x020097B0
  ldr r4, =0x22222222
  mov r5, 0x00
  clear_ram_begin:
    str r4, [r7, r5]
    add r5, 0x04
    cmp r5, 0x80
    blt clear_ram_begin
  clear_ram_end:
  no_tile_update:
  cmp r6, 0x08
  bgt handle_remaining
  b finish_glyph
  finish_glyph:
    ; Update x-offset for next glyph
    add r6, 0x01
    mov r7, 0x07
    and r6, r7
    ldr r7, =0x0203FFF0
    strb r6, [r7]
    ; Update r8
    mov r0, r8
    lsr r0, 0x08
    mov r8, r0
    ; Update r10 to 0
    mov r7, 0x00
    mov r10, r7
    b draw_next
  handle_remaining:
    ; Update r10 with how many pixels to truncate.
    mov r7, 0x08
    sub r7, r7, r1
    mov r10, r7
    ; Update glyph x-offset
    ldr r7, =0x0203FFF0
    mov r6, 0x00
    strb r6, [r7]
    b draw_next
  draw_next:
    mov r0, r8
    cmp r0, 0x00
    bne draw_glyph_begin

; Branch back to 0x0800D112 to return from the original function.
return:
  ldr r0, =0x0800D112
  mov r15, r0

.pool

; Newline control character routine. Cleans up the ram and then branches back to
; original newline routine.
.org 0x087DFA00
ldr r0, =0x0203FFF0
mov r1, 0x00
strh r1, [r0]
ldr r0, =0x02009954
ldrh r1, [r0]
add r1, 0x04
strh r1, [r0]
ldr r0, =0x0800BA58
mov r15, r0

.pool

.close
