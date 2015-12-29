; Original vwf routine at 0x0800CFCC.
; r0 = glyph value
; r1 = palette index
; r2 = address of glyph data in RAM to be DMA'd into tiles. we can safely ignore
;      r2 and always use 0x020097B0.
; r3 = flag to indicate whether this is the first or second tile in the 16x24
;      unit. we can safely ignore r3.
;
; The byte at 0x0200974C stores a flag indicating whether or not italicized
; kana should be used.

.gba
.open "hacked.gba", 0x08000000

;---------------------------------------------;
; Wrapper for script calls to our vwf routine ;
;---------------------------------------------;

; Disable dma for script
.org 0x0800C1AE
nop

; Disable updates to x-coordinate
.org 0x0800C248
nop
.org 0x0800C2F2
nop

; Disable updates to tile index at 0x02009954
.org 0x0800BA74
nop
.org 0x0800C152
nop
.org 0x0800C23E
nop
.org 0x0800C2E8
nop

.org 0x0800CFD8
ldr r4, =0x0800CFE8
mov r11, r4
ldr r4, =0x087DF750
mov pc, r4
.pool
post_script:
; Update x-coordinate and tile index
ldr r1, =0x02009930
ldrh r2, [r1]
add r2, r2, r0
strh r2, [r1]

ldr r1, =0x02009954
ldrh r2, [r1]
lsl r3, r0, 0x01
add r2, r2, r3
strh r2, [r1]

; DMA
ldr r1, =0x040000D4
ldr r2, =0x020097B0
str r2, [r1]
ldr r2, =0x06004000
ldr r3, =0x02009954
ldrh r3, [r3]
lsl r3, r3, 0x05
add r2, r2, r3
str r2, [r1, 0x04]
ldr r2, =0x80000060
str r2, [r1, 0x08]
ldr r2, [r1, 0x08]

; Update RAM.
ldr r4, =0x040000D4
ldr r1, =0x020097B0
lsl r2, r0, 0x06
add r2, r1, r2
str r2, [r4]
str r1, [r4, 0x04]
ldr r1, =0x80000020
str r1, [r4, 0x08]
ldr r1, [r4, 0x08]

ldr r1, =0x22222222
ldr r2, =0x020097F0
str r1, [r2]
ldr r3, =0x040000D4
str r2, [r3]
str r2, [r3, 0x04]
ldr r2, =0x81000040
str r2, [r3, 0x08]
ldr r2, [r3, 0x08]

; Clean up
b 0x0800D112

.pool

; Our vwf routine.
.org 0x087DF750

; r6 = x-offset of glyph
; r7 = which 16x8 block to draw we're on
; r8 = glyph values
; r9 = palette value
initialization:
  mov r7, 0x00
  mov r8, r0
  mov r9, r1
  ldr r0, =0x0203FFF0
  ldrb r6, [r0]

vwf:
  ; Compute glyph address and store in r0. r0 = 0x08603900 + ((r0 & 0xFF) << 4)
  mov r0, r8
  lsl r0, 0x18
  lsr r0, 0x18
  cmp r0, 0x1F
  ; Clear RAM on beginning of string
  bne not_bos
  mov r1, 0x00
  ldr r2, =0x0203FFF0
  strb r1, [r2]
  ldr r1, =0x22222222
  ldr r2, =0x020097B0
  str r1, [r2]
  ldr r3, =0x040000D4
  str r2, [r3]
  str r2, [r3, 0x04]
  ldr r2, =0x81000060
  str r2, [r3, 0x08]
  ldr r2, [r3, 0x08]
  not_bos:
  lsl r0, 0x04
  ldr r1, =0x08603900
  add r0, r0, r1

  mov r1, 0x00
  @@loop:
    bl compute_4bpp_row

    ldr r3, =0x020097B0
    lsl r4, r7, 0x06
    add r3, r3, r4
    lsl r4, r1, 0x02
    add r3, r3, r4

    lsl r4, r6, 0x02
    lsl r2, r4

    ldr r4, [r3]
    lsl r5, r6, 0x02
    sub r5, 0x20
    neg r5, r5
    lsl r4, r5
    lsr r4, r5
    add r2, r2, r4

    str r2, [r3]

    add r1, r1, 0x01
    cmp r1, 0x10
    blt @@loop

  ; Compute glyph width and store in r10
  mov r1, r8
  lsl r1, 0x18
  lsr r1, 0x18
  ldr r2, =0x087DF900
  ldrb r5, [r2, r1]
  mov r10, r5
  add r1, r5, r6
  cmp r1, 0x08
  ble no_carryover
  add r7, r7, 0x01
  mov r1, 0x00
  @@loop2:
    bl compute_4bpp_row

    mov r5, r10
    add r3, r5, r6
    sub r3, 0x08
    add r3, 0x02
    lsl r3, 0x02
    lsr r2, r3
    ldr r4, =0x22222222
    sub r3, 0x20
    neg r3, r3
    lsl r4, r3
    add r2, r2, r4

    ldr r3, =0x020097B0
    lsl r4, r7, 0x06
    add r3, r3, r4
    lsl r4, r1, 0x02
    add r3, r3, r4
    str r2, [r3]

    add r1, r1, 0x01
    cmp r1, 0x10
    blt @@loop2
  no_carryover:

  mov r5, r10
  ; r6 = (r5 + r6)%8
  add r6, r5, r6
  add r6, 0x01
  lsl r6, 0x1D
  lsr r6, 0x1D

  mov r0, r8
  lsr r0, 0x08
  mov r8, r0
  cmp r0, 0x00
  bne vwf

return:
  ldr r0, =0x0203FFF0
  strb r6, [r0]
  mov r0, r7
  mov r1, r11
  mov r15, r1

; Inputs:
; r0 = address of glyph
; r1 = which row
; Outputs:
; r2 = 4bpp row
; Clobbers: r3, r4, r5
compute_4bpp_row:
  ldrb r2, [r0, r1]

  ; Expand 1bpp (e.g. 01101b -> 0000 0001 0001 0000 0001b) and store in r3.
  mov r3, 0x00
  mov r4, 0x00
  @@loop:
    mov r5, 0x01
    lsl r5, r4
    and r5, r2
    lsr r5, r4
    lsl r4, r4, 0x02
    lsl r5, r4
    lsr r4, r4, 0x02
    add r3, r3, r5

    add r4, r4, 0x01
    cmp r4, 0x08
    blt @@loop

  ldr r2, =0x22222222
  mov r4, 0x02
  mul r4, r3
  sub r2, r2, r4
  mov r4, r9
  mul r4, r3
  add r2, r2, r4
  mov pc, lr
compute_4bpp_row_end:

.pool

.close
