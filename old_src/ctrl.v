`include "defines.v"
module ctrl (
    input wire              rst,
    input wire              req_from_id,    // 来自ID阶段的暂停请求
    input wire              req_from_ex,    // 来自EX阶段的暂停请求
    input wire[`RegBus]     excepttype_i,
    input wire[`RegBus]     cp0_epc_i,

    output reg[`RegBus]     new_pc,
    output reg              flush,
    output reg[5:0]         stall
);
    always @(*) begin
        if (rst == `RstEnable) begin
            stall <= 6'b000000;
            flush <= 1'b0;
        end else if (excepttype_i != `ZeroWord) begin   //发生异常
            flush <= 1'b1;  //清空流水线
            stall <= 6'b000000;
            case(excepttype_i)
                32'h00000001:new_pc <= 32'h00000020;
                32'h00000008:new_pc <= 32'h00000040;
                32'h0000000a:new_pc <= 32'h00000040;
                32'h0000000d:new_pc <= 32'h00000040;
                32'h0000000e:new_pc <= cp0_epc_i;
                default:begin
                end
            endcase
        end else if (req_from_ex == `Stop) begin
            stall <= 6'b001111;
            flush <= 1'b0;
        end else if (req_from_id == `Stop) begin
            stall <= 6'b000111;
            flush <= 1'b0;
        end else begin
            stall <= 6'b000000;
            flush <= 1'b0;
        end
    end
endmodule
