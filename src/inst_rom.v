`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
		inst_mem[0] <= 64'h20808000000f0000;
		inst_mem[1] <= 64'h2091000000002800;
		inst_mem[2] <= 64'h2091880000001800;
		inst_mem[3] <= 64'h1092006000000000;
		inst_mem[4] <= 64'h10928c4000000000;
		inst_mem[5] <= 64'h20a3080000003000;
		inst_mem[6] <= 64'h20a3800000002400;
		inst_mem[7] <= 64'h10a400c000000000;
		inst_mem[8] <= 64'h10a498a000000000;
		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:3]];
		end
	end

endmodule