/**
 * Used for testing purposes.
 **/
@thumb
@little

add r2, r4, 0x2
mov r9, r4


/* old vwf routine stuff*/

/* r1 will hold the address index of the glyph to draw */
mov r10, r0
lsl r0, r0, 0x05
mov r1, 0x08
lsl r1, r1, 0x08
add r1, 0x60
lsl r1, r1, 0x08
add r1, 0x35
lsl r1, r1, 0x08
add r1, 0xAC
; r12 will hold the base address of the glyphs
mov r12, r1
add r0, r0, r1

; r7 will hold the address of the WRAM we're writing to
mov r7, 0x02
lsl r7, r7, 0x08
add r7, 0x00
lsl r7, r7, 0x08
add r7, 0x97
lsl r7, r7, 0x08
add r7, 0xB0

; r8 = draw tile loop counter
; r9 = draw row loop counter
mov r1, 0
mov r8, r1
mov r9, r1

draw_tile:
  mov r1, 0
  mov r9, r1
  ; r1 is the 1bpp representation of the current row
  ldrb r1, [r0]
  ; r2 is the 2,F's representation of the current row
  mov r2, 0
draw_row:
  lsl r2, r2, 0x4
  mov r3, r1
  mov r4, 0x80
  and r3, r4
  beq 0x0 draw2
drawF:
  add r2, 0xF
  b cont
draw2:
  add r2, 0x2
cont:
  lsl r1, r1, 0x1
  mov r3, r9
  add r3, 0x1
  mov r9, r3
  cmp r3, 0x8
  blt draw_row

  add r0, 0x1
  str r2, [r7]
  add r7, 0x4
  mov r3, r8
  add r3, 0x1
  mov r8, r3
  cmp r3, 0x10
  blt draw_tile

; TODO: Fill in the lower 32 bytes with all 2's.

/* Increment the x-coordinate and tile index. */
increment_tile:
  mov r1, 0x02
  lsl r1, r1, 0x08
  add r1, 0x00
  lsl r1, r1, 0x08
  add r1, 0x99
  lsl r1, r1, 0x08
  add r1, 0x30
  cmp r3, 0x0
  ldrb r2, [r1]
  add r2, 0x1
  strb r2, [r1]
  add r1, 0x24
  ldrb r2, [r1]
  add r2, 0x2
  strb r2, [r1]
