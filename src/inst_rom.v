`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
		inst_mem[0] <= 64'h2080c00000000000;
		inst_mem[1] <= 64'h2081400000000000;
		inst_mem[2] <= 64'h10b1844000000000;
		inst_mem[3] <= 64'h2082200000000000;
		inst_mem[4] <= 64'h2082a00000000000;
		inst_mem[5] <= 64'h10b3148000000000;
		inst_mem[6] <= 64'h2083800000320000;
		inst_mem[7] <= 64'h20b41c0000019000;
		inst_mem[8] <= 64'h2084c00000000000;
		inst_mem[9] <= 64'h20c5240000000400;
		inst_mem[10] <= 64'h2086000000320000;
		inst_mem[11] <= 64'h2085800000190000;
		inst_mem[12] <= 64'h10c6b16000000000;

		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:3]];
		end
	end

endmodule