`include "defines.v"

module pc_reg(

	input wire										clk,
	input wire										rst,
	
	output reg[`InstAddrBus]						pc,
	output reg                    					ce
	
);
	parameter  RUN_N_INST = 4;
	reg [5:0]	cnt;
	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin
			pc <= `ZeroWord;
		end else begin
	 		pc <= pc + 8;
		end
	end
	
	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;
		end else begin
				ce <= `ChipEnable;
		end
	end

endmodule