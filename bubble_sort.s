.text
.globl _start

_start:
    lui s0, 0x42000      # s0 = 0x42000000 
    addi s1, zero, 32    # s1 = 32 
    addi t0, zero, 0     # i = 0 

outer_loop:
    beq t0, s1, final_done # if i == 32,end the loop 
    addi t1, zero, 0       # j = 0 
    
    # compute the boundray: s2 = len - i - 1
    sub s2, s1, t0       
    addi s2, s2, -1      

inner_loop:
    beq t1, s2, next_outer # if j == (len-i-1)

    slli t2, t1, 2       # t2 = j * 4
    add t2, t2, s0       # t2 = 0x42000000 + j*4

    lw t3, 0(t2)         # t3 = v[j]
    lw t4, 4(t2)         # t4 = v[j+1]

    # if (v[j+1] < v[j]) swap
    slt t5, t4, t3       # if t4 < t3, t5 = 1
    beq t5, zero, skip_swap #if t5 == 0 

    sw t4, 0(t2)
    sw t3, 4(t2)

skip_swap:
    addi t1, t1, 1       # j++
    jal zero, inner_loop 

next_outer:
    addi t0, t0, 1       # i++
    jal zero, outer_loop 

final_done:
    lui t6, 0x42002      
    addi t6, t6, -4      # 0x42002000 - 4 = 0x42001FFC
    
    lui t5, 0xDEADC      
    addi t5, t5, -273    # 0xDEADC000 - 273 (0x111) = 0xDEADBEEF
    
    sw t5, 0(t6)         

loop_forever:
    jal zero, loop_forever 
