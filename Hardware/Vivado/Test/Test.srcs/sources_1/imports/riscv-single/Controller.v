`include "define.v"

module Controller(
    input  clk, rst_n,
    input  axi_stall,          // 【新增】AXI 全局停顿信号
    input  [6:0] op,           
    input  [2:0] funct3,        
    input  [6:0] funct7,      
    input  E_flush,        
    input  ZeroE,        
    output M_we_rf,    
    output W_we_rf,    
    output M_we_dm,    
    output E_pcsrc,        
    output [1:0] E_sel_result,   
    output [1:0] M_sel_result, // 【新增透出】给顶层判定是否是 Load 
    output [1:0] W_sel_result,   
    output [3:0] E_alu_control,  
    output E_sel_alu_src_b,      
    output [2:0] D_sel_ext,
    output E_we_rf       
);
    
    // ================== D 阶段 ==================
    wire D_we_rf, D_we_dm, D_jump, D_branch, D_sel_alu_src_b;
    wire [1:0] D_sel_result;
    wire [3:0] D_alu_control;
    wire [1:0] ALUOp;
    
    Op_Decoder md(
        .Op(op), .RegWrite(D_we_rf), .ImmSrc(D_sel_ext),
        .ALUSrc(D_sel_alu_src_b), .MemWrite(D_we_dm),
        .ResultSrc(D_sel_result), .Branch(D_branch),
        .ALUOp(ALUOp), .Jump(D_jump)
    );
    
    ALU_Decoder alu_dec(
        .ALUOp(ALUOp), .funct3(funct3),
        .funct7b5(funct7[5]), .opb5(op[5]),
        .alu_control(D_alu_control)
    );
    
    // ================== E 阶段 ==================
    wire E_we_dm, E_jump, E_branch;

    // 【修改】全部换成 flopenclr，加入 ~axi_stall 使能
    flopenclr #(1) RWE_reg(clk, rst_n, E_flush, ~axi_stall, D_we_rf, E_we_rf); 
    flopenclr #(2) RSE_reg(clk, rst_n, E_flush, ~axi_stall, D_sel_result, E_sel_result); 
    flopenclr #(1) MWE_reg(clk, rst_n, E_flush, ~axi_stall, D_we_dm, E_we_dm);
    flopenclr #(1) JE_reg(clk, rst_n, E_flush, ~axi_stall, D_jump, E_jump);
    flopenclr #(1) BE_reg(clk, rst_n, E_flush, ~axi_stall, D_branch, E_branch);
    flopenclr #(4) ALUConE_reg(clk, rst_n, E_flush, ~axi_stall, D_alu_control, E_alu_control);
    flopenclr #(1) ASrcE_reg(clk, rst_n, E_flush, ~axi_stall, D_sel_alu_src_b, E_sel_alu_src_b);
    
    assign E_pcsrc = (E_branch & ZeroE) | E_jump;
    
    // ================== M 阶段 ==================
    // 【修改】全部换成 flopenr，加入 ~axi_stall 使能
    flopenr #(1) RWM_reg(clk, rst_n, ~axi_stall, E_we_rf, M_we_rf);
    flopenr #(2) RSM_reg(clk, rst_n, ~axi_stall, E_sel_result, M_sel_result);
    flopenr #(1) MWM_reg(clk, rst_n, ~axi_stall, E_we_dm, M_we_dm);
    
    // ================== W 阶段 ==================
    // 【修改】全部换成 flopenr，加入 ~axi_stall 使能
    flopenr #(1) RWWB_reg(clk, rst_n, ~axi_stall, M_we_rf, W_we_rf);
    flopenr #(2) RSWB_reg(clk, rst_n, ~axi_stall, M_sel_result, W_sel_result);
    
endmodule