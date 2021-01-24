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
inst_mem[1] <= 64'h2220800000000000;
inst_mem[2] <= 64'h0000000000000000;
inst_mem[3] <= 64'h2080800000000000;
inst_mem[4] <= 64'h2270800000000000;
inst_mem[5] <= 64'h0000000000000000;
inst_mem[6] <= 64'h20b0840000000400;
inst_mem[7] <= 64'h2280800000000000;
inst_mem[8] <= 64'h21d0800000000000;
inst_mem[9] <= 64'h0000000000000000;
inst_mem[10] <= 64'h21d0800000000000;


		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:3]];
		end
	end

endmodule