`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
		inst_mem[0] <= 64'h2011000000003c00;
		inst_mem[1] <= 64'h2010800000000800;
		inst_mem[2] <= 64'h1051082000000000;
		inst_mem[3] <= 64'h201180000003c000;
		inst_mem[4] <= 64'h20518c8000000000;
		inst_mem[5] <= 64'h2062088000000000;
		inst_mem[6] <= 64'h2012800000001400;
		inst_mem[7] <= 64'h10630ca000000000;
		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:4]];
		end
	end

endmodule