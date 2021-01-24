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

	output reg  										wb_llbit_we,
	output reg  										wb_llbit_value,
	//送到回写阶段的信息
	output reg[`RegAddrBus]      						wb_wd,
	output reg                   						wb_wreg,
	output reg[`RegBus]					 				wb_wdata,
	       
	output reg[`RegBus]									wb_hi,
	output reg[`RegBus]									wb_lo,
	output reg											wb_we,
	output reg[`RegBus]									wb_flags
);
	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  	wb_wdata <= `ZeroWord;
			wb_hi <= `ZeroWord;
			wb_lo <= `ZeroWord;
			wb_we <= `WriteDisable;
			wb_flags <= `ZeroWord;	
		end else if (stall[4] == `Stop && stall[5] == `NoStop) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  	wb_wdata <= `ZeroWord;
			wb_hi <= `ZeroWord;
			wb_lo <= `ZeroWord;
			wb_we <= `WriteDisable;
			wb_flags <= `ZeroWord;	
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
		end    //if
	end      //always
endmodule