`timescale 1ns/1ps

module tb_square;

reg clk;
reg rst_n;
wire out;

reg [31:0] freq_ctrl;

square_gen uut (
    .clk(clk),
    .rst_n(rst_n),
    .freq_ctrl(freq_ctrl),
    .square_out(out)
);

//  ±÷”
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    freq_ctrl = 10;

    #20;
    rst_n = 1;

    #500;
    $stop;
end

endmodule