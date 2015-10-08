/**
 * Inject this at 0x0000CFD8 to hijack the execution flow and branch to
 * 0x087DF750. After the variable width font routine does its thing, control
 * returns here and we skip to the end of the original font routine.
 **/

@thumb
@little
mov r4, 0x08
lsl r4, r4, 0x08
add r4, 0x7D
lsl r4, r4, 0x08
add r4, 0xF7
lsl r4, r4, 0x08
add r4, 0x50
mov r15, r4
