`include "define.v"
module Op_Decoder(
    input            Zero,
    input      [6:0] Op,
    output reg       rf_we,          
    output reg [2:0] sel_ext,        
    output reg       sel_alu_src_b,  
    output reg       dmem_we,        
    output reg [1:0] sel_result,     
    output reg       PCSrc,          
    output reg [2:0] ALUOp //Change to three digits
);
    always @* begin
        rf_we = `NO; sel_ext = `Ext_ImmI; sel_alu_src_b = `ALU_REG; dmem_we = 1'b0;
        sel_result = `WB_ALU; ALUOp = 3'b000; PCSrc = `PC4;

        case (Op)
            `OPCODE_LW: begin rf_we=`YES; sel_ext=`Ext_ImmI; sel_alu_src_b=`ALU_IMM; dmem_we=1'b0; sel_result=`WB_MEM; ALUOp=3'b000; PCSrc=`PC4; end
            `OPCODE_SW: begin rf_we=`NO; sel_ext=`Ext_ImmS; sel_alu_src_b=`ALU_IMM; dmem_we=1'b1; sel_result=`WB_ALU; ALUOp=3'b000; PCSrc=`PC4; end
            `OPCODE_RTP:begin rf_we=`YES; sel_ext=`Ext_ImmI; sel_alu_src_b=`ALU_REG; dmem_we=1'b0; sel_result=`WB_ALU; ALUOp=3'b001; PCSrc=`PC4; end
            `OPCODE_ITP:begin rf_we=`YES; sel_ext=`Ext_ImmI; sel_alu_src_b=`ALU_IMM; dmem_we=1'b0; sel_result=`WB_ALU; ALUOp=3'b010; PCSrc=`PC4; end
            `OPCODE_BEQ:begin rf_we=`NO; sel_ext=`Ext_ImmB; sel_alu_src_b=`ALU_REG; dmem_we=1'b0; sel_result=`WB_ALU; ALUOp=3'b100; PCSrc=Zero?`PCI:`PC4; end // 【修复】专属3'b100
            `OPCODE_JAL:begin rf_we=`YES; sel_ext=`Ext_ImmJ; sel_alu_src_b=`ALU_REG; dmem_we=1'b0; sel_result=`WB_PC4; ALUOp=3'b000; PCSrc=`PCI; end
            `OPCODE_LUI:begin rf_we=`YES; sel_ext=`Ext_ImmU; sel_alu_src_b=`ALU_IMM; dmem_we=1'b0; sel_result=`WB_ALU; ALUOp=3'b011; PCSrc=`PC4; end
            default: ;
        endcase
    end
endmodule
