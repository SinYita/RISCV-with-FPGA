    .section .text
    .globl _start

_start:
    # t0 = DONE_VALUE = 0xCAFEBABE
    lui   t0, 0xCAFEB       # t0 = 0xCAFEB000
    addi  t0, t0, 0xABE     # t0 = 0xCAFEBABE

    # t1 = DONE_ADDR = 0x00002000
    lui   t1, 0x00002       # t1 = 0x00002000
    addi  t1, t1, 0x000

    # store DONE_VALUE to DONE_ADDR
    sw    t0, 0(t1)

loop:
    jal   x0, loop          # infinite loop
