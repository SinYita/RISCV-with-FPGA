// ==========================================
// ALU Control Signals (4-bit)
// ==========================================
`define ALU_NONE               4'b0000
`define ALU_SHIFTL             4'b0001
`define ALU_SHIFTR             4'b0010
`define ALU_SHIFTR_ARITH       4'b0011
`define ALU_ADD                4'b0100
`define ALU_SUB                4'b0110
`define ALU_AND                4'b0111
`define ALU_OR                 4'b1000
`define ALU_XOR                4'b1001
`define ALU_LESS_THAN          4'b1010
`define ALU_LESS_THAN_SIGNED   4'b1011
`define ALU_COPY_B             4'b1100 // 用于 LUI 指令，直接输出操作数 B

// ==========================================
// Immediate Extension Type (3-bit)
// ==========================================
`define Ext_ImmI               3'b000
`define Ext_ImmS               3'b001
`define Ext_ImmB               3'b010
`define Ext_ImmU               3'b011
`define Ext_ImmJ               3'b100

// ==========================================
// ALUOp from Main Decoder to ALU Decoder (3-bit) 
// 【注意：这里从原来的 2-bit 拓宽到了 3-bit，以修复 BEQ 的加减法冲突】
// ==========================================
`define ALUOP_LOAD_STORE       3'b000  // lw, sw, jal (默认使用 ADD 加法计算地址)
`define ALUOP_RTYPE            3'b001  // R-type 指令 (由 funct3 和 funct7 决定)
`define ALUOP_ITYPE            3'b010  // I-type 算术指令 (由 funct3 和 funct7 决定)
`define ALUOP_LUI              3'b011  // lui 指令 (直接透传)
`define ALUOP_BRANCH           3'b100  // beq 指令 (强制执行 SUB 减法判断)

// ==========================================
// Opcode Definitions (7-bit)
// ==========================================
`define OPCODE_RTP             7'b0110011  // R-type
`define OPCODE_ITP             7'b0010011  // I-type Arithmetic
`define OPCODE_LW              7'b0000011  // Load
`define OPCODE_SW              7'b0100011  // Store
`define OPCODE_BEQ             7'b1100011  // Branch Equal
`define OPCODE_JAL             7'b1101111  // Jump and Link
`define OPCODE_LUI             7'b0110111  // Load Upper Immediate

// ==========================================
// Multiplexer Control Signal Values
// ==========================================
// ALU Source B Select
`define ALU_REG                1'b0  // ALU 来源为寄存器 (RD2)
`define ALU_IMM                1'b1  // ALU 来源为立即数 (Imm_Ext)

// PC Source Select
`define PC4                    1'b0  // 下一个 PC = PC + 4
`define PCI                    1'b1  // 下一个 PC = PC + Imm (用于跳转)

// Write Enable Flags
`define YES                    1'b1
`define NO                     1'b0

// ==========================================
// Register Write-Back Source Select (2-bit)
// ==========================================
`define WB_ALU                 2'b00 // 写回 ALU 计算结果
`define WB_MEM                 2'b01 // 写回 Data Memory 读出的数据
`define WB_PC4                 2'b10 // 写回 PC + 4 (用于 JAL 指令保存返回地址)
