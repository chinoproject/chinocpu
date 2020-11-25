`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
		inst_mem[0] <= 64'h2010820000000000;
		inst_mem[1] <= 64'h207084a000000000;
		inst_mem[2] <= 64'h1011040000000000;
		inst_mem[3] <= 64'h2011800000001400;
		inst_mem[4] <= 64'h1072086000000000;
		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:3]];
		end
	end

endmodule