`include "define.v"

module Controller(
    input  [6:0] op,           
    input  [2:0] funct3,        
    input  [6:0] funct7,      
        
    input  Zero,

    output RegWrite,
    output MemWrite,
    output ALUSrc,
    output PCSrc,
    output [1:0] ResultSrc,
    output [2:0] ImmSrc,
    output [3:0] ALUControl      
);
    
    wire [1:0] ALUOp;
    wire Branch, Jump;
    
    Op_Decoder md(
        .Op(op), .RegWrite(RegWrite), .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc), .MemWrite(MemWrite),
        .ResultSrc(ResultSrc), .Branch(Branch),
        .ALUOp(ALUOp), .Jump(Jump)
    );
    
    ALU_Decoder alu_dec(
        .ALUOp(ALUOp), .funct3(funct3),
        .funct7b5(funct7[5]), .opb5(op[5]),
        .alu_control(ALUControl)
    );

    assign PCSrc = (Branch & Zero) | Jump;    
endmodule