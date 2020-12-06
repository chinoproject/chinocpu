`include "defines.v"

module chino(

	input	wire										clk,
	input wire											rst,
	
 
	input wire[`InstBus]           rom_data_i,
	output wire[`RegBus]           rom_addr_o,
	output wire                    rom_ce_o
	
);

	wire[`InstAddrBus] pc;
	wire[`InstAddrBus] id_pc_i;
	wire[`InstBus] id_inst_i;
	
	//连接译码阶段ID模块的输出与ID/EX模块的输出
	wire[`AluOpBus] id_aluop_o;
	wire[`AluSelBus] id_alusel_o;
	wire[`RegBus] id_reg1_o;
	wire[`RegBus] id_reg2_o;
	wire id_wreg_o;
	wire[`RegAddrBus] id_wd_o;
	
	//连接ID/EX模块的输出与执行阶段EX模块的输入
	wire[`AluOpBus] ex_aluop_i;
	wire[`AluSelBus] ex_alusel_i;
	wire[`RegBus] ex_reg1_i;
	wire[`RegBus] ex_reg2_i;
	wire ex_wreg_i;
	wire[`RegAddrBus] ex_wd_i;
	
	//连接执行阶段EX模块的输出与EX/MEM模块的输出
	wire ex_wreg_o;
	wire[`RegAddrBus] ex_wd_o;
	wire[`RegBus] ex_wdata_o;

	//连接EX/MEM模块的输出与访存阶段MEM模块的输入
	wire mem_wreg_i;
	wire[`RegAddrBus] mem_wd_i;
	wire[`RegBus] mem_wdata_i;

	//连接访存阶段MEM模块的输出与MEM/WB模块的输出
	wire mem_wreg_o;
	wire[`RegAddrBus] mem_wd_o;
	wire[`RegBus] mem_wdata_o;
	
	//连接MEM/WB模块的输出与回写阶段的输入
	wire wb_wreg_i;
	wire[`RegAddrBus] wb_wd_i;
	wire[`RegBus] wb_wdata_i;
	
	//连接译码阶段ID模块与通用寄存器Regfile模块
	wire reg1_read;
	wire reg2_read;
	wire reg3_read;
	wire[`RegBus] reg1_data;
	wire[`RegBus] reg2_data;
	wire[`RegBus] reg3_data;
	wire[`RegAddrBus] reg1_addr;
	wire[`RegAddrBus] reg2_addr;
	wire[`RegAddrBus] reg3_addr;

	//连接EX和EX/MEM阶段的变量，三个变量储存乘除法运算的结果
	wire[`RegBus]	ex_hi_o;
	wire[`RegBus]	ex_lo_o;
	wire 			ex_we_o;
	//连接EX和EX/MEM阶段的变量，flags寄存器
	wire[`RegBus]	ex_flags_o;

	//连接EX/MEM和MEM阶段的变量
	wire[`RegBus]	mem_hi_i;
	wire[`RegBus]	mem_lo_i;
	wire			mem_we_i;
	wire[`RegBus]	mem_flags_i;

	//连接MEM和WB/MEM阶段的变量
	wire[`RegBus]	mem_hi_o;
	wire[`RegBus]	mem_lo_o;
	wire			mem_we_o;
	wire[`RegBus]	mem_flags_o;

	//L连接WB/MEM阶段和refile的变量
	wire[`RegBus]	wb_hi_i;
	wire[`RegBus]	wb_lo_i;
	wire 			wb_we_i;
	wire[`RegBus]	wb_flags_i;

	//连接除法器与EX模块的变量
    wire          div_signed_div_i;   //有符号运算信号
    wire[`RegBus] div_opdata1_i;
	wire[`RegBus] div_opdata2_i;
    wire          div_start_i;        //开始除法运算信号
    wire          div_annul_i;        //取消运算信号

    wire[`DoubleRegBus]    div_result_o;
    wire          div_ready_o;
	//CTRL模块相关变量
	wire[5:0]		stall;
	wire 			req_from_id;
	wire 			req_from_ex;

	//pc跳转变量
	wire 			branch_flag_o;
	wire[`RegBus]	target_addr_o;
	
	//延迟槽
	wire			ex_is_in_delayslot_o;
	wire 			is_delayslot_o;
	wire 			next_inst_in_delayslot_i;
	wire 			is_delayslot_i;
	wire 			id_is_delayslot;
	//CTRL模块例化
	ctrl u_ctrl(
		.rst(rst),
		.req_from_id(req_from_id),
		.req_from_ex(req_from_ex),
		.stall(stall)
	);

  //pc_reg例化
	pc_reg pc_reg0(
		.clk(clk),
		.rst(rst),
		.pc(pc),
		.ce(rom_ce_o),
		.stall(stall),
		.branch_flag_i(branch_flag_o),
		.target_addr_i(target_addr_o)
	);

  assign rom_addr_o = pc;
  //IF/ID模块例化
	if_id u_if_id(
		.clk(clk),
		.rst(rst),
		.if_pc(pc),
		.if_inst(rom_data_i),
		.id_pc(id_pc_i),
		.id_inst(id_inst_i),
		.stall(stall)    	
	);
	
	//译码阶段ID模块
	id u_id(
		.rst(rst),
		.pc_i(id_pc_i),
		.inst_i(id_inst_i),

		.reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),

		//送到regfile的信息
		.reg1_read_o(reg1_read),
		.reg2_read_o(reg2_read), 	  

		.reg1_addr_o(reg1_addr),
		.reg2_addr_o(reg2_addr), 
	  
		//送到ID/EX模块的信息
		.aluop_o(id_aluop_o),
		.alusel_o(id_alusel_o),
		.reg1_o(id_reg1_o),
		.reg2_o(id_reg2_o),
		.wd_o(id_wd_o),
		.wreg_o(id_wreg_o),

		//mem阶段送来的信息
		.mem_wdata_i(mem_wdata_o),
		.mem_wd_i(mem_wd_o),
		.mem_wreg_i(ex_wreg_o),

		//ex阶段送来的信息
		.ex_wdata_i(ex_wdata_o),
		.ex_wd_i(ex_wd_o),
		.ex_wreg_i(ex_wreg_o),
		.stallreq(req_from_id),
		.ex_hi_i(ex_hi_o),
		.ex_lo_i(ex_lo_o),
		.ex_we(ex_we_o),
		.mem_hi_i(mem_hi_o),
		.mem_lo_i(mem_lo_o),
		.mem_we(mem_we_o),

		//送到PC_REG模块的信息
		.branch_flag_o(branch_flag_o),
		.target_addr_o(target_addr_o),

		//从ID/EX模块送来的信息
		.is_delayslot_i(is_delayslot_i),

		//送到ID/EX模块的信息
		.is_delayslot_o(is_delayslot_o),
		.next_inst_in_delayslot_o(next_inst_in_delayslot_o),
		.id_is_delayslot_o(id_is_delayslot),
		.reg3_read_o(reg3_read),
		.reg3_addr_o(reg3_addr),
		.reg3_data_i(reg3_data)
	);

  //通用寄存器Regfile例化
	regfile u_regfile(
		.clk (clk),
		.rst (rst),
		.we	(wb_wreg_i),
		.waddr (wb_wd_i),
		.wdata (wb_wdata_i),
		.re1 (reg1_read),
		.raddr1 (reg1_addr),
		.rdata1 (reg1_data),
		.re2 (reg2_read),
		.raddr2 (reg2_addr),
		.rdata2 (reg2_data),
		.re3(reg3_read),
		.raddr3(reg3_addr),
		.rdata3(reg2_data),

		.hi(wb_hi_i),
		.lo(wb_lo_i),
		.mul_we(wb_we_i),
		.flags_i(wb_flags_i)
	);

	//ID/EX模块
	id_ex u_id_ex(
		.clk(clk),
		.rst(rst),
		
		//从译码阶段ID模块传来的信息
		.id_aluop(id_aluop_o),
		.id_alusel(id_alusel_o),
		.id_reg1(id_reg1_o),
		.id_reg2(id_reg2_o),
		.id_wd(id_wd_o),
		.id_wreg(id_wreg_o),
	
		//传到执行阶段EX模块的信息
		.ex_aluop(ex_aluop_i),
		.ex_alusel(ex_alusel_i),
		.ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),
		.ex_wd(ex_wd_i),
		.ex_wreg(ex_wreg_i),
		.stall(stall),

		//从译码阶段ID模块传来的信息
		.next_inst_in_delayslot_i(next_inst_in_delayslot_o),

		//传到译码阶段ID模块的信息
		.is_delayslot_o(is_delayslot_i),

		//传到执行阶段EX模块的信息
		.ex_is_in_delayslot_o(ex_is_in_delayslot_o),
		.id_is_delayslot_i(id_is_delayslot)
	);		

	//串行除法器例化
	serial_div u_serial_div(
		.clk(clk),
		.rst(rst),
		.signed_div_i(div_signed_div_i),
		.opdata1_i(div_opdata1_i),
		.opdata2_i(div_opdata2_i),
		.start_i(div_start_i),
		.annul_i(div_annul_i),
		.result_o(div_result_o),
		.ready_o(div_ready_o)
	);
	//EX模块
	ex u_ex(
		.rst(rst),
	
		//送到执行阶段EX模块的信息
		.aluop_i(ex_aluop_i),
		.alusel_i(ex_alusel_i),
		.reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),
		.wd_i(ex_wd_i),
		.wreg_i(ex_wreg_i),
	  
	  //EX模块的输出到EX/MEM模块信息
		.wd_o(ex_wd_o),
		.wreg_o(ex_wreg_o),
		.wdata_o(ex_wdata_o),
		
		//乘除法结果保存寄存器
		.hi_o(ex_hi_o),
		.lo_o(ex_lo_o),
		.we_o(ex_we_o),
	
		//flags寄存器
		.flags(ex_flags_o),

		//流水线暂停信号
		.stallreq(req_from_ex),

		//从串行除法器传来的信息
		.result_i(div_result_o),
		.ready_i(div_ready_o),
	
		//送到串行除法器的信息
		.signed_div_o(div_signed_div_i),
		.div_start_o(div_start_i),
		.div_op1(div_opdata1_i),
		.div_op2(div_opdata2_i),
		.div_annul_i(div_annul_i),

		//从ID/EX模块传来的信息
		.ex_is_in_delayslot(ex_is_in_delayslot_o)
	);

  //EX/MEM模块
  ex_mem u_ex_mem(
		.clk(clk),
		.rst(rst),
	  
		//来自执行阶段EX模块的信息	
		.ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),
		.ex_wdata(ex_wdata_o),
		.ex_hi(ex_hi_o),
		.ex_lo(ex_lo_o),
		.ex_flags(ex_flags_o),
		.ex_we(ex_we_o),

		//送到访存阶段MEM模块的信息
		.mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),
		.mem_wdata(mem_wdata_i),

		.mem_hi(mem_hi_i),
		.mem_lo(mem_lo_i),
		.mem_we(mem_we_i),
		.mem_flags(mem_flags_i),
		.stall(stall)		       	
	);
	
  //MEM模块例化
	mem u_mem(
		.rst(rst),
	
		//来自EX/MEM模块的信息
		.wd_i(mem_wd_i),
		.wreg_i(mem_wreg_i),
		.wdata_i(mem_wdata_i),
	  	.hi_i(mem_hi_i),
		.lo_i(mem_lo_i),
		.we_i(mem_we_i),
		.flags_i(mem_flags_i),

		//送到MEM/WB模块的信息
		.wd_o(mem_wd_o),
		.wreg_o(mem_wreg_o),
		.wdata_o(mem_wdata_o),
		.hi_o(mem_hi_o),
		.lo_o(mem_lo_o),
		.we_o(mem_we_o),
		.flags_o(mem_flags_o)
	);

  //MEM/WB模块
	mem_wb u_mem_wb(
		.clk(clk),
		.rst(rst),

		//来自访存阶段MEM模块的信息	
		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),
		.mem_wdata(mem_wdata_o),
		.mem_hi(mem_hi_o),
		.mem_lo(mem_lo_o),
		.mem_we(mem_we_o),
		.mem_flags(mem_flags_o),

		//送到回写阶段的信息
		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i),
		.wb_wdata(wb_wdata_i),
		.wb_hi(wb_hi_i),
		.wb_lo(wb_lo_i),
		.wb_we(wb_we_i),
		.wb_flags(wb_flags_i),
		.stall(stall)							       	
	);

endmodule