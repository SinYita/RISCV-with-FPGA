`include "define.v"
module ALU_Decoder(
    input  [2:0] ALUOp,   // 【修复】改为3位
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] alu_control
);
    always @* begin
        case (ALUOp)
            3'b000: alu_control = `ALU_ADD; 
            3'b001: begin
                case (funct3)
                    3'b000: alu_control = (funct7[5]) ? `ALU_SUB : `ALU_ADD;
                    3'b100: alu_control = `ALU_XOR;
                    3'b110: alu_control = `ALU_OR;
                    3'b111: alu_control = `ALU_AND;
                    3'b001: alu_control = `ALU_SHIFTL;
                    3'b101: alu_control = (funct7[5]) ? `ALU_SHIFTR_ARITH : `ALU_SHIFTR;
                    3'b010: alu_control = `ALU_LESS_THAN_SIGNED;
                    3'b011: alu_control = `ALU_LESS_THAN;
                    default: alu_control = `ALU_NONE;
                endcase
            end
            3'b010: begin
                case (funct3)
                    3'b000: alu_control = `ALU_ADD;
                    3'b100: alu_control = `ALU_XOR;
                    3'b110: alu_control = `ALU_OR;
                    3'b111: alu_control = `ALU_AND;
                    3'b001: alu_control = `ALU_SHIFTL;
                    3'b101: alu_control = (funct7[5]) ? `ALU_SHIFTR_ARITH : `ALU_SHIFTR;
                    3'b010: alu_control = `ALU_LESS_THAN_SIGNED;
                    3'b011: alu_control = `ALU_LESS_THAN;
                    default: alu_control = `ALU_NONE;
                endcase
            end
            3'b011: alu_control = `ALU_COPY_B; 
            3'b100: alu_control = `ALU_SUB; // 【修复】BEQ 强制做减法比较
            default: alu_control = `ALU_NONE;
        endcase
    end
endmodule
