; This is the variable width font routine. Inject this at 0x007DF750
.gba
.open "hacked.gba", 0x08000000

;-----------------------------------------------------;
; Change script to read 1 byte at a time instead of 2 ;
;-----------------------------------------------------;
.org 0x0800C18C
add r0, 0x02

;---------------------------------------------------;
; Disable dma, x-coordinate, and tile index updates ;
;---------------------------------------------------;
.org 0x0800BA74
nop

.org 0x0800C19C
nop

.org 0x0800C1AE
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
; Our vwf glyph data is offset by 0x100 so we inject at 0x086035AC + 0x400 =
; 0x086039AC
.org 0x086039AC
.incbin vwf/font.bin

; This is used to hijack the old glyph drawing routine and use ours.
.org 0x0800CFD8
mov r4, 0x08
lsl r4, r4, 0x08
add r4, 0x7D
lsl r4, r4, 0x08
add r4, 0xF7
lsl r4, r4, 0x08
add r4, 0x50
mov r15, r4

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
; 0x0203FFF3: flag set to 1 if need to shift right 1 pixel when drawing previous
;             character

; Registers
; ---------
; r0: Passed in and preserved.
; r1 to r7: Scratch registers
; r8:
; r9: Holds the base address 0x020097B0 for glyph data in WRAM.
; r10: Holds the base address 0x0203FFF0 for variables.
; r12: Holds the base address 0x086035AC for glyph graphics data.

load_addresses_begin:
  ; Move 0x020097B0 into r9.
  mov r1, 0x02
  lsl r1, r1, 0x08
  add r1, 0x00
  lsl r1, r1, 0x08
  add r1, 0x97
  lsl r1, r1, 0x08
  add r1, 0xB0
  mov r9, r1

  ; Move 0x0203FFF0 into r10.
  mov r1, 0x02
  lsl r1, r1, 0x08
  add r1, 0x03
  lsl r1, r1, 0x08
  add r1, 0xFF
  lsl r1, r1, 0x08
  add r1, 0xF0
  mov r10, r1

  ; Move 0x086039AC into r12.
  mov r1, 0x08
  lsl r1, r1, 0x08
  add r1, 0x60
  lsl r1, r1, 0x08
  add r1, 0x39
  lsl r1, r1, 0x08
  add r1, 0xAC
  mov r12, r1
load_addresses_end:

