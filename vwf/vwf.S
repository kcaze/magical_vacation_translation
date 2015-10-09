; This is the variable width font routine. Inject this at 0x007DF750.
.gba
.open "hacked.gba", 0x08000000

;---------------------------------------------;
; Disable x-coordinate and tile index updates ;
;---------------------------------------------;
.org 0x0800BA74
nop

.org 0x0800C19C
nop

; Not quite sure about the following change.
.org 0x0800C218
mov r9, r4
add r2, r4, 0x02

.org 0x0800C248
nop

.org 0x0800C2E6
nop

.org 0x0800C2F2
nop

; What does this do???
.org 0x0800CFE8
bx r4

;----------------------;
; Insert the font data ;
;----------------------;
.org 0x086035AC
.incbin vwf/font.bin

;---------------------------------------------------------;
; Hijack the old glyph drawing routine and branch to ours ;
;---------------------------------------------------------;
.org 0x0800CFD8
mov r4, 0x08
lsl r4, r4, 0x08
add r4, 0x7D
lsl r4, r4, 0x08
add r4, 0xF7
lsl r4, r4, 0x08
add r4, 0x50
mov r15, r4

;------------------------;
; The actual VWF routine ;
;------------------------;
.org 0x087DF750
; Important Addresses
; -------------------
; 0x006035AC: Base address for 1bpp glyph tile data
; 0x020097B0: Base address for glyph tile data in WRAM. The nibbles
;             are stored in reverse orders. For example, 2FF22222 would
;             actually be copied into the tile data as 22222FF2.

; Function Parameters
; -------------------
; r0: Index into 0x086035AC of the glyph to draw

; Variables in RAM
; ----------------
; 0x02009930: x-coordinate in bg3 that we draw tile
; 0x02009954: Index into tile destination index to copy data from wram to.
; 0x0203FFF0: x offset to draw current glyph (1 byte)
; 0x0203FFF1: offset into previous character (1 byte)
; 0x0203FFF2: index of previous character into 0x0806035AC (1 byte)
;             set to 0 if no remaining part to draw

; Registers
; ---------
; r0: Passed in and preserved.
; r1 to r7: Scratch registers
; r8:
; r9: Holds the base address 0x020097B0 for glyph data in WRAM. (ADDR_WRAM_DEST)
; r10: Holds the base address 0x0203FFF0 for variables. (ADDR_WRAM_VAR)
; r12: Holds the base address 0x086035AC for glyph graphics data. (ADDR_GLYPH_BASE)

ADDR_WRAM_DEST equ =0x020097B0
ADDR_WRAM_VAR equ =0x0203FFF0
ADDR_GLYPH_BASE equ =0x086035AC

; 0x0203FFF0: x offset to draw current glyph (1 byte)
; 0x0203FFF1: offset into previous character (1 byte)
; 0x0203FFF2: index of previous character into 0x0806035AC (1 byte)
;             set to 0 if no remaining part to draw
VAR_CURRENT_X equ 0x00
VAR_PREVIOUS_X equ 0x01
VAR_PREVIOUS_GLYPH equ 0x02

GLYPH_BASE_OFFSET equ 0x00 ; offset into ADDR_GLYPH_BASE
WRAM_GLYPH_DATA_LENGTH equ 0xC0
GLYPH_LENGTH equ 0x40 ; number of bytes one glyph space takes up
GLYPH_NUM_ROWS equ 0x10 ; number of rows in one glyph

.macro return
  mov r15, r14
.endmacro

.macro clear_wram_glyph_data, startingOffset, clearLength
  mov r8, startingOffset
  mov r9, clearLength
  bl clear_wram_glyph_data_begin
.endmacro

; draw_previous_glyph
; input:
;   r8 -- offset into base address in WRAM at which to draw previous
;   r9 -- glyph to draw (index into ADDR_GLYPH_BASE)
;   r10 -- x-offset of glyph
; output:
;   r12 -- width of glyph drawn

.macro draw_previous_glyph, wramOffset, glyphValue, xOffset
  mov r8, wramOffset
  mov r9, glyphValue
  mov r10, xOffset
  bl draw_previous_glyph_begin
.endmacro

