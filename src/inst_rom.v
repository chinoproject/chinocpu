`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];
	reg[`InstMemNum - 1:0] taddr;
	always @ (*) begin
		inst_mem[0] <= 64'h2110000010000000;
		inst_mem[1] <= 64'h0000000000000000;
		inst_mem[8] <= 64'h2080800004000000;
		inst_mem[9] <= 64'h2080800004800000;
		inst_mem[10] <= 64'h12a7040000000000;
		inst_mem[11] <= 64'h20b0840000002000;
		inst_mem[12] <= 64'h1297040000000000;
		inst_mem[13] <= 64'h42d0000000000000;
		inst_mem[14] <= 64'h0000000000000000;
		inst_mem[32] <= 64'h2080800000800000;
		inst_mem[33] <= 64'h2220800000000000;
		inst_mem[34] <= 64'h42b0000000000000;
		inst_mem[35] <= 64'h21d1000000000000;
		inst_mem[36] <= 64'h2110000011800000;
		inst_mem[37] <= 64'h0000000000000000;



		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  taddr <= addr[`InstMemNumLog2+2:3];
		  inst <= inst_mem[taddr];
		end
	end

endmodule