`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
inst_mem[0] <= 64'h2080800000008000;
inst_mem[1] <= 64'h208e000000050000;
inst_mem[2] <= 64'h20b18c0000000400;
inst_mem[3] <= 64'h21a0000001000000;
inst_mem[4] <= 64'h10820c0000000000;
inst_mem[5] <= 64'h2081800000000000;
		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:3]];
		end
	end

endmodule