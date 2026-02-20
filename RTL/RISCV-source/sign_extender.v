module sign_extender(
    input  [31:0] instr,     // full instr
    input  [2:0]  sel_ext,   // select I/S/B/U/J
    output reg [31:0] imm    // output imm 32 bit
  );

  localparam EXT_I = 3'd0;
  localparam EXT_S = 3'd1;
  localparam EXT_B = 3'd2;
  localparam EXT_U = 3'd3;
  localparam EXT_J = 3'd4;


  always @(*)
  begin
    case (sel_ext)
      EXT_I:
        imm = {{20{instr[31]}}, instr[31:20]};
      EXT_S:
        imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      EXT_B:
        imm = {{19{instr[31]}},
               instr[31],      // imm[12]
               instr[7],       // imm[11]
               instr[30:25],   // imm[10:5]
               instr[11:8],    // imm[4:1]
               1'b0};          // imm[0]
      EXT_U:
        imm = {instr[31:12], 12'b0};
      EXT_J:
        imm = {{11{instr[31]}},
               instr[31],      // imm[20]
               instr[19:12],   // imm[19:12]
               instr[20],      // imm[11]
               instr[30:21],   // imm[10:1]
               1'b0};          // imm[0]

      default:
        imm = 32'b0;
    endcase
  end




endmodule
