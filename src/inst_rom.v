`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
		inst_mem[0] <= 64'h1040800000000000;
		inst_mem[1] <= 64'h2011000000003c00;
		inst_mem[2] <= 64'h1041080000000000;
		inst_mem[3] <= 64'h2041800000f00000;
		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:4]];
		end
	end

endmodule