`timescale 1ns/1ps

module tb_rv_pl_axi;

  reg clk = 0;
  reg rst_n = 0;

  // -------------------------
  // DUT AXI ports (match rv_pl)
  // -------------------------
  wire [31:0] m_inst_axi_araddr;
  wire        m_inst_axi_arvalid;
  reg         m_inst_axi_arready;
  reg  [31:0] m_inst_axi_rdata;
  reg  [1:0]  m_inst_axi_rresp;
  reg         m_inst_axi_rvalid;
  wire        m_inst_axi_rready;
  wire [2:0]  m_inst_axi_arprot;

  wire [31:0] m_data_axi_awaddr;
  wire        m_data_axi_awvalid;
  reg         m_data_axi_awready;
  wire [31:0] m_data_axi_wdata;
  wire [3:0]  m_data_axi_wstrb;
  wire        m_data_axi_wvalid;
  reg         m_data_axi_wready;
  reg  [1:0]  m_data_axi_bresp;
  reg         m_data_axi_bvalid;
  wire        m_data_axi_bready;

  wire [31:0] m_data_axi_araddr;
  wire        m_data_axi_arvalid;
  reg         m_data_axi_arready;
  reg  [31:0] m_data_axi_rdata;
  reg  [1:0]  m_data_axi_rresp;
  reg         m_data_axi_rvalid;
  wire        m_data_axi_rready;
  wire [2:0]  m_data_axi_arprot;
  wire [2:0]  m_data_axi_awprot;

  wire done;

  // -------------------------
  // Instantiate DUT
  // -------------------------
  rv_pl dut (
    .clk(clk),
    .rst_n(rst_n),

    .m_inst_axi_araddr (m_inst_axi_araddr),
    .m_inst_axi_arvalid(m_inst_axi_arvalid),
    .m_inst_axi_arready(m_inst_axi_arready),
    .m_inst_axi_rdata  (m_inst_axi_rdata),
    .m_inst_axi_rresp  (m_inst_axi_rresp),
    .m_inst_axi_rvalid (m_inst_axi_rvalid),
    .m_inst_axi_rready (m_inst_axi_rready),
    .m_inst_axi_arprot (m_inst_axi_arprot),

    .m_data_axi_awaddr (m_data_axi_awaddr),
    .m_data_axi_awvalid(m_data_axi_awvalid),
    .m_data_axi_awready(m_data_axi_awready),
    .m_data_axi_wdata  (m_data_axi_wdata),
    .m_data_axi_wstrb  (m_data_axi_wstrb),
    .m_data_axi_wvalid (m_data_axi_wvalid),
    .m_data_axi_wready (m_data_axi_wready),
    .m_data_axi_bresp  (m_data_axi_bresp),
    .m_data_axi_bvalid (m_data_axi_bvalid),
    .m_data_axi_bready (m_data_axi_bready),

    .m_data_axi_araddr (m_data_axi_araddr),
    .m_data_axi_arvalid(m_data_axi_arvalid),
    .m_data_axi_arready(m_data_axi_arready),
    .m_data_axi_rdata  (m_data_axi_rdata),
    .m_data_axi_rresp  (m_data_axi_rresp),
    .m_data_axi_rvalid (m_data_axi_rvalid),
    .m_data_axi_rready (m_data_axi_rready),
    .m_data_axi_arprot (m_data_axi_arprot),
    .m_data_axi_awprot (m_data_axi_awprot),

    .done(done)
  );

  // clock 100MHz
  always #5 clk = ~clk;

  // -------------------------
  // Memory models
  // -------------------------
  localparam IMEM_WORDS = 4096;
  localparam DMEM_WORDS = 4096;

  // CPU data address space base (must match your program)
  localparam DMEM_BASE  = 32'h4200_0000;
  localparam DONE_ADDR  = 32'h4200_1FFC;

  reg [31:0] imem [0:IMEM_WORDS-1];
  reg [31:0] dmem [0:DMEM_WORDS-1];

  // Instruction address is plain PC (0-based) -> word index
  wire [31:0] inst_idx  = m_inst_axi_araddr >> 2;

  // Data address is in 0x4200_0000 region -> map to dmem[0..]
  wire [31:0] data_ridx = (m_data_axi_araddr - DMEM_BASE) >> 2;
  wire [31:0] data_widx = (m_data_axi_awaddr - DMEM_BASE) >> 2;

  // -------------------------
  // Ultra-lenient AXI-Lite slave behavior (zero wait)
  // -------------------------
  always @(*) begin
    // Always ready
    m_inst_axi_arready = 1'b1;
    m_data_axi_arready = 1'b1;
    m_data_axi_awready = 1'b1;
    m_data_axi_wready  = 1'b1;

    // Always OKAY
    m_inst_axi_rresp = 2'b00;
    m_data_axi_rresp = 2'b00;
    m_data_axi_bresp = 2'b00;

    // Read returns immediately when ARVALID
    m_inst_axi_rvalid = m_inst_axi_arvalid;
    if (inst_idx < IMEM_WORDS)
      m_inst_axi_rdata = imem[inst_idx];
    else
      m_inst_axi_rdata = 32'h00000013; // NOP

    m_data_axi_rvalid = m_data_axi_arvalid;
    if (data_ridx < DMEM_WORDS)
      m_data_axi_rdata = dmem[data_ridx];
    else
      m_data_axi_rdata = 32'h0;

    // Write response valid immediately when AWVALID & WVALID
    m_data_axi_bvalid = m_data_axi_awvalid & m_data_axi_wvalid;
  end

  // actually perform writes on clock edge
  always @(posedge clk) begin
    if (m_data_axi_awvalid && m_data_axi_wvalid) begin
      if (data_widx < DMEM_WORDS) begin
        // assume full word store
        dmem[data_widx] <= m_data_axi_wdata;
      end
    end
  end

  // -------------------------
  // Bubble sort result check
  // -------------------------
  localparam DATA_BASE = 32'h4200_0000; // array starts here (matches program)

  reg [31:0] expected [0:7];
  integer k;
  reg pass;

  initial begin
    expected[0]=32'd1;
    expected[1]=32'd2;
    expected[2]=32'd3;
    expected[3]=32'd4;
    expected[4]=32'd5;
    expected[5]=32'd7;
    expected[6]=32'd8;
    expected[7]=32'd9;
  end

  task check_sorted;
    reg [31:0] val;
    integer idx;
    begin
      pass = 1;

      // DATA_BASE == DMEM_BASE in this setup, so array lives at dmem[0..7]
      for (k=0; k<8; k=k+1) begin
        idx = ((DATA_BASE - DMEM_BASE) >> 2) + k;
        if (idx < 0 || idx >= DMEM_WORDS) begin
          $display("[FAIL] TB mapping error: idx out of range (%0d)", idx);
          pass = 0;
        end else begin
          val = dmem[idx];
          if (val !== expected[k]) begin
            $display("[FAIL] bubble sort mismatch at idx=%0d addr=%h got=%h expect=%h",
                     k, DATA_BASE + (k<<2), val, expected[k]);
            pass = 0;
          end
        end
      end

      if (pass) begin
        $display("[PASS] bubble sort OK: array sorted correctly.");
      end else begin
        $display("[FAIL] bubble sort FAILED: array not sorted.");
      end
    end
  endtask

  // -------------------------
  // Instrumentation: watch DONE_ADDR store
  // -------------------------
  always @(posedge clk) begin
    if (m_data_axi_awvalid && m_data_axi_wvalid) begin
      if (m_data_axi_awaddr == DONE_ADDR) begin
        $display("[TB] STORE to DONE_ADDR: data=%h time=%0t", m_data_axi_wdata, $time);
      end
    end
  end

  // done handling: check + finish
  always @(posedge clk) begin
    if (rst_n && done) begin
      $display("[PASS] done asserted at t=%0t", $time);
      $display("[TB] checking bubble sort result...");
      check_sorted();
      $finish;
    end
  end

  // -------------------------
  // Program load / reset / timeout
  // -------------------------
  integer i;
  initial begin
    // init
    for (i=0;i<IMEM_WORDS;i=i+1)
      imem[i] = 32'h00000013;
    for (i=0;i<DMEM_WORDS;i=i+1)
      dmem[i] = 32'h0;

    // TODO: change path to your bubble hex
    // Example:
    // $readmemh("C:\\Users\\thoch\\Documents\\HDL\\riscv-fpga\\RTL\\testbench_v\\bubble_sort_done.hex", imem);
    $readmemh("C:\\Users\\thoch\\Documents\\HDL\\riscv-fpga\\RTL\\testbench_v\\smoke_done.hex", imem);

    // reset
    rst_n = 0;
    repeat(10) @(posedge clk);
    rst_n = 1;

    // timeout (bubble sort is longer than smoke)
    repeat(50000) @(posedge clk);
    $display("[FAIL] timeout, done not asserted");
    $finish;
  end

endmodule