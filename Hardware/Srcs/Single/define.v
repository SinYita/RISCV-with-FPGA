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
`define ALU_COPY_B             4'b1100 // LUI instruction, output "B" directly

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
// ==========================================
`define ALUOP_LOAD_STORE       3'b000  // lw, sw, jal
`define ALUOP_RTYPE            3'b001  // R-type
`define ALUOP_ITYPE            3'b010  // I-type
`define ALUOP_LUI              3'b011  // lui
`define ALUOP_BRANCH           3'b100  // beq

// ==========================================
// Opcode Definitions (7-bit)
// ==========================================
`define OPCODE_RTP             7'b0110011  // R-type
`define OPCODE_ITP             7'b0010011  // I-type
`define OPCODE_LW              7'b0000011  // Load
`define OPCODE_SW              7'b0100011  // Store
`define OPCODE_BEQ             7'b1100011  // Branch Equal
`define OPCODE_JAL             7'b1101111  // Jump and Link
`define OPCODE_LUI             7'b0110111  // Load Upper Immediate

// ==========================================
// Multiplexer Control Signal Values
// ==========================================
// ALU Source B Select
`define ALU_REG                1'b0
`define ALU_IMM                1'b1

// PC Source Select
`define PC4                    1'b0  //Next PC = PC + 4
`define PCI                    1'b1  //Next PC = PC + Imm

// Write Enable Flags
`define YES                    1'b1
`define NO                     1'b0

// ==========================================
// Register Write-Back Source Select (2-bit)
// ==========================================
`define WB_ALU                 2'b00 //write back to ALU
`define WB_MEM                 2'b01 //write back value from Data Memory
`define WB_PC4                 2'b10 //write back PC + 4
