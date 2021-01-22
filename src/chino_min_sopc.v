`include "defines.v"

module chino_min_sopc(
	input	wire										clk,
	input	wire										rst
);

  	//连接指令存储器
	wire[`InstAddrBus] inst_addr;
	wire[`InstBus] inst;
	wire rom_ce;
 
	//连接数据存储器
	wire ram_ce;
	wire ram_we;
	wire[`DataAddrBus] ram_addr;
	wire[3:0] ram_sel;
	wire[`DataBus] ram_data_i;
	wire[`DataBus] ram_data_o;

 	chino u_chino(
		.clk(clk),
		.rst(rst),
	
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce),

		.ram_data_i(ram_data_o),
		.ram_data_o(ram_data_i),
		.ram_addr_o(ram_addr),
		.ram_sel_o(ram_sel),
		.ram_we_o(ram_we),
		.ram_ce_o(ram_ce)
	);
	
	inst_rom u_inst_rom(
		.addr(inst_addr),
		.inst(inst),
		.ce(rom_ce)	
	);

	data_ram u_data_ram(
		.clk(clk),
		.ce(ram_ce),
		.we(ram_we),
		.addr(ram_addr),
		.sel(ram_sel),
		.data_i(ram_data_i),
		.data_o(ram_data_o)
	);
endmodule