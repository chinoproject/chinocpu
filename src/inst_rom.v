`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
inst_mem[0] <= 64'h2080800000050000;
inst_mem[1] <= 64'h20f0800000028000;
inst_mem[2] <= 64'h1081f80000000000;
inst_mem[3] <= 64'h2082000000050000;
inst_mem[4] <= 64'h20d2000000010000;
inst_mem[5] <= 64'h1083780000000000;




		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:3]];
		end
	end

endmodule