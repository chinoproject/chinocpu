`include "defines.v"

module mem_wb(

	input	wire										clk,
	input wire											rst,
	

	//来自访存阶段的信息	
	input wire[`RegAddrBus]       						mem_wd,
	input wire                    						mem_wreg,
	input wire[`RegBus]					 				mem_wdata,

	//乘法结果
	input wire[`RegBus]									mem_hi,
	input wire[`RegBus]									mem_lo,
	input wire											mem_we,

	//暂停信号
	input wire[5:0]										stall,
	//flags寄存器
	input wire[`RegBus]									mem_flags,

	input wire  										mem_llbit_we,
	input wire  										mem_llbit_value,

	input wire											mem_cp0_reg_we,
	input wire[`RegAddrBus]								mem_cp0_reg_waddr,
	input wire[`RegBus]									mem_cp0_reg_data,

	input wire  										flush,

	output reg  										wb_llbit_we,
	output reg  										wb_llbit_value,
	//送到回写阶段的信息
	output reg[`RegAddrBus]      						wb_wd,
	output reg                   						wb_wreg,
	output reg[`RegBus]					 				wb_wdata,
	       
	output reg[`RegBus]									wb_hi,
	output reg[`RegBus]									wb_lo,
	output reg											wb_we,
	output reg[`RegBus]									wb_flags,
	output reg											wb_cp0_reg_we,
	output reg[`RegAddrBus]								wb_cp0_reg_waddr,
	output reg[`RegBus]									wb_cp0_reg_data
);
	always @ (posedge clk) begin
		if(rst == `RstEnable || flush == 1'b1) begin
			//复位或者清空流水线
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  	wb_wdata <= `ZeroWord;
			wb_hi <= `ZeroWord;
			wb_lo <= `ZeroWord;
			wb_we <= `WriteDisable;
			wb_flags <= `ZeroWord;	
			wb_cp0_reg_waddr <=5'b00000;
			wb_cp0_reg_we <= `WriteDisable;
			wb_cp0_reg_data <= `ZeroWord;
		end else if (stall[4] == `Stop && stall[5] == `NoStop) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  	wb_wdata <= `ZeroWord;
			wb_hi <= `ZeroWord;
			wb_lo <= `ZeroWord;
			wb_we <= `WriteDisable;
			wb_flags <= `ZeroWord;	
			wb_cp0_reg_waddr <=5'b00000;
			wb_cp0_reg_we <= `WriteDisable;
			wb_cp0_reg_data <= `ZeroWord;
		end else if (stall[4] == `NoStop) begin
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			wb_wdata <= mem_wdata;
			wb_hi <= mem_hi;
			wb_lo <= mem_lo;
			wb_we <= mem_we;
			wb_flags <= mem_flags;
			wb_llbit_value <= mem_llbit_value;
			wb_llbit_we <= mem_llbit_we;
			wb_cp0_reg_data <= mem_cp0_reg_data;
			wb_cp0_reg_waddr <= mem_cp0_reg_waddr;
			wb_cp0_reg_we <= mem_cp0_reg_we;
		end    //if
	end      //always
endmodule