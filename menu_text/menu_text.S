.gba
.open "hacked.gba", 0x08000000

; Insert translated menu text
.org 0x087C229C
.incbin menu_text/menu_text.bin

; Disable the check that aborts drawing if a glyph has value > 0x0FFF
.org 0x080B659C
b 0x80B65C4

; Edit the x increment for sprites to be 0x10 instead of 0x0C. This way,
; sprites don't overlap.
.org 0x080B681C
add r0, 0x10

; NOTE: Registers that can't be modified: r1, r4, r5, r6, r13.
; If any of these are modified, then things break when we return.

; Hijack the routine at 0x080BEBD8 to jump to ours
.org 0x080BEBE0
mov r2, 0x08
lsl r2, r2, 0x08
add r2, 0x7E
lsl r2, r2, 0x08
add r2, 0x1B
lsl r2, r2, 0x08
add r2, 0x00
mov r15, r2

; Our custom drawing routine
.org 0x087E1B00
glyph1:
mov r2, r3
lsr r2, 0x08
lsl r2, 0x04
ldr r0, =0x08604200
add r0, r0, r2
ldr r2, [r0, 0x00]
str r2, [sp, 0x00]
ldr r2, [r0, 0x04]
str r2, [sp, 0x04]
ldr r2, [r0, 0x08]
str r2, [sp, 0x10]
ldr r2, [r0, 0x0C]
str r2, [sp, 0x14]

glyph2:
mov r0, 0xFF
mov r2, r3
and r2, r0
lsl r2, 0x04
ldr r0, =0x08604200
add r0, r0, r2
ldr r2, [r0, 0x00]
str r2, [sp, 0x08]
ldr r2, [r0, 0x04]
str r2, [sp, 0x0C]
ldr r2, [r0, 0x08]
str r2, [sp, 0x18]
ldr r2, [r0, 0x0C]
str r2, [sp, 0x1C]

; Branch back to 0x080BEC0C to restore execution to the game
return:
  add r5, sp, 0x10 ; Necessary in the original function, but branched over.
  ldr r0, =0x080BEC0C
  mov r15, r0
  
.pool

.close
