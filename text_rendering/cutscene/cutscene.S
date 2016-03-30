.gba
.open "hacked.gba", 0x08000000

ADDR_FONT equ 0x086C8A3C
ADDR_DMA    equ 0x040000D4
FN_CUTSCENE equ 0x08810200 ;TODO -- Remap addresses at the end

.org 0x0809B1D0
mov r1, 0x42 ; really stupid hack since there's no space. set r1 = 0x42 to indicate we're in normal glyph case.
ldr r0, =FN_CUTSCENE
mov r15, r0
.pool

.org FN_CUTSCENE
cmp r1, 0x42
beq L_normal_glyph

L_control_code:
add r7, r7, 0x01
add r5, 0x02
add r6, 0x02
cmp r7, r8
ldr r0, =0x0809B1DF
mov r15, r0

L_normal_glyph:
mov r0, 0xFF
and r0, r2
lsl r0, r0, 0x08
strh r0, [r5]
lsr r0, r2, 0x08
lsl r0, r0, 0x08
strh r0, [r5, 0x02]
add r7, r7, 0x01
add r5, 0x04
add r6, 0x02
cmp r7, r8
ldr r0, =0x0809B1DF
mov r15, r0
.pool

; Have the game treat glyphs less than 0xF0F0 as valid glyphs.
.org 0x0809B128
.word 0x0000F0F0
.org 0x0809B370
.word 0x0000F0F0

; Increment number of glyphs by 2
;.org 0x0809B59A
;add r0, 0x2

; Increment glyph stuff by 2 times 0x40
;.org 0x0809B474
;add r0, 0x80
;.org 0x0809B4C8
;add r1, 0x80

; Need to double the increment from 0x88 to 0x110. To get the immediate value
; 0x110 we use a PC relative offset load.
;.org 0x0809B466
;.halfword 0x4B9F ; ldr r3, =0x110 using the pool at 0x0809B6E4
;add r3, r9

;.org 0x0809B6DA ; Jump to our cutscene function
;ldr r4, =FN_CUTSCENE
;mov r15, r4
;.pool
; Using the extra space we have here as a pool for modifying 0x0809B2B0
;.org 0x0809B6E4
;.word 0x00000110

; r1 = destination
; r2 = glyph values
;.org FN_CUTSCENE ; Copy glyphs
;add r4, r1, 0x04
;mov r3, r2

; Set second glyph's tile address
;ldr r0, [r1]
;add r0, 0x40
;add r1, 0x88
;str r0, [r1]

; Glyph 1
;lsr r0, r3, 0x08
;ldr r1, =ADDR_FONT ; For a glyph of value 0xMN, the address is M*0x800 + N*0x040
;lsr r2, r0, 0x04
;lsl r2, r2, 0x0B
;add r1, r1, r2
;mov r2, 0x0F
;and r2, r0
;lsl r2, r2, 0x06
;add r1, r1, r2
;ldr r2, =0x80000020
;ldr r0, =ADDR_DMA
;str r1, [r0]
;str r4, [r0, 0x04]
;str r2, [r0, 0x08]
;ldr r2, [r0, 0x08]

;mov r2, 0x01
;lsl r2, 0x0A
;add r1, r1, r2
;add r4, 0x40
;ldr r2, =0x80000020
;str r1, [r0]
;str r4, [r0, 0x04]
;str r2, [r0, 0x08]
;ldr r2, [r0, 0x08]

; Glyph 2
;add r4, 0x48
;mov r0, 0xFF
;and r0, r3
;ldr r1, =ADDR_FONT ; For a glyph of value 0xMN, the address is M*0x800 + N*0x040
;lsr r2, r0, 0x04
;lsl r2, r2, 0x0B
;add r1, r1, r2
;mov r2, 0x0F
;and r2, r0
;lsl r2, r2, 0x06
;add r1, r1, r2
;ldr r2, =0x80000020
;ldr r0, =ADDR_DMA
;str r1, [r0]
;str r4, [r0, 0x04]
;str r2, [r0, 0x08]
;ldr r2, [r0, 0x08]

;mov r2, 0x01
;lsl r2, 0x0A
;add r1, r1, r2
;add r4, 0x40
;ldr r2, =0x80000020
;str r1, [r0]
;str r4, [r0, 0x04]
;str r2, [r0, 0x08]
;ldr r2, [r0, 0x08]


;ldr r0, =0x0809B711
;mov r15, r0

;.pool

.close
