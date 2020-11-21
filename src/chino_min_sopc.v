`include "defines.v"

module chino_min_sopc(

	input	wire										clk,
	input	wire										rst
	
);

  //连接指令存储器
  wire[`InstAddrBus] inst_addr;
  wire[`InstBus] inst;
  wire rom_ce;
 

 chino u_chino(
		.clk(clk),
		.rst(rst),
	
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce)
	
	);
	
	inst_rom u_inst_rom(
		.addr(inst_addr),
		.inst(inst),
		.ce(rom_ce)	
	);


endmodule