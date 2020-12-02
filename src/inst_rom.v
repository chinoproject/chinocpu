`include "defines.v"

module inst_rom(

	//input	wire										clk,
	input wire                    						ce,
	input wire[`InstAddrBus]							addr,
	output reg[`InstBus]								inst
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	always @ (*) begin
		inst_mem[0] <= 64'h2082000000320000;
		inst_mem[1] <= 64'h20e27ffffff60000;

		if (ce == `ChipDisable) begin
			inst <= `ZeroDoubleWord;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:3]];
		end
	end

endmodule