draw_glyph_begin:
  draw_previous_begin:
    ; Nothing to draw if the glyph number is 0.
    mov r6, r10 ; 0x0203FFF0
    ldrb r6, [r6, 0x2]
    cmp r6, 0x0
    beq draw_previous_end

    ; Handle spaces correctly by setting x offset for current glyph to 1.
    cmp r6, 0x14
    bne update_space_end
    update_space_begin:
      mov r7, 0x1
      strb r7, [r6, 0x0]
      b draw_previous_end
    update_space_end:

    ; Clear x offset for current glyph
    mov r6, r10
    mov r7, 0x0
    strb r7, [r6, 0x0]


    ; r1 = Outer loop counter
    ; r2 = Inner loop counter
    ; r3 = Row of 2's and F's
    ; r4 = Row of 1 bpp glyph
    ; r5 = X-offset of previous glyph (0x0203FFF1)

    mov r1, 0x0
    mov r5, r10 ; 0x0203FFF0
    ldrb r5, [r5, 0x1] ; X-offset of previous glyph

    draw_previous_outer_loop_begin:
      mov r2, 0x8 ; We decrement r2
      mov r3, 0x0
      mov r6, r12 ; 0x086039AC
      mov r7, r10 ; 0x0203FFF0

      ldrb r7, [r7, 0x2] ; Index of previous glyph
      lsl r7, r7, 0x4
      add r6, r6, r7
      ldrb r4, [r6, r1]

      mov r7, r10 ; 0x0203FFF0
      ldrb r7, [r7, 0x3] ; Flag for shifting left or not.
      cmp r7, 0x01
      beq shift_left
      shift_right:
        lsr r4, r5
        b end_shift
      shift_left:
        lsl r4, r4, 0x01
      end_shift:

      draw_previous_inner_loop_begin:
        lsl r3, r3, 0x4
        mov r6, r4
        mov r7, 0x80
        and r6, r7
        cmp r6, 0x0
        beq write_2_begin
        write_F_begin:
          add r3, 0xF
          ; Update current glyph offset
          mov r6, r10 ; 0x0203FFF0
          ldrb r7, [r6, 0x0]
          cmp r7, r2
          bge update_current_glyph_offset_end
          update_current_glyph_offset_begin:
            strb r2, [r6, 0x0]
          update_current_glyph_offset_end:
          b write_2_end
        write_F_end:
        write_2_begin:
          add r3, 0x2
        write_2_end:

        lsl r4, r4, 0x1
        sub r2, 0x1
        cmp r2, 0x0
        bgt draw_previous_inner_loop_begin
      draw_previous_inner_loop_end:

      mov r6, r9 ; 0x020097B0
      ; Multiply r1 by 4 since each row is 4 bytes long
      lsl r1, r1, 0x2
      str r3, [r6, r1]
      lsr r1, r1, 0x2
      add r1, 0x1
      cmp r1, 0x10
      blt draw_previous_outer_loop_begin
    draw_previous_outer_loop_end:

    increment_tile_begin:
      ldr r6, =0x02009930
      ldrb r7, [r6]
      add r7, 0x1
      strb r7, [r6]
      add r6, 0x24
      ldrb r7, [r6]
      add r7, 0x2
      strb r7, [r6]
    increment_tile_end:

    ; Add column before next character
    mov r6, r10 ; 0x0203FFF0
    ldrb r7, [r6, 0x0]
    add r7, r7, 0x1
    strb r7, [r6, 0x0]
  draw_previous_end:

  ; Clear shift flag for previous glyph
  mov r6, r10 ; 0x0203FFF0
  mov r7, 0x00
  strb r7, [r6, 0x3] ; Flag for shifting right or not.

  draw_current_begin:
    ; r1 = Outer loop counter
    ; r2 = Inner loop counter
    ; r3 = Row of 2's and F's
    ; r4 = Row of 1 bpp glyph
    ; r5 = 4 * X-offset of current glyph (0x0203FFF0)

    ; Clear x offset and tile index for previous glyph
    mov r6, r10 ; 0x0203FFF0
    mov r7, 0x8 ; Set to 8 since we're taking a minimum
    strb r7, [r6, 0x1]
    mov r7, 0x0
    strb r7, [r6, 0x2]

    mov r1, 0x0
    mov r5, r10 ; 0x0203FFF0
    ldrb r5, [r5, 0x0]
    lsl r5, r5, 0x2
    b draw_current_outer_loop_begin

    ; Hacky way to branch back to draw_glyph_begin
    branch_back_to_draw_glyph_begin:
      b draw_glyph_begin

    draw_current_outer_loop_begin:
      mov r2, 0x0
      mov r6, r9 ; 0x020097B0
      lsl r1, r1, 0x2
      ldr r3, [r6, r1]
      lsr r1, r1, 0x2

      mov r6, r12 ; 0x086039AC
      ; extract the higher byte
      ldr r7, =0x0000FF00
      and r7, r0
      lsr r7, r7, 0x8
      lsl r7, r7, 0x4
      add r6, r6, r7
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
          mov r6, r10 ; 0x0203FFF0
          ldrb r7, [r6, 0x1]
          cmp r7, r2
          ble current_update_previous_glyph_offset_end
          current_update_previous_glyph_offset_begin:
            strb r2, [r6, 0x1]
            ldr r7, =0x0000FF00
            and r7, r0
            lsr r7, r7, 0x8
            strb r7, [r6, 0x2]
          current_update_previous_glyph_offset_end:
          b current_update_current_glyph_offset_end

          current_update_current_glyph_offset_begin:
            lsr r5, r5, 0x2
            add r2, r2, r5
            add r2, 0x1
            mov r6, r10
            ldrb r7, [r6, 0x0]
            cmp r7, r2
            bge do_not_update_current_glyph_offset
            strb r2, [r6, 0x0]
            do_not_update_current_glyph_offset:
            sub r2, 0x1
            sub r2, r2, r5
            lsl r5, r5, 0x2
          current_update_current_glyph_offset_end:

          b draw_current_2_end
        draw_current_F_end:
        draw_current_2_begin:
          lsl r2, r2, 0x2

          ; Clear out the current character in r3
          mov r7, 0xF
          lsl r7, r5
          lsl r7, r2
          and r7, r3
          sub r3, r7

          mov r6, 0x2
          lsl r6, r5
          lsl r6, r2
          orr r3, r6

          lsr r2, r2, 0x2
        draw_current_2_end:
        lsr r4, r4, 0x1
        add r2, 0x1
        cmp r2, 0x8
        blt draw_current_inner_loop_begin
      draw_current_inner_loop_end:

      mov r6, r9 ; 0x020097B0
      ; Multiply r1 by 4 since each row is 4 bytes long
      lsl r1, r1, 0x2
      str r3, [r6, r1]
      lsr r1, r1, 0x2
      add r1, 0x1
      cmp r1, 0x10
      blt draw_current_outer_loop_begin
    draw_current_outer_loop_end:

    ; Add column before next character
    mov r6, r10 ; 0x0203FFF0
    ldrb r7, [r6, 0x0]
    add r7, r7, 0x1
    strb r7, [r6, 0x0]
    cmp r7, 0xA
    blt set_shift_right_flag_end
    set_shift_right_flag_begin:
      ; Set flag to shift right for previous_glyph
      mov r6, r10 ; 0x0203FFF0
      mov r7, 0x1
      strb r7, [r6, 0x3]
    set_shift_right_flag_end:
  draw_current_end:

  dma_begin:
    ldr r1, =0x040000D4
    ldr r2, =0x020097B0
    str r2, [r1]
    ldr r7, =0x02009954
    ldrh r2, [r7]
    lsl r2, r2, 0x05
    ldr r3, =0x06004000
    add r2, r2, r3
    str r2, [r1, 0x04]
    ldr r2, =0x80000060
    str r2, [r1, 0x08]
    ldr r2, [r1, 0x08]
  dma_end:

  ; 0x04 is the EOF value, indicating we should wipe the local RAM data and
  ; increment the tile.
  ldr r7, =0x0000FF00
  and r7, r0
  lsr r7, 0x08
  cmp r7, 0x04
  bne not_eof
    ; clear local ram
    mov r6, r10
    mov r7, 0x00
    str r7, [r6]

    ; clear glyph data
    ldr r5, =0x22222222
    mov r6, 0xC0
    mov r7, r9
    clear_glyph_data_begin:
    sub r6, 0x04
    str r5, [r7, r6]
    cmp r6, 0x00
    bgt clear_glyph_data_begin
    clear_glyph_data_end:

    ; increment tile data
    ldr r6, =0x02009930
    ldrb r7, [r6]
    add r7, 0x1
    strb r7, [r6]
    add r6, 0x24
    ldrb r7, [r6]
    add r7, 0x2
    strb r7, [r6]
  not_eof:

  lsl r0, r0, 0x8
  ldr r7, =0x0000FFFF
  and r7, r0
  cmp r7, 0x00
  bne branch_back_to_draw_glyph_begin
draw_glyph_end:

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

.pool

.close
