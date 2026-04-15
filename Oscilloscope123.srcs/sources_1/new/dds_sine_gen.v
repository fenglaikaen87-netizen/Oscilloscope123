module dds_sine_gen #(
    // 相位累加器位宽
    // 位宽越大，频率分辨率越高
    parameter PHASE_WIDTH = 24,

    // 输出数据位宽
    parameter DATA_WIDTH  = 8
)(
    input  wire clk,                              // 系统时钟
    input  wire rst_n,                            // 低电平有效复位

    // 相位步进值
    // 它决定输出频率大小
    input  wire [PHASE_WIDTH-1:0] phase_step,

    // 正弦波输出
    output reg  [DATA_WIDTH-1:0] sine_out
);

    // =========================================================
    // 1. 相位累加器
    //    每来一个时钟，就加一次 phase_step
    //    这就是 DDS 的核心
    // =========================================================
    reg [PHASE_WIDTH-1:0] phase_acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_acc <= 0;
        end else begin
            phase_acc <= phase_acc + phase_step;
        end
    end

    // =========================================================
    // 2. 取相位高4位作为查表地址
    //    因为我们现在仍然用16点正弦表
    //    16点 -> 地址需要4位
    // =========================================================
    wire [3:0] rom_addr;
    assign rom_addr = phase_acc[PHASE_WIDTH-1 -: 4];

    // =========================================================
    // 3. 正弦查表输出
    //    仍然先用16点表，方便验证逻辑
    // =========================================================
    always @(*) begin
        case (rom_addr)
            4'd0  : sine_out = 8'd128;
            4'd1  : sine_out = 8'd176;
            4'd2  : sine_out = 8'd218;
            4'd3  : sine_out = 8'd245;
            4'd4  : sine_out = 8'd255;
            4'd5  : sine_out = 8'd245;
            4'd6  : sine_out = 8'd218;
            4'd7  : sine_out = 8'd176;
            4'd8  : sine_out = 8'd128;
            4'd9  : sine_out = 8'd80;
            4'd10 : sine_out = 8'd38;
            4'd11 : sine_out = 8'd11;
            4'd12 : sine_out = 8'd0;
            4'd13 : sine_out = 8'd11;
            4'd14 : sine_out = 8'd38;
            4'd15 : sine_out = 8'd80;
            default: sine_out = 8'd128;
        endcase
    end

endmodule