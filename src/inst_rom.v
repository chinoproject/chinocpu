`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
inst_mem[0] <= 64'h2080800000040000;
inst_mem[1] <= 64'h2220800000000000;
inst_mem[2] <= 64'h2081000000040000;
inst_mem[3] <= 64'h2080800000000000;
inst_mem[4] <= 64'h21d0800000000000;
inst_mem[5] <= 64'h2160880000010000;
inst_mem[6] <= 64'h2080800000028000;
inst_mem[7] <= 64'h2080800000000000;
inst_mem[8] <= 64'h2010840000000800;
inst_mem[9] <= 64'h2010840000000800;

		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:3]];
		end
	end

endmodule