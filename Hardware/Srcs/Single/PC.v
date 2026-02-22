module PC(clk, rst_n, en, NPC, PC_Current);
    input clk, rst_n, en;
    input [31:0] NPC;
    output reg [31:0] PC_Current;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) PC_Current <= 32'h0000_0000;
        else if (en) PC_Current <= NPC; // 只有在总线准备好时才更新
    end
endmodule
