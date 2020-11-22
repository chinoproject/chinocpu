`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
		inst_mem[0] <= 64'h2010880000000400;
		inst_mem[1] <= 64'h2010840000000800;
		inst_mem[2] <= 64'h2011900000072000;
		inst_mem[3] <= 64'h20118c0000040800;
		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:4]];
		end
	end

endmodule