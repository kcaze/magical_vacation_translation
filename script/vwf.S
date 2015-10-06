/**
 * This is the variable width font routine. Inject this at 0x007DF750.
 **/
@thumb
@little

/**
 * Important Addresses
 * -------------------
 * 0x006035AC: Base address for 1bpp glyph tile data
 * 0x020097B0: Base address for glyph tile data in WRAM. The nibbles
 *             are stored in reverse orders. For example, 2FF22222 would
 *             actually be copied into the tile data as 22222FF2.
 **/

/**
 * Function Parameters
 * -------------------
 * r0: Index into 0x086035AC of the glyph to draw
 **/

/**
 * Variables in RAM
 * ----------------
 * 0x02009930: x-coordinate in bg3 that we draw tile
 * 0x02009954: Index into tile destination index to copy data from wram to.
 * 0x0203FFF0: x offset to draw current glyph (1 byte)
 * 0x0203FFF1: offset into previous character (1 byte)
 * 0x0203FFF2: index of previous character into 0x0806035AC (1 byte)
 *             set to 0 if no remaining part to draw
 **/


 /**
  * Registers
  * ---------
  * r0: Passed in and preserved.
  * r1 to r7: Scratch registers
  * r8:
  * r9: Holds the base address 0x020097B0 for glyph data in WRAM.
  * r10: Holds the base address 0x0203FFF0 for variables.
  * r12: Holds the base address 0x086035AC for glyph graphics data.
  **/

load_addresses_begin:
  /* Move 0x020097B0 into r9. */
  mov r1, 0x02
  lsl r1, r1, 0x08
  add r1, 0x00
  lsl r1, r1, 0x08
  add r1, 0x97
  lsl r1, r1, 0x08
  add r1, 0xB0
  mov r9, r1

  /* Move 0x0203FFF0 into r10. */
  mov r1, 0x02
  lsl r1, r1, 0x08
  add r1, 0x03
  lsl r1, r1, 0x08
  add r1, 0xFF
  lsl r1, r1, 0x08
  add r1, 0xF0
  mov r10, r1

  /* Move 0x086035AC into r12. */
  mov r1, 0x08
  lsl r1, r1, 0x08
  add r1, 0x60
  lsl r1, r1, 0x08
  add r1, 0x35
  lsl r1, r1, 0x08
  add r1, 0xAC
  mov r12, r1
load_addresses_end:

draw_previous_begin:
  /* We should only draw previous glyphs if the offset is greater than 1 */
  mov r6, r10
  ldrb r6, [r6, 0x2]
  cmp r6, 0x0
  beq draw_previous_end

  /* Clear x offset for current glyph */
  mov r6, r10
  mov r7, 0x0
  strb r7, [r6, 0x0]

  /**
   * r1 = Outer loop counter
   * r2 = Inner loop counter
   * r3 = Row of 2's and F's
   * r4 = Row of 1 bpp glyph
   * r5 = X-offset of previous glyph (0x0203FFF1)
   **/
  mov r1, 0x0
  mov r5, r10 /* 0x0203FFF0 */
  ldrb r5, [r5, 0x1] /* X-offset of previous glyph */

  draw_previous_outer_loop_begin:
    mov r2, 0x8 /* We decrement r2 */
    mov r3, 0x0
    mov r6, r12 /* 0x086035AC */
    mov r7, r10 /* 0x0203FFF0 */

    ldrb r7, [r7, 0x2] /* Index of previous glyph */
    lsl r7, r7, 0x5
    add r6, r6, r7
    ldrb r4, [r6, r1]
    lsr r4, r5

    draw_previous_inner_loop_begin:
      lsl r3, r3, 0x4
      mov r6, r4
      mov r7, 0x80
      and r6, r7
      cmp r6, 0x0
      beq write_2_begin
      write_F_begin:
        add r3, 0xF
        /* Update current glyph offset */
        mov r6, r10
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

    mov r6, r9 /* 0x020097B0 */
    /* Multiply r1 by 4 since each row is 4 bytes long */
    lsl r1, r1, 0x2
    str r3, [r6, r1]
    lsr r1, r1, 0x2
    add r1, 0x1
    cmp r1, 0x10
    blt draw_previous_outer_loop_begin
  draw_previous_outer_loop_end:

  increment_tile_begin:
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
  increment_tile_end:
draw_previous_end:

draw_current_begin:
  /**
   * r1 = Outer loop counter
   * r2 = Inner loop counter
   * r3 = Row of 2's and F's
   * r4 = Row of 1 bpp glyph
   * r5 = 4 * X-offset of current glyph (0x0203FFF1)
   **/

  /* Clear x offset and tile index for previous glyph */
  mov r6, r10 /* 0x0203FFF0 */
  mov r7, 0x8 /* Set to 8 since we're taking a minimum */
  strb r7, [r6, 0x1]
  mov r7, 0x0
  strb r7, [r6, 0x2]

  mov r1, 0x0
  mov r5, r10 /* 0x0203FFF0 */
  ldrb r5, [r5, 0]
  lsl r5, r5, 0x2

  draw_current_outer_loop_begin:
    mov r2, 0x0
    mov r6, r9 /* 0x020097B0 */
    lsl r1, r1, 0x2
    ldr r3, [r6, r1]
    lsr r1, r1, 0x2

    mov r6, r12 /* 0x086035AC */
    lsl r0, r0, 0x5
    add r6, r6, r0
    lsr r0, r0, 0x5
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

        /* Update previous glyph offset */
        cmp r6, 0x0 /* If r6 == 0, then there wasn't enough space */
        bne current_update_current_glyph_offset_begin
        mov r6, r10 /* 0x0203FFF0 */
        ldrb r7, [r6, 0x1]
        cmp r7, r2
        ble current_update_previous_glyph_offset_end
        current_update_previous_glyph_offset_begin:
          strb r2, [r6, 0x1]
          strb r0, [r6, 0x2]
        current_update_previous_glyph_offset_end:
        b current_update_current_glyph_offset_end

        /* TODO: Implement Update current glyph offset */
        current_update_current_glyph_offset_begin:
          lsr r5, r5, 0x2
          add r2, r2, r5
          mov r6, r10
          ldrb r7, [r6, 0x0]
          cmp r7, r2:
          bge do_not_update_current_glyph_offset
          strb r2, [r6, 0x0]
          do_not_update_current_glyph_offset:
          sub r2, r2, r5
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

    mov r6, r9 /* 0x020097B0 */
    /* Multiply r1 by 4 since each row is 4 bytes long */
    lsl r1, r1, 0x2
    str r3, [r6, r1]
    lsr r1, r1, 0x2
    add r1, 0x1
    cmp r1, 0x10
    blt draw_current_outer_loop_begin
  draw_current_outer_loop_end:
draw_current_end:



/* Branch back to 0x0800D112 to return from the original function. */
return:
  mov r7, 0x08
  lsl r7, r7, 0x08
  add r7, 0x00
  lsl r7, r7, 0x08
  add r7, 0xD1
  lsl r7, r7, 0x08
  add r7, 0x12
  mov r15, r7
