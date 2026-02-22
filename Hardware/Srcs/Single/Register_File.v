module Register_File(clk, rst_n, en, WE, WD, A1, A2, A3, RD1, RD2);
    input clk, rst_n, en, WE;
    input [4:0] A1, A2, A3;
    input [31:0] WD;
    output [31:0] RD1, RD2;
    
    reg [31:0] Register [31:0];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for(i = 0; i < 32; i = i + 1) Register[i] <= 32'd0;
        end else if (en && WE && A3 != 5'd0) begin // 只有在总线准备好时才写入
            Register[A3] <= WD; 
        end
    end

    assign RD1 = (A1 == 5'd0) ? 32'd0 : Register[A1];
    assign RD2 = (A2 == 5'd0) ? 32'd0 : Register[A2];
endmodule
