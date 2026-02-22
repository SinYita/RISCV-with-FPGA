`include "define.v"

module rv_pl(
    input  wire        clk,
    input  wire        rst_n,

    // ========================
    // Instruction BRAM (Port B)
    // ========================
    output wire [31:0] imem_addr,
    input  wire [31:0] imem_rdata,
    output wire        imem_en,

    // ========================
    // Data BRAM (Port B)
    // ========================
    output wire [31:0] dmem_addr,
    output wire [31:0] dmem_wdata,
    input  wire [31:0] dmem_rdata,
    output wire [3:0]  dmem_we,
    output wire        dmem_en

    // ============================================================
    // 3. ?â©??ÜÂ?ïË?ö‰ø°?è∑
    // ============================================================
//    output reg         done
);

    // ========================
    // PC
    // ========================
    reg [31:0] PC;
    wire [31:0] PCNext, PCPlus4, PCTarget;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            PC <= 32'b0;
        else
            PC <= PCNext;
    end

    assign PCPlus4 = PC + 32'd4;

    // ========================
    // Instruction Memory
    // ========================
    assign imem_addr = PC;
    assign imem_en   = 1'b1;

    wire [31:0] Instr = imem_rdata;

    // ========================
    // Decode fields
    // ========================
    wire [6:0] op     = Instr[6:0];
    wire [4:0] rd     = Instr[11:7];
    wire [2:0] funct3 = Instr[14:12];
    wire [4:0] rs1    = Instr[19:15];
    wire [4:0] rs2    = Instr[24:20];
    wire [6:0] funct7 = Instr[31:25];

    // ========================
    // Control Signals
    // ========================
    wire RegWrite, MemWrite, ALUSrc, PCSrc;
    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
    wire [3:0] ALUControl;
    wire Zero;

    Controller ctrl (
        .op(op),
        .funct3(funct3),
        .funct7(funct7),
        .Zero(Zero),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );

    // ========================
    // Register File
    // ========================
    wire [31:0] RD1, RD2, WD3;

    Register_File rf (
        .clk(clk),
        .WE(RegWrite),
        .A1(rs1),
        .A2(rs2),
        .A3(rd),
        .WD(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    // ========================
    // Immediate Generator
    // ========================
    wire [31:0] ImmExt;

    Sign_Extend se (
        .sel_ext(ImmSrc),
        .Ins(Instr[31:7]),
        .ImmExt(ImmExt)
    );

    // ========================
    // ALU
    // ========================
    wire [31:0] SrcB;
    wire [31:0] ALUResult;

    assign SrcB = (ALUSrc) ? ImmExt : RD2;

    ALU alu (
        .A(RD1),
        .B(SrcB),
        .alu_control(ALUControl),
        .Result(ALUResult),
        .Zero(Zero)
    );

    // ========================
    // Data Memory
    // ========================

    assign dmem_addr  = ALUResult;
    assign dmem_wdata = RD2;
    assign dmem_we    = MemWrite ? 4'b1111 : 4'b0000;
    assign dmem_en    = 1'b1;

    wire [31:0] ReadData = dmem_rdata;

    // ========================
    // Writeback MUX
    // ========================
    assign WD3 =
        (ResultSrc == 2'b00) ? ALUResult :
        (ResultSrc == 2'b01) ? ReadData :
        (ResultSrc == 2'b10) ? PCPlus4 :
        32'b0;

    // ========================
    // PC Target
    // ========================
    assign PCTarget = PC + ImmExt;

    assign PCNext = (PCSrc) ? PCTarget : PCPlus4;
endmodule