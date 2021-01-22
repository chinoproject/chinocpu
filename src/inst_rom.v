`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
inst_mem[0] <= 64'h2080800000408000;
inst_mem[1] <= 64'h2200800000000000;
inst_mem[2] <= 64'h21e1000000000000;
inst_mem[3] <= 64'h21b1800000000000;
inst_mem[4] <= 64'h2080800040008000;
inst_mem[5] <= 64'h2210800000001000;
inst_mem[6] <= 64'h21f2000000001000;
inst_mem[7] <= 64'h21c2800000001000;
inst_mem[8] <= 64'h20808000c0008000;
inst_mem[9] <= 64'h2220800000002000;
inst_mem[10] <= 64'h21d3000000002000;
inst_mem[11] <= 64'h2250800000003000;
inst_mem[12] <= 64'h2233800000003000;
inst_mem[13] <= 64'h2260800000004c00;
inst_mem[14] <= 64'h2244000000004c00;

		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:3]];
		end
	end

endmodule