main_begin:
  ldr r6, ADDR_WRAM_VAR
  ldrb r1, [r6, VAR_PREVIOUS_GLYPH]
  cmp r1, 0x00
  beq tmp_branch

  mov r3, 0x00
  mov r4, GLYPH_LENGTH
  clear_wram_glyph_data r3, r4
  ldrb r2, [r6, VAR_PREVIOUS_X]
  draw_previous_glyph r3, r1, r2
  mov r3, r12
  add r3, 0x01
  strb r3, [r6, VAR_CURRENT_X]

  @@increment_tile_begin:
    mov r6, 0x02
    lsl r6, r6, 0x08
    add r6, 0x00
    lsl r6, r6, 0x08
    add r6, 0x99
    lsl r6, r6, 0x08
    add r6, 0x30
    ldrb r7, [r6]
    add r7, 0x1
    strb r7, [r6]
    add r6, 0x24
    ldrb r7, [r6]
    add r7, 0x2
    strb r7, [r6]
  @@increment_tile_end:

  tmp_branch:
main_end:

; Add column before next character
ldr r6, ADDR_WRAM_VAR ; 0x0203FFF0
ldrb r7, [r6, 0x0]
add r7, r7, 0x1
strb r7, [r6, 0x0]

draw_current_begin:
  ; r1 = Outer loop counter
  ; r2 = Inner loop counter
  ; r3 = Row of 2's and F's
  ; r4 = Row of 1 bpp glyph
  ; r5 = 4 * X-offset of current glyph (0x0203FFF0)

  ; Clear x offset and tile index for previous glyph
  ldr r6, ADDR_WRAM_VAR ; 0x0203FFF0
  mov r7, 0x8 ; Set to 8 since we're taking a minimum
  strb r7, [r6, 0x1]
  mov r7, 0x0
  strb r7, [r6, 0x2]

  mov r1, 0x0
  ldr r5, ADDR_WRAM_VAR ; 0x0203FFF0
  ldrb r5, [r5, 0x0]
  lsl r5, r5, 0x2

  draw_current_outer_loop_begin:
    mov r2, 0x0
    ldr r6, ADDR_WRAM_DEST ; 0x020097B0
    lsl r1, r1, 0x2
    ldr r3, [r6, r1]
    lsr r1, r1, 0x2

    ldr r6, ADDR_GLYPH_BASE ; 0x086035AC
    lsl r0, r0, 0x4
    add r6, r6, r0
    lsr r0, r0, 0x4
    ldrb r4, [r6, r1]

    draw_current_inner_loop_begin:
      mov r6, r4
      mov r7, 0x1
      and r6, r7
      cmp r6, 0x0
      beq draw_current_2_begin
      draw_current_F_begin:
        mov r6, 0xF
        lsl r6, r5
        lsl r2, r2, 0x2
        lsl r6, r2
        lsr r2, r2, 0x2
        orr r3, r6

        ; Update previous glyph offset
        cmp r6, 0x0 ; If r6 == 0, then there wasn't enough space
        bne current_update_current_glyph_offset_begin
        ldr r6, ADDR_WRAM_VAR ; 0x0203FFF0
        ldrb r7, [r6, 0x1]
        cmp r7, r2
        ble current_update_previous_glyph_offset_end
        current_update_previous_glyph_offset_begin:
          strb r2, [r6, 0x1]
          strb r0, [r6, 0x2]
        current_update_previous_glyph_offset_end:
        b current_update_current_glyph_offset_end

        current_update_current_glyph_offset_begin:
          lsr r5, r5, 0x2
          add r2, r2, r5
          add r2, 0x1
          ldr r6, ADDR_WRAM_VAR
          ldrb r7, [r6, 0x0]
          cmp r7, r2
          bge do_not_update_current_glyph_offset
          strb r2, [r6, 0x0]
          do_not_update_current_glyph_offset:
          sub r2, r2, r5
          sub r2, 0x1
          lsl r5, r5, 0x2
        current_update_current_glyph_offset_end:

        b draw_current_2_end
      draw_current_F_end:
      draw_current_2_begin:
        mov r6, 0x2
        lsl r6, r5
        lsl r2, r2, 0x2
        lsl r6, r2
        lsr r2, r2, 0x2
        orr r3, r6
      draw_current_2_end:
      lsr r4, r4, 0x1
      add r2, 0x1
      cmp r2, 0x8
      blt draw_current_inner_loop_begin
    draw_current_inner_loop_end:

    ldr r6, ADDR_WRAM_DEST ; 0x020097B0
    ; Multiply r1 by 4 since each row is 4 bytes long
    lsl r1, r1, 0x2
    str r3, [r6, r1]
    lsr r1, r1, 0x2
    add r1, 0x1
    cmp r1, 0x10
    blt draw_current_outer_loop_begin
  draw_current_outer_loop_end:
