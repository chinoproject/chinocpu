`include "defines.v"
module llbit_reg(
    input wire              clk,
    input wire              rst,

    // 是否发生异常
    input wire              flush,

    input wire              llbit_i,
    input wire              we,

    output reg              llbit_o
);
    always @(posedge clk) begin
        if (rst == `RstEnable)
            llbit_o <= 1'b0;
        else if (flush == 1'b1)
            llbit_o <= 1'b0;
        else if (we == `WriteEnable)
            llbit_o <= llbit_i;
    end
endmodule