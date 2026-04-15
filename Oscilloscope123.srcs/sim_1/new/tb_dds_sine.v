`timescale 1ns/1ps

module tb_dds_sine;

    reg clk;
    reg rst_n;

    // DDS 的频率控制量
    reg [23:0] phase_step;

    wire [7:0] sine_out;

    // =========================================================
    // 实例化 DDS 正弦波模块
    // =========================================================
    dds_sine_gen uut (
        .clk(clk),
        .rst_n(rst_n),
        .phase_step(phase_step),
        .sine_out(sine_out)
    );

    // =========================================================
    // 100MHz 时钟，周期10ns
    // =========================================================
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;

        // 先给一个比较小的步进值
        // 步进值越大，输出频率越高
        phase_step = 24'd1000000;

        #20;
        rst_n = 1;

        #5000;
        $stop;
    end

endmodule