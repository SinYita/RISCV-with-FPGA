`include "define.v"
module rv_single_axi(
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF m_inst_axi:m_data_axi, ASSOCIATED_RESET rst_n" *)
    input  wire        clk,
    
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input  wire        rst_n,

    // AXI4-Lite Instruction Master
    output wire [31:0] m_inst_axi_araddr, output wire m_inst_axi_arvalid, input wire m_inst_axi_arready,
    input  wire [31:0] m_inst_axi_rdata, input wire [1:0] m_inst_axi_rresp, input wire m_inst_axi_rvalid,
    output wire        m_inst_axi_rready, output wire [2:0] m_inst_axi_arprot,

    // AXI4-Lite Data Master
    output wire [31:0] m_data_axi_awaddr, output wire m_data_axi_awvalid, input wire m_data_axi_awready,
    output wire [31:0] m_data_axi_wdata, output wire [3:0] m_data_axi_wstrb, output wire m_data_axi_wvalid,
    input  wire        m_data_axi_wready, input wire [1:0] m_data_axi_bresp, input wire m_data_axi_bvalid,
    output wire        m_data_axi_bready, output wire [31:0] m_data_axi_araddr, output wire m_data_axi_arvalid,
    input  wire        m_data_axi_arready, input wire [31:0] m_data_axi_rdata, input wire [1:0] m_data_axi_rresp,
    input  wire        m_data_axi_rvalid, output wire m_data_axi_rready, output wire [2:0] m_data_axi_arprot, output wire [2:0] m_data_axi_awprot,

    output reg         done
);

    wire [31:0] PC_Current, PC_Next, Instr;
    wire [31:0] RD1, RD2, WD3, Imm_Ext, ALU_Out, SrcB, Mem_Data;
    wire RegWrite, MemWrite, ALUSrcB, PCSrc, Zero;
    wire [2:0] sel_ext; wire [1:0] sel_wb; wire [3:0] alu_ctrl;
    wire cpu_en;

    // ==========================================
    // 1. Instruction AXI FSM
    // ==========================================
    localparam IF_REQ = 2'd0, IF_WAIT = 2'd1, IF_DONE = 2'd2;
    reg [1:0] if_state; reg [31:0] inst_latch;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            if_state <= IF_REQ; inst_latch <= 32'h00000013;
        end else begin
            case (if_state)
                IF_REQ:  if (m_inst_axi_arready) if_state <= IF_WAIT;
                IF_WAIT: if (m_inst_axi_rvalid) begin inst_latch <= m_inst_axi_rdata; if_state <= IF_DONE; end
                IF_DONE: if (cpu_en) if_state <= IF_REQ;
            endcase
        end
    end
    assign m_inst_axi_arvalid = rst_n && (if_state == IF_REQ);
    assign m_inst_axi_araddr  = PC_Current + 32'h4000_0000;
    assign m_inst_axi_arprot  = 3'b000;
    assign m_inst_axi_rready  = rst_n && (if_state == IF_WAIT);

    wire inst_waiting = (if_state != IF_DONE);
    assign Instr = (if_state == IF_DONE) ? inst_latch : 32'h00000013;

    // ==========================================
    // 2. Data AXI FSM
    // ==========================================
    wire is_load = (sel_wb == `WB_MEM), is_store = MemWrite;
    wire mem_req = (if_state == IF_DONE) && (is_load || is_store); // 只有取指完成后才判断是否需要访存

    localparam MEM_IDLE = 3'd0, MEM_WADDR = 3'd1, MEM_WDATA = 3'd2, MEM_WRESP = 3'd3, MEM_RADDR = 3'd4, MEM_RDATA = 3'd5, MEM_DONE = 3'd6;
    reg [2:0] mem_state; reg [31:0] data_latch;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_state <= MEM_IDLE; data_latch <= 32'd0;
        end else begin
            case (mem_state)
                MEM_IDLE:  if (mem_req) mem_state <= is_store ? MEM_WADDR : MEM_RADDR;
                MEM_WADDR: if (m_data_axi_awready) mem_state <= MEM_WDATA;
                MEM_WDATA: if (m_data_axi_wready)  mem_state <= MEM_WRESP;
                MEM_WRESP: if (m_data_axi_bvalid)  mem_state <= MEM_DONE;
                MEM_RADDR: if (m_data_axi_arready) mem_state <= MEM_RDATA;
                MEM_RDATA: if (m_data_axi_rvalid) begin data_latch <= m_data_axi_rdata; mem_state <= MEM_DONE; end
                MEM_DONE:  if (cpu_en) mem_state <= MEM_IDLE;
            endcase
        end
    end
    assign m_data_axi_awvalid = rst_n && (mem_state == MEM_WADDR);
    assign m_data_axi_awaddr  = ALU_Out;
    assign m_data_axi_awprot  = 3'b000;
    assign m_data_axi_wvalid  = rst_n && (mem_state == MEM_WDATA);
    assign m_data_axi_wdata   = RD2;
    assign m_data_axi_wstrb   = 4'b1111;
    assign m_data_axi_bready  = rst_n && (mem_state == MEM_WRESP);
    assign m_data_axi_arvalid = rst_n && (mem_state == MEM_RADDR);
    assign m_data_axi_araddr  = ALU_Out;
    assign m_data_axi_arprot  = 3'b000;
    assign m_data_axi_rready  = rst_n && (mem_state == MEM_RDATA);

    wire data_waiting = mem_req && (mem_state != MEM_DONE);
    assign Mem_Data = (mem_state == MEM_DONE) ? data_latch : 32'd0;

    // ==========================================
    // 3. 全局使能门控 & 完成信号
    // ==========================================
    assign cpu_en = !(inst_waiting || data_waiting);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) done <= 1'b0;
        else if (mem_state == MEM_WRESP && m_data_axi_bvalid) begin
            if (ALU_Out == 32'h42001FFC && RD2 == 32'hDEADBEEF) done <= 1'b1;
        end
    end

    // ==========================================
    // 4. 单周期核心例化
    // ==========================================
    PC pc_inst(.clk(clk), .rst_n(rst_n), .en(cpu_en), .NPC(PC_Next), .PC_Current(PC_Current));
    NPC npc_inst(.PC(PC_Current), .PCSrc(PCSrc), .IMMEXT(Imm_Ext), .NPC(PC_Next));
    Register_File regfile_inst(.clk(clk), .rst_n(rst_n), .en(cpu_en), .WE(RegWrite), .A1(Instr[19:15]), .A2(Instr[24:20]), .A3(Instr[11:7]), .WD(WD3), .RD1(RD1), .RD2(RD2));
    Sign_Extend ext_inst(.Ins(Instr), .sel_ext(sel_ext), .ImmExt(Imm_Ext));
    Mux alu_src_mux(.in_1(RD2), .in_2(Imm_Ext), .sel(ALUSrcB), .out(SrcB));
    ALU alu_inst(.A(RD1), .B(SrcB), .alu_control(alu_ctrl), .Result(ALU_Out), .Zero(Zero));
    Controller controller_inst(.Op(Instr[6:0]), .funct3(Instr[14:12]), .funct7(Instr[31:25]), .Zero(Zero), .rf_we(RegWrite), .sel_ext(sel_ext), .sel_alu_src_b(ALUSrcB), .dmem_we(MemWrite), .sel_result(sel_wb), .PCSrc(PCSrc), .alu_control(alu_ctrl));

    assign WD3 = (sel_wb == `WB_ALU) ? ALU_Out :
                 (sel_wb == `WB_MEM) ? Mem_Data :
                 (sel_wb == `WB_PC4) ? (PC_Current + 4) : ALU_Out;

endmodule
