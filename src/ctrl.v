`include "defines.v"
module ctrl (
    input wire              rst,
    input wire              req_from_id,    // 来自ID阶段的暂停请求
    input wire              req_from_ex,    // 来自EX阶段的暂停请求
    output reg[5:0]         stall
);
    always @(*) begin
        if (rst == `RstEnable)
            stall <= 6'b000000;
        else if (req_from_id == `Stop)
            stall <= 6'b001111;
        else if (req_from_ex == `Stop)
            stall <= 6'b000111;
        else
            stall <= 6'b000000;
    end
endmodule
