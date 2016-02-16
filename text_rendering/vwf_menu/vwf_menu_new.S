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
;   This is going to be bypassed entirely. We're gutting 0x080B57D8 to process everything and store it in them
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

; New format for 0x02036604: The first word will be the length of 0x02036604.
; Then we'll be storing each script section in an 8 byte value {
;   x coord in tiles [1 byte]
;   y coord in tiles [1 byte]
;   palette [1 byte]
;   empty [1 byte]
;   script beginning address [4 bytes]
; }

FN_RAM_CLEAR equ 0x0800D020
FN_VWF equ 0x0800D060
FN_ICON equ 0x0800D370

ADDR_GLYPH  equ 0x020097B0
ADDR_TILE    equ 0x06008000
ADDR_RAM_BG1    equ 0x0203CF80
ADDR_SCRIPT_ARRAY equ 0x02036604
FN_MENU_START equ 0x080B6112
FN_MENU_END equ 0x080B6258

FN_PROCESS_SCRIPT_START equ 0x080B57E2
FN_PROCESS_SCRIPT_END equ 0x080B583E

; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ;
; ACTUALLY, JUST MAKE process_script() DO ALL THE ;
; LIFTING AND AVOID ALL OTHER CALLS! WE HAVE ALL  ;
; THE INFORMATION WE NEED HERE SO I THINK WE'RE   ;
; GOOD! THE ONLY ISSUE IS WHERE TO CLEAR THE      ;
; TILEMAP?                                        ;
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ;
; Function process_script():
; ARGS:
;   r0 = x coord in tiles
;   r1 = y coord in tiles
;   r2 = script begin address
;   r3 = 0xFFFFFFFF (???)
;   [sp, 0x20] = ??? (looks like it's always 0x14, perhaps the width of screen?)
;   [sp, 0x24] = palette color
; RET: N/A
L_process_script:
.org FN_PROCESS_SCRIPT_START
.area FN_PROCESS_SCRIPT_END - FN_PROCESS_SCRIPT_START
bl
mov r4, r0 ; r4 = x coord
mov r5, r1 ; r5 = y coord
mov r6, r2 ; r6 = script address
ldr r7, [sp, 0x24] ; r7 = palette color

; Increment length of script array and get address to write new entry to.
ldr r0, =ADDR_SCRIPT_ARRAY
ldr r1, [r0]
add r2, r1, 0x01
str r2, [r0]
lsl r1, 0x03
add r0, 0x04
add r0, r0, r1

; Store data
strb r4, [r0]
strb r5, [r0, 0x01]
strb r7, [r0, 0x02]
str r6, [r0, 0x04]

b FN_PROCESS_SCRIPT_END
.pool
.endarea

L_vwf_menu:
.org FN_MENU_START
.area FN_MENU_END - FN_MENU_START
mov r7, 0x00 ; r7 = outer loop counter
mov r8, r0 ; r8 = glyph address

; Clear bg1 in RAM.
ldr r0, =ADDR_RAM_BG1
mov r1, 0x00
str r1, [r0]
ldr r1, =ADDR_DMA
str r0, [r1]
str r0, [r1, 0x04]
ldr r0, =0x81000258
str r0, [r1, 0x08]
ldr r0, [r1, 0x08]

@@L_loop:
mov r0, 0x00
bl FN_RAM_CLEAR

mov r5, 0xFF ; r5 = x tile coordinate
mov r6, 0x00 ; r6 = inner loop counter
@@L_inner_loop:
mov r0, r8
ldr r0, [r0]
lsl r0, 0x10
lsr r0, 0x10
cmp r0, 0x00
beq @@L_inner_loop_end
cmp r5, 0xFF
bne @@L_not_first_nonzero
mov r5, r6
@@L_not_first_nonzero:

mov r1, 0x0F ;TODO currently hardcoding palette value. Need to find where this stored.
mov r2, 0x00 ; bg palette
bl FN_VWF
mov r9, r0 ; r9 = copy of return value

; copy glyph data to tiles
@@L_tile_loop:
; DMA glyph data to tiles2
ldr r2, =ADDR_GLYPH
lsl r1, r0, 0x06
add r2, r2, r1 ; r2 = glyph address
ldr r3, =ADDR_TILE
add r1, r5, r0
lsl r1, r1, 0x05
add r3, r3, r1
lsl r1, r7, 0x0B
add r3, r3, r1 ; r3 = tile address
ldr r4, =ADDR_DMA
str r2, [r4]
str r3, [r4, 0x04]
ldr r1, =0x80000010
str r1, [r4, 0x08]
ldr r1, [r4, 0x08]

add r2, 0x20
ldr r1, =0x0400
add r3, r3, r1
str r2, [r4]
str r3, [r4, 0x04]
ldr r1, =0x80000010
str r1, [r4, 0x08]
ldr r1, [r4, 0x08]

; Update bg1 in RAM.
ldr r1, =ADDR_RAM_BG1
add r2, r5, r0
mov r3, 0x1E
mul r3, r7
lsl r3, r3, 0x01
add r3, r3, r2
lsl r3, 0x01
lsl r4, r7, 0x06
add r2, r2, r4
strh r2, [r1, r3]
mov r4, 0x1E
lsl r4, r4, 0x01
add r3, r3, r4
mov r4, 0x01
lsl r4, r4, 0x05
add r2, r2, r4
strh r2, [r1, r3]

sub r0, 0x01
cmp r0, 0x00
bge @@L_tile_loop

; Update ADDR_GLYPH
mov r0, r9
lsl r3, r0, 0x06
ldr r1, =ADDR_DMA
ldr r2, =ADDR_GLYPH
add r3, r2, r3
str r3, [r1]
str r2, [r1, 0x04]
ldr r3, =0x80000020
str r3, [r1, 0x08]
ldr r3, [r1, 0x08]
add r2, 0x40
mov r3, 0x00
str r3, [r2]
str r2, [r1]
str r2, [r1, 0x04]
ldr r3, =0x81000040
str r3, [r1, 0x08]
ldr r3, [r1, 0x08]

; Update x tile coordinate
add r5, r5, r0

@@L_inner_loop_end:
mov r0, r8
add r0, 0x04
mov r8, r0
add r6, 0x01
cmp r6, 0x14
blt @@L_inner_loop

add r7, 0x01
cmp r7, 0x0A
blt @@L_loop

@@L_return:
; Clear 0x0203B6CA so that this subroutine isn't called 4 times.
mov r0, 0x00
ldr r1, =0x0203B6C6
strh r0, [r1]
strh r0, [r1, 0x02]
strb r0, [r1, 0x05]
b FN_MENU_END

.pool
.close
