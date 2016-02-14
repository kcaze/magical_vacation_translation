; This guts the text draw routine 0x0800C8C8 - 0x0800C9E8.
; The battle 1 routine is called from two locations:
;   0x0800C4F4: This draws the name of the currently selected character.
;   0x0800C882: This draws text for items and spells when scrolling up or down.

; The routine takes 6 arguments:
;  r0 = Pointer to beginning of text
;  r1 = Pointer to end of text
;  r2 = Pointer to stack space to draw text to.
;  r3 = Palette. Actually, 0xF - r3 is the correct palette value to use.
;  [sp, 0x00] = x-coordinate in pixels. necessary for icons.
;  [sp, 0x04] = y-coordinate in pixels.
;
; The routine should draw the text data to the stack space pointed to in r2 and
; return the number of bytes the text takes up.

.gba
.open "hacked.gba", 0x08000000

FN_RAM_CLEAR equ 0x0800D020
FN_VWF equ 0x0800D060
FN_ICON equ 0x0800D370

ADDR_GLYPH  equ 0x020097B0
ADDR_DMA    equ 0x040000D4
START equ 0x0800C8D2
END equ 0x0800C9DC

.org START
.area END - START
; Setup registers
mov r4, 0x00 ; r4 = eventual return value
mov r5, 0x0F
sub r5, r5, r3 ; r5 = palette
mov r6, r2 ; r6 = stack pointer
mov r7, r0 ; r7 = pointer to text
mov r8, r1 ; r8 = pointer to end of text

; Clear RAM
mov r0, 0x02
bl FN_RAM_CLEAR

L_loop:
ldrb r0, [r7]
lsl r0, r0, 0x08
ldrb r1, [r7, 0x01]
add r0, r0, r1
cmp r0, 0x0F
bgt L_not_icon

; Draw icon
mov r2, r0
ldr r0, [sp, 0x20]
ldr r1, [sp, 0x24]
bl FN_ICON
ldr r0, =0x22222222
str r0, [r6]
ldr r0, =ADDR_DMA
str r6, [r0]
str r6, [r0, 0x4]
ldr r1, =0x81000040
str r1, [r0, 0x8]
ldr r1, [r0, 0x8]
add r6, 0x80
add r4, 0x02
b L_loop_end

; Call vwf
L_not_icon:
mov r1, r5
mov r2, 0x02 ; bg palette
bl FN_VWF

; Copy from ADDR_GLYPH to stack space then update return value and stack pointer
ldr r1, =ADDR_DMA
ldr r2, =ADDR_GLYPH
str r2, [r1]
str r6, [r1, 0x04]
ldr r2, =0x800000C0
str r2, [r1, 0x08]
ldr r2, [r1, 0x08]
add r4, r4, r0
lsl r3, r0, 0x06
add r6, r6, r3

; Update ADDR_GLYPH
ldr r2, =ADDR_GLYPH
add r3, r2, r3
str r3, [r1]
str r2, [r1, 0x04]
ldr r3, =0x80000040
str r3, [r1, 0x08]
ldr r3, [r1, 0x08]
add r2, 0x40
ldr r3, =0x22222222
str r3, [r2]
str r2, [r1]
str r2, [r1, 0x04]
ldr r3, =0x81000040
str r3, [r1, 0x08]
ldr r3, [r1, 0x08]

L_loop_end:
add r7, 0x02
cmp r7, r8
blt L_loop

L_return:
lsl r0, r4, 0x06
add r0, 0x40
b END
.pool
.endarea
.close
