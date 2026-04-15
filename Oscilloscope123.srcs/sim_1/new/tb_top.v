`timescale 1ns/1ps

module tb_top;

    reg clk;
    reg rst_n;
    reg [1:0] mode;
    reg [2:0] freq_sel;

    wire [7:0] wave_out;

    top uut (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode),
        .freq_sel(freq_sel),
        .wave_out(wave_out)
    );

    // 100MHz Ê±ÖÓ
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        mode = 2'b00;
        freq_sel = 3'd0;

        #20;
        rst_n = 1;

    mode = 2'b10;
    freq_sel = 3'd0;
    #100000;

    freq_sel = 3'd2;
    #100000;

    freq_sel = 3'd5;
    #100000;
//        // ·½²¨
//        mode = 2'b00;
//        #2000;

//        // Èý½Ç²¨
//        mode = 2'b01;
//        #2000;

//        // ÕýÏÒ²¨ 100Hzµµ
//        mode = 2'b10;
//        freq_sel = 3'd0;
//        #2000;

//        // ÕýÏÒ²¨ 1kHzµµ
//        mode = 2'b10;
//        freq_sel = 3'd2;
//        #2000;

//        // ÕýÏÒ²¨ 10kHzµµ
//        mode = 2'b10;
//        freq_sel = 3'd5;
//        #2000;

        $stop;
    end

endmodule