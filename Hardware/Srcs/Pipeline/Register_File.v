module Register_File(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        WE,
    input  wire [31:0] WD,
    input  wire [4:0]  A1, A2, A3,
    output wire [31:0] RD1, RD2
);
    
    reg [31:0] Register [31:0];

    always @(posedge clk) begin
        if (WE && A3 != 5'd0) begin
            Register[A3] <= WD; 
        end
    end

    assign RD1 = (A1 == 5'd0) ? 32'd0 : 
                 ((WE && (A1 == A3)) ? WD : Register[A1]);
                 
    assign RD2 = (A2 == 5'd0) ? 32'd0 : 
                 ((WE && (A2 == A3)) ? WD : Register[A2]);

endmodule