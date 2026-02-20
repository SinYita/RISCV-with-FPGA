=== PS->DMEM sanity ===
DMEM[0x100] readback = 0x12345678

=== GPIO sanity ===
GPIO2 rst_n drive (should be 0): 0
GPIO2 rst_n drive (should be 1): 1
GPIO1 done input = 0

=== RUN: mini_data0_code (CPU store to DATA_BASE+0) ===
IMEM readback: ['0x42000437', '0x111112b7', '0x11128293', '0x542023']
DMEM[0] after CPU run = 0x0
EXPECT 0x11111111 -> FAIL

=== RUN: mini_done_code (CPU store to DONE_ADDR) ===
IMEM readback: ['0x42002e37', '0xffce0e13', '0xdeadceb7', '0xeefe8e93']
DONE flag after CPU run = 0x0
EXPECT 0xDEADBEEF -> FAIL
Scan DMEM for 0xDEADBEEF hits at offsets: []