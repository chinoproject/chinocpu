`include "defines.v"

module mem(

	input wire										rst,
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]       					wd_i,
	input wire                    					wreg_i,
	input wire[`RegBus]					  			wdata_i,

	//乘法结果
	input wire[`RegBus]								hi_i,
	input wire[`RegBus]								lo_i,
	input wire										we_i,

	//flags寄存器
	input wire[`RegBus]								flags_i,

	//送到回写阶段的信息
	output reg[`RegAddrBus]      					wd_o,
	output reg                   					wreg_o,
	output reg[`RegBus]					 			wdata_o,

	output reg[`RegBus]								hi_o,
	output reg[`RegBus]								lo_o,
	output reg										we_o,
	output reg[`RegBus]								flags_o
);

	
	always @ (*) begin
		if(rst == `RstEnable) begin
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
		  	wdata_o <= `ZeroWord;
			hi_o <= `ZeroWord;
			lo_o <= `ZeroWord;
			flags_o <= `ZeroWord;
			we_o <= `WriteDisable;
		end else begin
		  	wd_o <= wd_i;
			wreg_o <= wreg_i;
			wdata_o <= wdata_i;
			hi_o <= hi_i;
			lo_o <= lo_i;
			we_o <= we_i;
			flags_o <= flags_i;
		end    //if
	end      //always
			

endmodule