`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
		inst_mem[0] <= 64'h2080ffffffff8000;
		inst_mem[1] <= 64'h20817fffffff0000;
		inst_mem[2] <= 64'h217088000000a000;
		inst_mem[3] <= 64'h2082800000960000;
		inst_mem[4] <= 64'h2081800000640000;
		inst_mem[5] <= 64'h2081800000c80000;

		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:3]];
		end
	end

endmodule