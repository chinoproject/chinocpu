`include "defines.v"

module ex_mem(
	input	wire										clk,
	input wire											rst,
	
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]       						ex_wd,
	input wire                    						ex_wreg,
	input wire[`RegBus]					 				ex_wdata, 	

	//乘法结果
	input wire[`RegBus]									ex_hi,
	input wire[`RegBus]									ex_lo,
	input wire											ex_we,

	//flags寄存器
	input wire[`RegBus]									ex_flags,

	input wire[5:0]										stall,

	input wire[`RegBus]									ex_addr,
	input wire[`RegBus]									ex_reg2,
	input wire[`AluOpBus]								ex_aluop,
	
	input wire 											ex_cp0_reg_we,
	input wire[`RegAddrBus]								ex_cp0_reg_waddr,
	input wire[`RegBus]									ex_cp0_reg_data,
	input wire[`RegBus]									ex_excepttype,
	input wire											ex_is_in_delayslot,
	input wire[`RegBus]									ex_current_inst_address,
	input wire											flush,

	//送到访存阶段的信息
	output reg[`RegAddrBus]      						mem_wd,
	output reg                   						mem_wreg,
	output reg[`RegBus]					 				mem_wdata,

	output reg[`RegBus]									mem_hi,
	output reg[`RegBus]									mem_lo,
	output reg											mem_we,
	output reg[`RegBus]									mem_flags,
	output reg[`RegBus]									mem_addr,
	output reg[`RegBus]									mem_reg2,
	output reg[`AluOpBus]								mem_aluop,

	output reg											mem_cp0_reg_we,
	output reg[`RegAddrBus]								mem_cp0_reg_waddr,
	output reg[`RegBus]									mem_cp0_reg_data,

	output reg[`RegBus]									mem_excepttype,
	output reg  										mem_is_in_delayslot,
	output reg[`RegBus]									mem_current_inst_address
);


	always @ (posedge clk) begin
		if(rst == `RstEnable || flush == 1'b1) begin
			//复位或者清空流水线
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		  	mem_wdata <= `ZeroWord;
			mem_hi <= `ZeroWord;
			mem_lo <= `ZeroWord;
			mem_we <= `WriteDisable;
			mem_flags <= `ZeroWord;
			mem_cp0_reg_waddr <=5'b00000;
			mem_cp0_reg_we <= `WriteDisable;
			mem_cp0_reg_data <= `ZeroWord;
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= `NotInDelaySlot;
			mem_current_inst_address <= `ZeroWord;
		end else if (stall[3] == `Stop && stall[4] == `NoStop) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		  	mem_wdata <= `ZeroWord;
			mem_hi <= `ZeroWord;
			mem_lo <= `ZeroWord;
			mem_we <= `WriteDisable;
			mem_flags <= `ZeroWord;
			mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
			mem_aluop <= 8'h0;
			mem_cp0_reg_waddr <=5'b00000;
			mem_cp0_reg_we <= `WriteDisable;
			mem_cp0_reg_data <= `ZeroWord;
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= `NotInDelaySlot;
			mem_current_inst_address <= `ZeroWord;
		end else if (stall[3] == `NoStop) begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;
			mem_hi <= ex_hi;
			mem_lo <= ex_lo;
			mem_we <= ex_we;	
			mem_flags <= ex_flags;	
			mem_addr <= ex_addr;
			mem_reg2 <= ex_reg2;
			mem_aluop <= ex_aluop;
			mem_cp0_reg_data <= ex_cp0_reg_data;
			mem_cp0_reg_waddr <= ex_cp0_reg_waddr;
			mem_cp0_reg_we <= ex_cp0_reg_we;
			mem_excepttype <= ex_excepttype;
			mem_is_in_delayslot <= ex_is_in_delayslot;
			mem_current_inst_address <= ex_current_inst_address;
		end    //if
	end      //always
endmodule