.gba
.open "hacked.gba", 0x08000000

.macro pushreg
  push r4-r7,lr
  mov r4, r8
  mov r5, r9
  mov r6, r10
  push r4-r6
.endmacro

.macro popreg
  pop r4-r6
  mov r8, r4
  mov r9, r5
  mov r10, r6
  pop r4-r7
.endmacro

ADDR_DMA    equ 0x040000D4
