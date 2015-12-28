; Original vwf routine at 0x0800CFCC.
; r0 = glyph value
; r1 = palette index
; r2 = address of glyph data in RAM to be DMA'd into tiles.
; r3 = flag to indicate whether this is the first or second tile in the 16x24
;      unit. we can safely ignore r3.
;
; The byte at 0x0200974C stores a flag indicating whether or not italicized
; kana should be used.

.gba
.open "hacked.gba", 0x08000000

; Jump to our vwf routine.
.org 0x0800CFD8
ldr r4, =0x087DF750
mov pc, r4
.pool

; Our vwf routine.
.org 0x087DF750
vwf:
cmp r0, 0x00
beq return

; r7 = address of glyph to draw
mov r7, r0
mov r3, 0xFF
and r7, r3
lsl r7, r7, 0x04
ldr r3, =0x08603900
add r7, r7, r3
mov r8, r7

mov r7, 0x00
draw_row:
  mov r3, r8
  ldrb r3, [r3, r7]
  mov r5, 0x00
  mov r6, 0x00
  expand_1bpp:
    mov r4, 0x01
    and r4, r3
    lsl r5, r5, 0x02
    lsl r4, r5
    lsr r5, r5, 0x02
    add r6, r6, r4

    lsr r3, r3, 0x01
    add r5, r5, 0x01
    cmp r5, 0x08
    blt expand_1bpp

  ldr r3, =0x22222222
  mov r5, 0x02
  mul r5, r6
  sub r3, r3, r5
  mov r5, r1
  mul r5, r6
  add r3, r3, r5

  mov r6, r7
  lsl r6, 0x02
  str r3, [r2, r6]

  add r7, r7, 0x01
  cmp r7, 0x10
  blt draw_row

lsr r0, 0x08
b vwf

return:
ldr r0, =0x0800D112
mov r15, r0
.pool

.close
