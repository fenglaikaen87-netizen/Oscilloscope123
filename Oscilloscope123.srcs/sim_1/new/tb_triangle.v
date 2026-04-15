`timescale 1ns/1ps
// 上面这一句表示：
// 时间单位是 1ns
// 仿真精度是 1ps

module tb_triangle;

    // 在 testbench 中：
    // 用 reg 来表示"测试时主动赋值的信号"
    reg clk;
    reg rst_n;
    reg [31:0] freq_ctrl;

    // 用 wire 来接收被测模块的输出
    wire [7:0] triangle_out;

    // 例化（实例化）被测模块 triangle_gen
    triangle_gen uut (
        .clk(clk),
        .rst_n(rst_n),
        .freq_ctrl(freq_ctrl),
        .triangle_out(triangle_out)
    );

    // 生成时钟信号
    // 每隔5ns翻转一次 clk
    // 所以一个完整周期是10ns，对应100MHz
    always #5 clk = ~clk;

    // initial 块只在仿真开始时执行一次
    initial begin
        // 初始状态
        clk = 0;            // 时钟初始为0
        rst_n = 0;          // 先让系统处于复位状态
        freq_ctrl = 5;      // 设一个比较小的值，方便观察三角波变化

        // 20ns之后，释放复位
        #20;
        rst_n = 1;

        // 再运行3000ns后停止仿真
        #6000;
        $stop;
    end

endmodule