; 0x0203AC9C to ...: An array of data structure {
;   4 bytes: script beginning address, will read until FFFF
;   2 bytes: x coord in tiles
;   2 bytes: y coord in tiles
;   4 bytes: some packed bitfield. stores palette info for sure.
; }
; 0x0203B6CC: Length of the array of data structures beginning at 0x0203AC9C
; 0x080B57D8: This routine appends an element to the array of data structures.
;   r0 = x coord in tiles
;   r1 = y coord in tiles
;   r2 = script begin address
;   r3 = 0xFFFFFFFF (???)
;   [sp, 0x00] = ??? (looks like it's always 0x14, perhaps the width of screen?)
;   [sp, 0x04] = palette color
;   This routine is going to be entirely gutted and used to store everything in
;   2d array in 0x02036604.
; 0x080B5CFC: This routine takes the array at 0x0203AC9C, parses it and
;   transforms it into 4 byte glyph values to store in the 10x20 array in 0x02036604.
;   This is going to be bypassed entirely. We're gutting 0x080B57D8 to process everything and store it in the
;   2d array.
; 0x02036604: A 10x20 array of 4 byte words. Each glyph is 12 pixels wide, 16 pixels tall
;   in calculations. Hence, 20 elements per row = 240 pixels wide and 10 elements tall =
;   160 pixels tall. Glyph values are stored as 4 byte words for some reason. The 4th nibble
;   indicates the palette value to use for that glyph, since no drawable Japanese glyphs went
;   beyond 0x0FFF.
; 0x080B6108: This routine takes the 2d array of glyph values in 0x02036604, renders them
;   to tiles2 and then sets up the tilemap for BG1 in RAM at 0x0203CF80. This routine is
;   called 4 times, with the number of glyphs to process passed in as r1. We're going to
;   gut this completely since the format of the 2d array will be changed. We need to make
;   sure the values at 0x0203B6CA are zeroed out so our routine isn't called 4 times.

; 0x080A0DEC: General purpose copy routine. Called at 0x080A0C66 to copy from ram to
;   bg1.

FN_RAM_CLEAR equ 0x0800D020
FN_VWF equ 0x0800D060
FN_ICON equ 0x0800D370

ADDR_GLYPH_BUFFER  equ 0x020097B0
ADDR_TILE    equ 0x06008000
ADDR_RAM_BG1    equ 0x0203CF80
ADDR_SCRIPT_ARRAY equ 0x02036604
FN_MENU_START equ 0x080B6152
FN_MENU_END equ 0x080B6258

FN_PROCESS_SCRIPT_START equ 0x080B57E2
FN_PROCESS_SCRIPT_END equ 0x080B583E

; Function process_script():
; ARGS:
;   r0 = x coord in tiles
;   r1 = y coord in tiles
;   r2 = script begin address
;   r3 = 0xFFFFFFFF (???)
;   [sp, 0x20] = ??? (looks like it's always 0x14, perhaps the width of screen?)
;   [sp, 0x24] = palette color
; RET: N/A
.org FN_PROCESS_SCRIPT_START
L_process_script:
.area FN_PROCESS_SCRIPT_END - FN_PROCESS_SCRIPT_START
ldr r3, [sp, 0x24]
bl L_vwf_menu
b FN_PROCESS_SCRIPT_END
.pool
.endarea

; Function vwf_menu():
; ARGS:
;   r0 = x coord in tiles (in units of 8)
;   r1 = y coord in tiles (in units of 16)
;   r2 = script begin address
;   r3 = palette color
; RET: N/A
.org FN_MENU_START
L_vwf_menu:
.area FN_MENU_END - FN_MENU_START
pushreg

; Setup registers
mov r5, r0 ; r5 = x coord
mov r6, r1 ; r6 = y coord
mov r7, r2 ; r7 = script address
mov r8, r3 ; r8 = palette
mov r9, r0 ; r9 = original x coord

; Clear ram
mov r0, 0x00
bl FN_RAM_CLEAR

@@L_loop:
; Call vwf(), handling the special end of script 0xFFFF and newline 0xFEFF
ldrh r0, [r7]
lsr r1, r0, 0x08
lsl r0, r0, 0x18
lsr r0, r0, 0x10
orr r0, r1
ldr r1, =0xFFFF
cmp r0, r1
beq @@L_return
ldr r1, =0xFEFF
cmp r0, r1
bne @@L_not_newline

; Handle newlines
mov r0, 0x00
bl FN_RAM_CLEAR
add r6, 0x01
mov r5, r9
b @@L_loop_end

@@L_not_newline:
mov r1, r8
mov r2, 0x00
bl FN_VWF
mov r10, r0 ; r10 = return value

; Update bg map
mov r4, r10
@@L_bg_map_loop:
ldr r0, =ADDR_RAM_BG1
mov r1, 0x3C
mul r1, r6
add r1, r1, r4
add r1, r1, r5
lsl r1, r1, 0x01
lsl r2, r6, 0x06
add r2, r2, r4
add r2, r2, r5
strh r2, [r0, r1]
add r1, 0x3C
add r2, 0x20
strh r2, [r0, r1]

sub r4, 0x01
cmp r4, 0x00
bge @@L_bg_map_loop

mov r4, r10
; Copy glyph data to tiles
@@L_copy_to_tile_loop:
ldr r0, =ADDR_DMA
ldr r1, =ADDR_GLYPH_BUFFER
lsl r2, r4, 0x06
add r1, r1, r2
str r1, [r0, 0x00]
ldr r2, =ADDR_TILE
add r3, r4, r5
lsl r3, r3, 0x05
add r2, r2, r3
lsl r3, r6, 0x0B
add r2, r2, r3
str r2, [r0, 0x04]
ldr r3, =0x80000010
str r3, [r0, 0x08]

add r1, 0x20
ldr r3, =0x0400
add r2, r2, r3
str r1, [r0, 0x00]
str r2, [r0, 0x04]
ldr r3, =0x80000010
str r3, [r0, 0x08]

sub r4, 0x01
cmp r4, 0x00
bge @@L_copy_to_tile_loop

; Update glyph buffer
mov r0, r10
ldr r1, =ADDR_DMA
ldr r2, =ADDR_GLYPH_BUFFER
lsl r3, r0, 0x06
add r3, r2, r3
str r3, [r1]
str r2, [r1, 0x04]
ldr r3, =0x80000040
str r3, [r1, 0x08]
ldr r3, [r1, 0x08]
add r2, 0x40
mov r3, 0x00
str r3, [r2]
str r2, [r1]
str r2, [r1, 0x04]
ldr r3, =0x81000080
str r3, [r1, 0x08]
ldr r3, [r1, 0x08]

add r5, r10

@@L_loop_end:
add r7, 0x02
b @@L_loop

@@L_return:
; Increment 0x0203B6CC to force the rest of the rendering to happen normally
ldr r0, =0x0203B6CC
ldrb r1, [r0]
add r1, 0x01
strb r1, [r0]
popreg
pop r0
bx r0
.pool
.endarea

; Dummy out this function
.org 0x080B6108
pushreg
ldr r0, =0x0203B6CC
mov r1, 0x00
strb r1, [r0]
popreg
.pool

; 0x080B6108: This routine takes the 2d array of glyph values in 0x02036604, renders them
