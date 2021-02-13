`include "defines.v"
module cp0_reg(
    input wire              clk,
    input wire              rst,

    input wire              we_i,
    input wire[4:0]         waddr_i,
    input wire[4:0]         raddr_i,
    input wire[`RegBus]     data_i,

    input wire[5:0]         int_i,

    input wire[`RegBus]     excepttype_i,
    input wire[`RegBus]     current_inst_address_i,
    input wire              is_in_delayslot_i,

    output reg[`RegBus]     data_o,
    output reg[`RegBus]     count_o,
    output reg[`RegBus]     compare_o,
    output reg[`RegBus]     status_o,
    output reg[`RegBus]     cause_o,
    output reg[`RegBus]     epc_o,
    output reg[`RegBus]     config_o,
    output reg[`RegBus]     prid_o,

    output reg              timer_int_o
);

    //对CP0寄存器进行写操作

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            data_o <= `ZeroWord;
            count_o <= `ZeroWord;
            compare_o <= `ZeroWord;
            status_o <= 32'b0001_0000_0000_0000_0000_0000_0000_0000;
            cause_o <= `ZeroWord;
            epc_o <= `ZeroWord;
            config_o <= 32'b0000_0000_0000_0000_1000_0000_0000_0000;
            prid_o <= 32'b00000000_01000011_0000_0001_0000_0010;
            timer_int_o <= `InterruptNotAssert;
        end else begin
            count_o <= count_o + 1;
            cause_o[15:10] <= int_i;    //cause的10~15bit保存外部中断声明
            
            if (compare_o != `ZeroWord && count_o == compare_o)
                timer_int_o <= `InterruptAssert;    //产生时钟信号中断
            
            if (we_i == `WriteEnable) begin
                case(waddr_i)
                    `CP0_REG_COUNT: count_o <= data_i;
                    `CP0_REG_COMPARE: begin
                        compare_o <= data_i;
                        timer_int_o <= `InterruptNotAssert;
                    end
                    `CP0_REG_STATUS: status_o <= data_i;
                    `CP0_REG_EPC: epc_o <= data_i;
                    `CP0_REG_CAUSE: begin
                        cause_o[9:8] <= data_i[9:8];
                        cause_o[23] <= data_i[23];
                        cause_o[22] <= data_i[22];
                    end
                endcase
            end

            case (excepttype_i)
                32'h00000001: begin
                    //外部中断
                    if (is_in_delayslot_i == `InDelaySlot) begin
                        epc_o <= current_inst_address_i - 8;
                        cause_o[31] <= 1'b1;
                    end else begin
                        epc_o <= current_inst_address_i + 8;
                        cause_o[31] <= 1'b0;
                    end
                    status_o[1] <= 1'b1;
                    cause_o[6:2] <= 5'b00000;
                end
                32'h00000008: begin
                    //syscall
                    if (status_o[1] == 1'b0) begin
                        if (is_in_delayslot_i == `InDelaySlot) begin
                            epc_o <= current_inst_address_i - 8;
                            cause_o <= 1'b1;
                        end else begin
                            epc_o <= current_inst_address_i + 8;
                            cause_o[31] <= 1'b0;
                        end
                    end
                    status_o[1] <= 1'b1;
                    cause_o[6:2] <= 5'b1000;
                end
                32'h0000000a: begin
                    //无效指令异常
                    if (status_o[1] == 1'b0) begin
                        if (is_in_delayslot_i == `InDelaySlot) begin
                            epc_o <= current_inst_address_i - 8;
                            cause_o <= 1'b1;
                        end else begin
                            epc_o <= current_inst_address_i + 8;
                            cause_o[31] <= 1'b0;
                        end
                    end
                    status_o[1] <= 1'b1;
                    cause_o[6:2] <= 5'b01010;
                end
                32'h0000000d: begin
                    //trap异常
                    if (status_o[1] == 1'b0) begin
                        if (is_in_delayslot_i == `InDelaySlot) begin
                            epc_o <= current_inst_address_i - 8;
                            cause_o[31] <= 1'b1;
                        end else begin
                            epc_o <= current_inst_address_i + 8;
                            cause_o[31] <= 1'b0;
                        end
                    end
                    status_o[1] <= 1'b1;
                    cause_o[6:2] <= 5'b01101;
                end
                32'h0000000e:begin
                    //eret指令
                    status_o[1] <= 1'b0;
                end
                default:begin
                end
            endcase
        end
    end

    always @(*) begin
        if (rst == `RstEnable) begin
            data_o <= `ZeroWord;
        end else begin
            case(raddr_i)
                `CP0_REG_COMPARE: data_o <= compare_o;
                `CP0_REG_COUNT: data_o <= count_o;
                `CP0_REG_CAUSE: data_o <= cause_o;
                `CP0_REG_CONFIG: data_o <= config_o;
                `CP0_REG_EPC: data_o <= epc_o;
                `CP0_REG_STATUS: data_o <= status_o;
                `CP0_REG_PrId: data_o <= prid_o;
            endcase
        end
    end
endmodule