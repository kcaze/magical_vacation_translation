; This is the sprite variable width font routine.
.gba
.open "hacked.gba", 0x08000000

;---------------------------------------------;
; Hijack the routine at 0x080BEBD8 to use ours.
;---------------------------------------------;
.org 0x080BEBE0
mov r2, 0x08
lsl r2, r2, 0x08
add r2, 0x7E
lsl r2, r2, 0x08
add r2, 0x1B
lsl r2, r2, 0x08
add r2, 0x00
mov r15, r2

; Addresses
; ----------
; 0x087DF900: Table storing widths of each character

; Variables in RAM
; ----------------
; 0x0203FFF4: offset into previous character (1 byte)
; 0x0203FFF5: index of previous character into 0x0806035AC (1 byte)
;             set to 0 if no remaining part to draw
.org 0x087E1B00

; Registers that can't be touched: r1, r4, r5, r6, r13.
mov r0, 0xFF
and r3, r0
lsl r3, 0x04
ldr r0, =0x086039AC
add r0, r0, r3
ldr r2, [r0]
str r2, [sp]
ldr r2, [r0, 0x04]
str r2, [sp, 0x04]
ldr r2, [r0, 0x08]
str r2, [sp, 0x10]
ldr r2, [r0, 0x0C]
str r2, [sp, 0x14]
mov r2, 0x00
str r2, [sp, 0x08]
str r2, [sp, 0x0C]
str r2, [sp, 0x18]
str r2, [sp, 0x1C]

; Branch back to 0x080BEC0C to restore execution to the game
return:
  add r5, sp, 0x10 ; Necessary in the original function, but branched over.
  ldr r0, =0x080BEC0C
  mov r15, r0
.pool

.close
