`include "defines.v"

module id(

	input wire					  	rst,
	input wire[`InstAddrBus]	  	pc_i,
	input wire[`InstBus]          	inst_i,

	input wire[`RegBus]           	reg1_data_i,
	input wire[`RegBus]           	reg2_data_i,
	//input wire[`RegBus]				reg3_data_i,

	//从mem阶段送来的信息，数据前推，解决数据冲突
	input wire[`RegBus]				mem_wdata_i,
	input wire[`RegAddrBus]			mem_wd_i,
	input wire						mem_wreg_i,

	//从ex阶段送来的信息，数据前推，解决数据冲突
	input wire[`RegBus]				ex_wdata_i,
	input wire[`RegAddrBus]			ex_wd_i,
	input wire						ex_wreg_i,


	input wire[`RegBus]				ex_hi_i,
	input wire[`RegBus]				ex_lo_i,
	input wire						ex_we,

	input wire[`RegBus]				mem_hi_i,
	input wire[`RegBus]				mem_lo_i,
	input wire						mem_we,

	//送到regfile的信息
	output reg                    	reg1_read_o,
	output reg                    	reg2_read_o, 
	//output reg 						reg3_read_o,    
	output reg[`RegAddrBus]       	reg1_addr_o,
	output reg[`RegAddrBus]       	reg2_addr_o, 	      
	//output reg[`RegAddrBus]			reg3_addr_o,

	//送到执行阶段的信息
	output reg[`AluOpBus]         	aluop_o,
	output reg[`AluSelBus]        	alusel_o,
	output reg[`RegBus]           	reg1_o,
	output reg[`RegBus]           	reg2_o,
	output reg[`RegAddrBus]       	wd_o,
	output reg                    	wreg_o,
	//送到CTRL模块的信息
	output reg    					stallreq,

	//送到PC_REG模块的信息
	output reg 						branch_flag_o,
	output reg[`RegBus]				target_addr_o,

	//送到ID/EX模块的信息
	output reg						next_inst_in_delayslot_o,
	output reg 						is_delayslot_o,
	output reg 						id_is_delayslot_o,
	//从ID/EX模块传来的信息
	input wire 						is_delayslot_i
);

  	wire[3:0]	mem = inst_i[63:60];	//访存类型
  	wire[7:0]	op	= inst_i[59:52];

  	reg[`RegBus]	imm;
	reg 			instvalid;
	wire[`RegBus] 	inst_n1;
	wire[`RegBus]	inst_n2;
	reg[`RegBus]	reg3_o;
	reg[32:0]		temp;
	assign inst_n1 = pc_i + 8;
	assign inst_n2 = pc_i + 16;
	//assign temp = reg1_o + {1'b0,~reg2_o}
	always @ (*) begin	
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= `ZeroWord;			
	  end else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[51:47];
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[46:42];
			reg2_addr_o <= inst_i[41:37];

			//目前仅有条件跳转指令使用
			//reg3_addr_o <= inst_i[41:37];		
			imm <= `ZeroWord;
			stallreq <= `NoStop;
			next_inst_in_delayslot_o <= `NotInDelaySlot;
			branch_flag_o <= `NotBranch;
			case (mem)
				`MEM_SREG:begin
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					imm <= inst_i[41:10];
					
					case (op)
						`EXE_OR:begin	//OR指令
							aluop_o <= `EXE_OR_OP;
							alusel_o <= `EXE_RES_LOGIC;
							instvalid <= `InstValid;
						end
						`EXE_AND:begin	//AND指令
							aluop_o <= `EXE_AND_OP;
							alusel_o <= `EXE_RES_LOGIC;
							instvalid <= `InstValid;
						end
						`EXE_XOR:begin	//XOR指令
							aluop_o <= `EXE_XOR_OP;
							alusel_o <= `EXE_RES_LOGIC;
							instvalid <= `InstValid;
						end
						`EXE_NOT:begin	//NOT指令
							aluop_o <= `EXE_NOT_OP;
							alusel_o <= `EXE_RES_LOGIC;
							instvalid <= `InstValid;
							imm <= inst_i[46:16];
							reg1_read_o <= 1'b0;
						end
						`EXE_SHL:begin
							aluop_o <= `EXE_SHL_OP;
							alusel_o <= `EXE_RES_SHIFT;
							instvalid <= `InstValid;
						end
						`EXE_SHR:begin
							aluop_o <= `EXE_SHR_OP;
							alusel_o <= `EXE_RES_SHIFT;
							instvalid <= `InstValid;
						end			 
						`EXE_SAR:begin
							aluop_o <= `EXE_SAR_OP;
							alusel_o <= `EXE_RES_SHIFT;
							instvalid <= `InstValid;
							imm <= {27'h0,inst_i[41:37]};
						end
						`EXE_MOV:begin
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_MOV_OP;
							alusel_o <= `EXE_RES_MOV;
							instvalid <= `InstValid;
							imm <= inst_i[46:15];
							reg1_read_o <= 1'b0;
						end
						`EXE_MOVZ:begin
							aluop_o <= `EXE_MOVZ_OP;
							alusel_o <= `EXE_RES_MOV;
							instvalid <= `InstValid;
							if (reg1_o == `ZeroWord)
								wreg_o <= `WriteEnable;
							else
								wreg_o <= `WriteDisable;
						end
						`EXE_MOVN:begin
							aluop_o <= `EXE_MOVN_OP;
							alusel_o <= `EXE_RES_MOV;
							instvalid <= `InstValid;
							if (reg1_o != `ZeroWord)
								wreg_o <= `WriteEnable;
							else
								wreg_o <= `WriteDisable;
						end
						`EXE_ADD:begin
							aluop_o <= `EXE_ADD_OP;
							alusel_o <= `EXE_RES_ARITHMETIC;
							instvalid <= `InstValid;
							wreg_o <= `WriteEnable;
						end
						`EXE_SUB:begin
							aluop_o <= `EXE_SUB_OP;
							alusel_o <= `EXE_RES_ARITHMETIC;
							instvalid <= `InstValid;
							wreg_o <= `WriteEnable;
						end
						`EXE_MULT:begin
							aluop_o <= `EXE_MULT_OP;
							alusel_o <= `EXE_RES_MUL;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							reg1_addr_o <= inst_i[51:47];
							imm <= inst_i[46:15];
						end
						`EXE_DIV:begin
							aluop_o <= `EXE_DIV_OP;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_DIV;
							reg1_addr_o <= inst_i[51:47];
							imm <= inst_i[46:15];
							//reg2_addr_o <= inst_i[46:42];
						end
						`EXE_MULTU:begin
							aluop_o <= `EXE_MULTU_OP;
							alusel_o <= `EXE_RES_MUL;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							reg1_addr_o <= inst_i[51:47];
							imm <= inst_i[46:15];
						end
						`EXE_DIVU:begin
							aluop_o <= `EXE_DIVU_OP;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_DIV;
							reg1_addr_o <= inst_i[51:47];
							imm <= inst_i[46:15];
						end
						`EXE_JMP:begin
							aluop_o <= `EXE_JMP_OP;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_JUMP;
							target_addr_o <= inst_i[51:20];
							branch_flag_o <= `Branch;
							next_inst_in_delayslot_o <= `InDelaySlot;
						end
						`EXE_JNG:begin
							aluop_o <=`EXE_JNG_OP;
							instvalid <=`InstValid;
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_JUMP; 
							reg1_addr_o <= inst_i[51:47];
							reg2_addr_o <= inst_i[46:42];
							reg2_read_o <= 1'b1;
							temp = {1'b0,reg1_o} + (~{1'b0,reg2_o}) + 1;

							if (temp[32] != 1 || temp == 0) begin
								branch_flag_o <= `Branch;
								target_addr_o <= inst_i[41:10];
								next_inst_in_delayslot_o <= `InDelaySlot;
							end else
								branch_flag_o <= `NotBranch;
							
						end
						`EXE_JG:begin
							aluop_o <= `EXE_JG_OP;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_JUMP;
							reg1_addr_o <= inst_i[51:47];
							reg2_addr_o <= inst_i[46:42];
							reg2_read_o <= 1'b1;
							temp <= {1'b0,reg1_o} + (~{1'b0,reg2_o}) + 1;

							if (temp[32] != 1) begin
								branch_flag_o <= `Branch;
								target_addr_o <= inst_i[41:10];
								next_inst_in_delayslot_o <= `InDelaySlot;
							end else
								branch_flag_o <= `NotBranch;

						end
						`EXE_JNL:begin
							aluop_o <= `EXE_JNL_OP;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							reg1_addr_o <= inst_i[51:47];
							reg2_addr_o <= inst_i[46:42];
							reg2_read_o <= 1'b1;
							temp = {1'b0,reg1_o} + (~{1'b0,reg2_o}) + 1;

							if (temp[32] == 1 || temp == 0) begin
								branch_flag_o <= `Branch;
								target_addr_o <= inst_i[41:10];
								next_inst_in_delayslot_o <= `InDelaySlot;
							end else
								branch_flag_o <= `NotBranch;

						end
						`EXE_JL:begin
							aluop_o <= `EXE_JL_OP;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							reg1_addr_o <= inst_i[51:47];
							reg2_addr_o <= inst_i[46:42];
							reg2_read_o <= 1'b1;
							temp <= {1'b0,reg1_o} + (~{1'b0,reg1_o}) + 1;

							if (temp[32] == 1) begin
								branch_flag_o <= `Branch;
								target_addr_o <= inst_i[41:10];
								next_inst_in_delayslot_o <= `InDelaySlot;
							end else
								branch_flag_o <= `NotBranch;
						end
						`EXE_JE:begin
							aluop_o <= `EXE_JE_OP;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							reg1_addr_o <= inst_i[51:47];
							reg2_addr_o <= inst_i[46:42];
							reg2_read_o <= 1'b1;
							temp <= {1'b0,reg1_o} + (~{1'b0,reg2_o}) + 1;

							if (temp == 0) begin
								branch_flag_o <= `Branch;
								target_addr_o <= inst_i[41:10];
								next_inst_in_delayslot_o <= `InDelaySlot;
							end else
								branch_flag_o <= `NotBranch;
						end
						`EXE_JNE:begin
							aluop_o <= `EXE_JNE_OP;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							reg1_addr_o <= inst_i[51:47];
							reg2_addr_o <= inst_i[46:42];
							reg2_read_o <= 1'b1;
							temp <= {1'b0,reg1_o} + (~{1'b0,reg2_o}) + 1;

							if (temp != 0) begin
								branch_flag_o <= `Branch;
								target_addr_o <= inst_i[41:10];
								next_inst_in_delayslot_o <= `InDelaySlot;
							end else
								branch_flag_o <= `NotBranch;
						end
						/*`EXE_CALL:begin
						end
						`EXE_RET:begin
						end
						`EXE_LOOP:begin
						end*/
						default:begin
						end
					endcase
				end
				`MEM_DREG:begin
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b1;
					wreg_o <= `WriteEnable;

					case(op)
						`EXE_OR:begin
							aluop_o <= `EXE_OR_OP;
							alusel_o <= `EXE_RES_LOGIC;
							instvalid <= `InstValid;
						end
						`EXE_AND:begin
							aluop_o <= `EXE_AND_OP;
							alusel_o <= `EXE_RES_LOGIC;
							instvalid <= `InstValid;
						end
						`EXE_XOR:begin
							aluop_o <= `EXE_XOR_OP;
							alusel_o <= `EXE_RES_LOGIC;
							instvalid <= `InstValid;
						end
						`EXE_NOT:begin
							aluop_o <= `EXE_NOT_OP;
							alusel_o <= `EXE_RES_LOGIC;
							instvalid <= `InstValid;
							reg2_read_o <= 1'b0;
						end
						`EXE_SHL:begin
							aluop_o <= `EXE_SHL_OP;
							alusel_o <= `EXE_RES_SHIFT;
							instvalid <= `InstValid;
						end
						`EXE_SHR:begin
							aluop_o <= `EXE_SHR_OP;
							alusel_o <= `EXE_RES_SHIFT;
							instvalid <= `InstValid;
						end
						`EXE_SAR:begin
							aluop_o <= `EXE_SAR_OP;
							alusel_o <= `EXE_RES_SHIFT;
							instvalid <= `InstValid;
						end
						`EXE_MOV:begin
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_MOV_OP;
							alusel_o <= `EXE_RES_MOV;
							instvalid <= `InstValid;
							reg2_read_o <= 1'b0;
						end
						`EXE_MOVZ:begin
							aluop_o <= `EXE_MOVZ_OP;
							alusel_o <= `EXE_RES_MOV;
							instvalid <= `InstValid;
							if (reg1_o == `ZeroWord)
								wreg_o <= `WriteEnable;
							else
								wreg_o <= `WriteDisable;
						end
						`EXE_MOVN:begin
							aluop_o <= `EXE_MOVN_OP;
							alusel_o <= `EXE_RES_MOV;
							instvalid <= `InstValid;
							if (reg1_o != `ZeroWord)
								wreg_o <= `WriteEnable;
							else
								wreg_o <= `WriteDisable;
						end
						`EXE_ADD:begin
							aluop_o <= `EXE_ADD_OP;
							alusel_o <= `EXE_RES_ARITHMETIC;
							instvalid <= `InstValid;
							//wreg_o <= `WriteEnable;
						end
						`EXE_SUB:begin
							aluop_o <= `EXE_SUB_OP;
							alusel_o <= `EXE_RES_ARITHMETIC;
							instvalid <= `InstValid;
							//wreg_o <= `WriteEnable;	
						end
						`EXE_MULT:begin
							aluop_o <= `EXE_MULT_OP;
							alusel_o <= `EXE_RES_MUL;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							reg1_addr_o <= inst_i[51:47];
							reg2_addr_o <= inst_i[46:42];
						end
						`EXE_DIV:begin
							aluop_o <= `EXE_DIV_OP;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_DIV;
							reg1_addr_o <= inst_i[51:47];
							reg2_addr_o <= inst_i[46:42];
						end
						`EXE_MULTU:begin
							aluop_o <= `EXE_MULTU_OP;
							alusel_o <= `EXE_RES_MUL;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							reg1_addr_o <= inst_i[51:47];
							reg2_addr_o <= inst_i[46:42];
						end
						`EXE_DIVU:begin
							aluop_o <= `EXE_DIVU_OP;
							instvalid <= `InstValid;
							wreg_o <= `WriteDisable;
							alusel_o <= `EXE_RES_DIV;
							reg1_addr_o <= inst_i[51:47];
							reg2_addr_o <= inst_i[46:42];
						end
						default:begin
						end
					endcase
				end
				default:begin
				end
			endcase
		end       //if
	end         //always
	
	always @(*) begin
		id_is_delayslot_o <= is_delayslot_i;
	end
	always @ (*) begin
		if(rst == `RstEnable)
			reg1_o <= `ZeroWord;
		else if ((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1)
					&& (ex_wd_i == reg1_addr_o))
			reg1_o <= ex_wdata_i;
		else if ((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1)
					&& (mem_wd_i == reg1_addr_o))
			reg1_o <= mem_wdata_i;
		else if ((reg1_read_o == 1'b1) && (ex_we == 1'b1)
					&& (reg1_addr_o == 30))
			reg1_o <= ex_lo_i;
		else if ((reg1_read_o == 1'b1) && (ex_we == 1'b1)
					&& (reg1_addr_o == 31))
			reg1_o <= ex_hi_i;
		else if ((reg1_read_o == 1'b1) && (mem_we == 1'b1)
					&& (reg1_addr_o == 30))
			reg1_o <= mem_lo_i;
		else if ((reg1_read_o == 1'b1) && (ex_we == 1'b1)
					&& (reg1_addr_o == 31))
			reg1_o <= mem_hi_i;
	  	else if(reg1_read_o == 1'b1)
	  		reg1_o <= reg1_data_i;
	  	else if(reg1_read_o == 1'b0)
	  		reg1_o <= imm;
	  	else
	    	reg1_o <= `ZeroWord;
	end
	
	always @ (*) begin
		if(rst == `RstEnable)
			reg2_o <= `ZeroWord;
		else if ((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1)
					&& (ex_wd_i == reg2_addr_o))
			reg2_o <= ex_wdata_i;
		else if ((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1)
					&& (mem_wd_i == reg2_addr_o))
			reg2_o <= mem_wdata_i;
		else if ((reg2_read_o == 1'b1) && (ex_we == 1'b1)
					&& (reg2_addr_o == 30))
			reg2_o <= ex_lo_i;
		else if ((reg2_read_o == 1'b1) && (ex_we == 1'b1)
					&& (reg2_addr_o == 31))
			reg2_o <= ex_hi_i;
		else if ((reg2_read_o == 1'b1) && (mem_we == 1'b1)
					&& (reg2_addr_o == 30))
			reg2_o <= mem_lo_i;
		else if ((reg2_read_o == 1'b1) && (mem_we == 1'b1)
					&& (reg2_addr_o == 31))
			reg2_o <= mem_hi_i;
		else if(reg2_read_o == 1'b1)
			reg2_o <= reg2_data_i;
		else if(reg2_read_o == 1'b0)
			reg2_o <= imm;
		else
			reg2_o <= `ZeroWord;
		end

/*	always @ (*) begin
		if(rst == `RstEnable)
			reg3_o <= `ZeroWord;
		else if ((reg3_read_o == 1'b1) && (ex_wreg_i == 1'b1)
					&& (ex_wd_i == reg3_addr_o))
			reg3_o <= ex_wdata_i;
		else if ((reg3_read_o == 1'b1) && (mem_wreg_i == 1'b1)
					&& (mem_wd_i == reg3_addr_o))
			reg3_o <= mem_wdata_i;
		else if ((reg3_read_o == 1'b1) && (ex_we == 1'b1)
					&& (reg3_addr_o == 30))
			reg3_o <= ex_lo_i;
		else if ((reg3_read_o == 1'b1) && (ex_we == 1'b1)
					&& (reg3_addr_o == 31))
			reg3_o <= ex_hi_i;
		else if ((reg3_read_o == 1'b1) && (mem_we == 1'b1)
					&& (reg3_addr_o == 30))
			reg3_o <= mem_lo_i;
		else if ((reg3_read_o == 1'b1) && (mem_we == 1'b1)
					&& (reg3_addr_o == 31))
			reg3_o <= mem_hi_i;
		else if(reg3_read_o == 1'b1)
			reg3_o <= reg3_data_i;
		else if(reg3_read_o == 1'b0)
			reg3_o <= imm;
		else
			reg3_o <= `ZeroWord;
		end*/
endmodule