draw_current_end:

; Branch back to 0x0800D112 to return from the original function.
return:
  mov r7, 0x08
  lsl r7, r7, 0x08
  add r7, 0x00
  lsl r7, r7, 0x08
  add r7, 0xD1
  lsl r7, r7, 0x08
  add r7, 0x12
  mov r15, r7

clear_wram_glyph_data_begin:
  mov r7, r14
  push {r0-r7}
  @@addr_dest equ r0
  @@two equ r1
  @@counter equ r2
  @@starting_offset equ r3
  @@clear_length equ r4

  @@param_starting_offset equ r8
  @@param_clear_length equ r9

  @@initialize_begin:
    mov @@starting_offset, @@param_starting_offset
    mov @@clear_length, @@param_clear_length
    ldr @@addr_dest, ADDR_WRAM_DEST
    add @@addr_dest, @@addr_dest, @@starting_offset
    mov @@two, 0x22
    mov @@counter, 0x00
  @@initialize_end:

  @@loop_begin:
    strb @@two, [@@addr_dest, @@counter]
    add @@counter, 0x01
    cmp @@counter, @@clear_length
    blt @@loop_begin
  @@loop_end:

  pop {r0-r7}
  mov r14, r7
  return
clear_wram_glyph_data_end:

draw_previous_glyph_begin:
  mov r7, r14
  push {r0-r7}

  @@y equ r0
  @@x equ r1
  @@row_ram equ r2
  @@row_1bpp equ r3
  @@addr_dest equ r4
  @@addr_glyph equ r5
  @@scratch1 equ r6
  @@scratch2 equ r7
  @@param_starting_offset equ r8;
  @@param_glyph equ r9;
  @@param_x_offset equ r10;
  @@return_value equ r12

  @@initialize_begin:
    mov @@y, 0x0  0

    ldr @@addr_glyph, ADDR_GLYPH_BASE
    mov @@scratch1, @@param_glyph
    lsl @@scratch1, @@scratch1, 0x04
    add @@addr_glyph, @@addr_glyph, @@scratch1

    ldr @@addr_dest, ADDR_WRAM_DEST
    mov @@scratch1, @@param_starting_offset
    add @@addr_dest, @@addr_dest, @@scratch1

    mov @@scratch1, 0x00
    mov @@return_value, @@scratch1
  @@initialize_end:

  @@glyph_loop_begin:
    mov @@x, 0x00
    ldr @@row_ram, [@@addr_dest]
    ldrb @@row_1bpp, [@@addr_glyph]

    ; Offset the glyph
    mov @@scratch1, r10
    lsr @@row_1bpp, @@scratch1

    @@row_loop_begin:
      mov @@scratch1, 0x01
      and @@scratch1, @@row_1bpp
      cmp @@scratch1, 0x00
      beq @@draw_F_end
      @@draw_F_begin:
        ; Amount to shift the F over by in @@scratch1
        mov @@scratch1, @@x
        lsl @@scratch1, 0x02
        mov @@scratch2, 0x0F
        lsl @@scratch2, @@scratch1
        orr @@row_ram, @@scratch2

        ; Update return value
        cmp @@x, @@return_value
        ble @@draw_F_end
        mov @@return_value, @@x
      @@draw_F_end:
      lsr @@row_1bpp, @@row_1bpp, 0x01
      add @@x, 0x01
      cmp @@x, 0x08
      blt @@row_loop_begin
    @@row_loop_end:
    str @@row_ram, [@@addr_dest]

    add @@addr_dest, 0x04
    add @@addr_glyph, @@addr_glyph, 0x01

    add @@y, @@y, 0x01
    cmp @@y, GLYPH_NUM_ROWS
    blt @@glyph_loop_begin
  @@glyph_loop_end:

  pop {r0-r7}
  mov r14, r7
  return
draw_previous_glyph_end:

; TODO: There should probably be a .org directive before the .pool
.pool

.close
