`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
		inst_mem[0] <= 64'h2010800000000400;
		inst_mem[1] <= 64'h2011000000003800;
		inst_mem[2] <= 64'h1031844000000000;
		inst_mem[3] <= 64'h2032040000001400;
		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:4]];
		end
	end

endmodule