`include "define.v"

module rv_pl(
    input  wire clk,
    input  wire rst_n,
    // --- 指令存储器接口 (Instruction BRAM Interface) ---
    output wire [31:0] inst_addr,  // 对应 F_pc
    input  wire [31:0] inst_rdata, // 对应 F_instr

    // --- 数据存储器接口 (Data BRAM Interface) ---
    output wire [31:0] data_addr,  // 对应 M_alu_o
    output wire [31:0] data_wdata, // 对应 M_rf_wd
    input  wire [31:0] data_rdata, // 对应 M_dm_rd
    output wire        data_we,    // 对应 M_we_dm

    // --- 状态指示 ---
    output reg         done        // 任务完成标志
);

    wire [31:0] F_pc;
    wire [31:0] F_instr;
    
    wire [31:0] D_instr;
    wire [4:0]  D_rf_a1, D_rf_a2;
    wire [2:0]  D_sel_ext;
    
    wire [4:0]  E_rf_a1, E_rf_a2, E_rf_a3;
    wire [3:0]  E_alu_control;
    wire        E_sel_alu_src_b;
    wire [1:0]  E_sel_result;
    wire        E_pcsrc;
    wire        ZeroE;
    wire [1:0]  E_fd_A, E_fd_B;
    
    wire [31:0] M_alu_o;
    wire [31:0] M_rf_wd;
    wire [31:0] M_dm_rd;
    wire [4:0]  M_rf_a3;
    wire        M_we_rf;
    wire        M_we_dm;
    
    wire [4:0]  W_rf_a3;
    wire [1:0]  W_sel_result;
    wire        W_we_rf;
    
    wire [31:0] D_rf_rd1, D_rf_rd2;
    wire [31:0] W_result;
    
    wire F_stall, D_flush, D_stall, E_flush;
    
        // --- 指令读取映射 ---
    assign inst_addr = F_pc;
    assign F_instr   = inst_rdata; // F_instr 现在直接来自外部输入
    
    // --- 数据访存映射 ---
    assign data_addr  = M_alu_o;
    assign data_wdata = M_rf_wd;
    assign data_we    = M_we_dm;
    assign M_dm_rd    = data_rdata; // M_dm_rd 现在直接来自外部输入
    
    // --- DONE 标志位实现 ---
    // 作业要求：写入地址 0x2000 触发
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
        end else if (data_we && (data_addr == 32'h00002000)) begin
            // 这里可以检查写入的数据是否为魔数 CAFEBABE
            if (data_wdata == 32'hCAFEBABE || data_wdata == 32'hCAFEAABE)
                done <= 1'b1;
        end
    end
    
    // ===== Register File =====
    Register_File RF (
        .clk(~clk),
        .rst_n(rst_n),
        .WE(W_we_rf),
        .A1(D_rf_a1),
        .A2(D_rf_a2),
        .A3(W_rf_a3),
        .WD(W_result),
        .RD1(D_rf_rd1),
        .RD2(D_rf_rd2)
    );
    
    // ===== Datapath =====
    Datapath datapath_inst (
        .clk(clk),
        .rst_n(rst_n),
        // Fetch
        .F_pc(F_pc),
        .F_instr(F_instr),
        .D_instr(D_instr),
        .D_rf_a1(D_rf_a1),
        .D_rf_a2(D_rf_a2),
        .D_sel_ext(D_sel_ext),
        .E_pcsrc(E_pcsrc),
        .E_sel_alu_src_b(E_sel_alu_src_b),
        .E_alu_control(E_alu_control),
        .E_rf_a1(E_rf_a1),
        .E_rf_a2(E_rf_a2),
        .E_rf_a3(E_rf_a3),
        .E_fd_A(E_fd_A),
        .E_fd_B(E_fd_B),
        .ZeroE(ZeroE),
        .M_alu_o(M_alu_o),
        .M_rf_wd(M_rf_wd),
        .M_dm_rd(M_dm_rd),
        .M_rf_a3(M_rf_a3),
        .W_we_rf(W_we_rf),
        .W_sel_result(W_sel_result),
        .W_rf_a3(W_rf_a3),
        .D_rf_rd1(D_rf_rd1),
        .D_rf_rd2(D_rf_rd2),
        .W_result(W_result),
        .F_stall(F_stall),
        .D_flush(D_flush),
        .D_stall(D_stall),
        .E_flush(E_flush)
    );
    
    // ===== Controller =====
    Controller controller_inst (
        .clk(clk),
        .rst_n(rst_n),
        // Decode inputs
        .op(D_instr[6:0]),
        .funct3(D_instr[14:12]),
        .funct7(D_instr[31:25]),
        .D_sel_ext(D_sel_ext),
        .E_flush(E_flush),
        .ZeroE(ZeroE),
        .E_pcsrc(E_pcsrc),
        .E_sel_result(E_sel_result),
        .E_alu_control(E_alu_control),
        .E_sel_alu_src_b(E_sel_alu_src_b),
        .M_we_rf(M_we_rf),
        .M_we_dm(M_we_dm),
        .W_we_rf(W_we_rf),
        .W_sel_result(W_sel_result)
    );
    
    Hazard_Unit hazard_inst (
        .D_rf_a1(D_rf_a1),
        .D_rf_a2(D_rf_a2),
        .E_rf_a1(E_rf_a1),
        .E_rf_a2(E_rf_a2),
        .E_rf_a3(E_rf_a3),
        .E_pcsrc(E_pcsrc),
        .E_sel_result0(E_sel_result[0]), 
        .M_rf_a3(M_rf_a3),
        .M_we_rf(M_we_rf),
        .W_rf_a3(W_rf_a3),
        .W_we_rf(W_we_rf),
        .F_stall(F_stall),
        .D_flush(D_flush),
        .D_stall(D_stall),
        .E_flush(E_flush),
        .E_fd_A(E_fd_A),
        .E_fd_B(E_fd_B)
    );

endmodule