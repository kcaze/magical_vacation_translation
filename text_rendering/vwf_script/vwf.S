ADDR_GLYPH_BUFFER equ 0x020097B0
ADDR_SHIFT  equ 0x0203FFF0
ADDR_FONT   equ 0x08603900
ADDR_WIDTHS equ 0x08604100

FN_VWF_JUMP equ 0x0800D060
FN_VWF equ 0x087F5F30

; An entry point that other code can bl to.
.org FN_VWF_JUMP
.area 0x20
push lr
ldr r3, =(. + 0x09)
mov lr, r3
ldr r3, =FN_VWF
mov r15, r3
pop r1
bx r1
.pool
.endarea

; Function vwf():
; ARGS:
; r0 = 2 glyph values
; r1 = fg palette color
; r2 = bg palette color
; RET: number of full 8x8 blocks drawn to
L_fn_vwf:
.org FN_VWF
.area 0x200
pushreg

; Swap order of glyph values.
lsr r3, r0, 0x08
lsl r0, r0, 0x18
lsr r0, r0, 0x10
orr r0, r3

; Setup registers.
mov r6, 0x00 ; r6 = return value
mov r7, r0   ; r7 = glyph value
mov r8, r1   ; r8 = fg palette
mov r9, r2  ; r9 = bg palette

; Main loop.
@@L_loop:
; r5 = r7 & 0xFF, the next glyph value.
lsl r5, r7, 0x18
lsr r5, r5, 0x18

; Skip drawing if glyph value < 0x20 or >= 0x80.
cmp r5, 0x20
blt @@L_not_drawable
cmp r5, 0x80
blt @@L_drawable
@@L_not_drawable:
b @@L_loop_end
@@L_drawable:

; Write glyph to buffer
ldr r0, =ADDR_FONT
lsl r1, r5, 0x04
add r0, r0, r1
ldr r1, =ADDR_GLYPH_BUFFER
lsl r2, r6, 0x06
add r1, r1, r2
mov r2, r8
mov r3, r9
bl L_fn_write_glyph

; Update shift and return value.
ldr r0, =ADDR_WIDTHS
ldrb r0, [r0, r5]
add r0, 0x01 ; add 0x1 for space.
ldr r2, =ADDR_SHIFT
ldrb r1, [r2]
add r0, r0, r1 ; r0 = shift + width
mov r1, 0x07
and r1, r0
strb r1, [r2] ; shift = (shift + width) % 8
lsr r0, r0, 0x03
add r6, r0 ; ret += (shift + width) / 8

@@L_loop_end:
lsr r7, r7, 0x08
cmp r7, 0x00
beq @@L_return
b @@L_loop

@@L_return:
mov r0, r6
popreg
pop r1
bx r1
.pool

; Function write_glyph(): write glyph to buffer
; ARGS:
; r0 = glyph address
; r1 = destination address
; r2 = fg palette
; r3 = bg palette
; RET: N/A
L_fn_write_glyph:
pushreg
mov r9, r3 ; r9 = bg palette
mov r3, 0x00 ; r3 = loop counter
ldr r4, =ADDR_SHIFT
ldrb r4, [r4]
lsl r4, r4, 0x02 ; r4 = shift
mov r5, r0 ; r5 = glyph address
mov r6, r1 ; r6 = destination address
mov r7, r2 ; r7 = palette
mov r0, 0x20
sub r0, r0, r4
mov r8, r0 ; r8 = 0x20 - shift

@@L_loop:
; Convert 1bpp row to 4bpp row and store in r0
mov r0, 0x00
ldrb r1, [r5, r3]
mov r2, 0x80
@@L_1bpp_to_4bpp:
lsl r0, r0, 0x04
tst r1, r2
beq @@L_off
add r0, 0x01
@@L_off:
lsr r2, r2, 0x01
cmp r2, 0x00
bne @@L_1bpp_to_4bpp

; Convert 0's to 2's and 1's to palette value
ldr r1, =0x11111111
sub r1, r1, r0
mov r2, r9
mul r1, r2
mul r0, r7
add r0, r0, r1

; Shift and store first half of row
ldr r2, [r6]
mov r1, r8
lsl r2, r1
lsr r2, r1
mov r1, r0
lsl r1, r4
orr r2, r1
str r2, [r6]

; Shift and store second half of row
mov r1, r8
lsr r0, r1

mov r1, r9
lsl r1, r4
@@L_loop2:
orr r0, r1
lsl r1, 0x04
cmp r1, 0x00
bne @@L_loop2

str r0, [r6, 0x40]

add r6, 0x04
add r3, 0x01
cmp r3, 0x10
blt @@L_loop

popreg
pop r0
bx r0
.pool
.endarea

.close
