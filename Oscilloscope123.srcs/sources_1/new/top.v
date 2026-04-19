module top(
    input  wire clk,            // 系统时钟
    input  wire rst_n,          // 低电平有效复位

    input  wire [1:0] mode,     // 波形模式选择
                               // 00 -> 方波
                               // 01 -> 三角波
                              // 10 -> 正弦波（DDS）

    input  wire [2:0] freq_sel, // 频率档位选择

    output reg  [7:0] wave_out, // 原始8位波形输出
    output wire pwm_out         // 新增PWM输出
);

    //====================================================
    // 1. 给方波/三角波暂时使用的频率控制参数
    //====================================================

    wire [31:0] freq_ctrl;

freq_ctrl_basic u_freq_ctrl_basic (
    .freq_sel(freq_sel),
    .freq_ctrl(freq_ctrl)
);
    //====================================================
    // 2. DDS 相位步进值
    //====================================================
    wire [23:0] phase_step;

    freq_ctrl_dds u_freq_ctrl_dds (
        .freq_sel(freq_sel),
        .phase_step(phase_step)
    );

    //====================================================
    // 3. 方波模块
    //====================================================
    wire square_out;

    square_gen u_square_gen (
        .clk(clk),
        .rst_n(rst_n),
        .freq_ctrl(freq_ctrl),
        .square_out(square_out)
    );

    //====================================================
    // 4. 三角波模块
    //====================================================
    wire [7:0] triangle_out;

    triangle_gen u_triangle_gen (
        .clk(clk),
        .rst_n(rst_n),
        .freq_ctrl(freq_ctrl),
        .triangle_out(triangle_out)
    );

    //====================================================
    // 5. DDS 正弦波模块
    //====================================================
    wire [7:0] sine_out;

    dds_sine_gen u_dds_sine_gen (
        .clk(clk),
        .rst_n(rst_n),
        .phase_step(phase_step),
        .sine_out(sine_out)
    );

    //====================================================
    // 6. 波形选择逻辑
    //====================================================
    always @(*) begin
        case (mode)
            2'b00: wave_out = {8{square_out}}; // 方波扩展成8位
            2'b01: wave_out = triangle_out;    // 三角波
            2'b10: wave_out = sine_out;        // 正弦波
            default: wave_out = 8'h00;
        endcase
    end

    //====================================================
    // 7. PWM输出层
    // 把8位 wave_out 转成 PWM
    //====================================================
    pwm_out #(
        .DATA_WIDTH(8)
    ) u_pwm_out (
        .clk(clk),
        .rst_n(rst_n),
        .duty_in(wave_out),
        .pwm_out(pwm_out)
    );

endmodule