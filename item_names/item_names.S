.gba
.open "hacked.gba", 0x08000000

; Disable DMA transfers
.org 0x080A0BCA
nop

.org 0x080A0BF6
nop

; Stop the glyph value from being truncated
.org 0x080B61CE
nop
nop

.org 0x080B62FE
; r1 = ([r0]-0x06008000)/2, the tile index.
ldr r1, [r0]
ldr r0, =0x06008000
sub r1, r1, r0
lsr r1, r1, 0x05

; If (r1 - 0x0203CF80)/2 == 0, then it's an empty call so exit
; immediately.
cmp r1, 0x00
beq 0x080B6372

; Hijack the routine at 0x080B62F4 to jump to ours
ldr r0, =0x087E1C00
mov r15, r0
.pool

;-----------------------------;
; Beginning of my VWF routine ;
; =========================== ;
; Parameters passed in        ;
; r1: tile index              ;
; r2: glyph value             ;
;-----------------------------;
.org 0x087E1C00
; INVARIANTS: r5 = glyph value, r6 = RAM address 0x0203FFF4
mov r5, r2
ldr r6, =0x0203FFF4
ldrb r3, [r6, 0x04]
cmp r3, 0x00
bne not_string
; Update the tile index in RAM and set inside_string flag.
strh r1, [r6, 0x00]
mov r1, 0x01
strb r1, [r6, 0x04]
not_string:

draw_glyph:
; Copy remaining. This will work even for the last glyph, since
; we have are guaranteed an EOS character.
;ldrb r1, [r6,] 

; Set r2 to the address of the first glyph
mov r0, 0xFF
mov r2, r5
and r2, r0
; Set flag on end-of-string character, 0x1F
cmp r2, 0x1F
bne not_eos
mov r1, 0x00
strb r1, [r6, 0x04]
not_eos:
lsl r2, r2, 0x04
ldr r0, =0x08603900
add r2, r2, r0

; Copy top half of the 1bpp data onto stack
ldr r0, [r2, 0x00]
str r0, [sp, 0x00]
ldr r0, [r2, 0x04]
str r0, [sp, 0x04]

; Copy bottom half of the 1bpp data onto stack
ldr r0, [r2, 0x08]
str r0, [sp, 0x08]
ldr r0, [r2, 0x0C]
str r0, [sp, 0x0C]

; Clear the RAM.
mov r0, 0x00
mov r1, 0x00
ldr r2, =0x0203692C
loop:
  str r1, [r2, r0]
  add r0, 0x04
  cmp r0, 0x40
  blt loop

ldr r0, =0x0203692C
mov r1, sp
mov r2, 0x0F
mov r3, 0x01 ; Number of 8x8 blocks to translate

; The following essentially does the same thing as
; bl 0x080BEC2C.
mov r4, pc
add r4, r4, 0x7
mov lr, r4
ldr r4, =0x80BEC2C
mov pc, r4

ldr r0, =0x0203694C
mov r1, sp
add r1, 0x08
mov r2, 0x0F
mov r3, 0x01 ; Number of 8x8 blocks to translate

; The following essentially does the same thing as
; bl 0x080BEC2C.
mov r4, pc
add r4, r4, 0x7
mov lr, r4
ldr r4, =0x80BEC2C
mov pc, r4

; DMA top half
ldr r0, =0x040000D4
; Store the RAM source
ldr r1, =0x0203692C
str r1, [r0, 0x00]
; Compute and store the tile destination
ldr r1, =0x06008000
ldrh r2, [r6, 0x00]
lsl r2, r2, 0x05
add r1, r1, r2
str r1, [r0, 0x04]
; Initiate DMA
ldr r1, =0x80000010
str r1, [r0, 0x08]
ldr r1, [r0, 0x08]

; DMA second half
ldr r0, =0x040000D4
; Store the RAM source
ldr r1, =0x0203694C
str r1, [r0, 0x00]
; Compute and store the tile destination
ldr r1, =0x06008000
ldrh r2, [r6, 0x00]
lsl r2, r2, 0x05
add r1, r1, r2
ldr r2, =0x0400
add r1, r2
str r1, [r0, 0x04]
ldr r1, =0x80000010
str r1, [r0, 0x08]
ldr r1, [r0, 0x08]

; Increment tile index
ldrh r1, [r6, 0x00]
add r1, 0x01
strh r1, [r6, 0x00]

lsr r5, r5, 0x08
cmp r5, 0x00
bne draw_glyph

return:
ldr r0, =0x080B6372
mov r15, r0

.pool

; Disable x-coordinate update
; .org 0x080B64BC
; nop

.close
