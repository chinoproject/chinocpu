`include "defines.v"

module id(

	input wire					  	rst,
	input wire[`InstAddrBus]	  	pc_i,
	input wire[`InstBus]          	inst_i,

	input wire[`RegBus]           	reg1_data_i,
	input wire[`RegBus]           	reg2_data_i,

	//从mem阶段送来的信息，数据前推，解决数据冲突
	input wire[`RegBus]				mem_wdata_i,
	input wire[`RegAddrBus]			mem_wd_i,
	input wire						mem_wreg_i,

	//从ex阶段送来的信息，数据前推，解决数据冲突
	input wire[`RegBus]				ex_wdata_i,
	input wire[`RegAddrBus]			ex_wd_i,
	input wire						ex_wreg_i,

	//送到regfile的信息
	output reg                    	reg1_read_o,
	output reg                    	reg2_read_o,     
	output reg[`RegAddrBus]       	reg1_addr_o,
	output reg[`RegAddrBus]       	reg2_addr_o, 	      
	
	//送到执行阶段的信息
	output reg[`AluOpBus]         	aluop_o,
	output reg[`AluSelBus]        	alusel_o,
	output reg[`RegBus]           	reg1_o,
	output reg[`RegBus]           	reg2_o,
	output reg[`RegAddrBus]       	wd_o,
	output reg                    	wreg_o
);

  wire[3:0]	mem = inst_i[63:60];	//访存类型
  wire[7:0]	op	= inst_i[59:52];

  reg[`RegBus]	imm;
  reg instvalid;
  
 
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
			imm <= `ZeroWord;
			case (mem)
				`MEM_SREG:begin
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b0;
					case (op)
						`EXE_OR:begin//OR指令
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_OR_OP;
							alusel_o <= `EXE_RES_LOGIC;
							imm <= inst_i[41:10];
							wd_o <= inst_i[51:47];
							instvalid <= `InstValid;
						end
						`EXE_AND:begin
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_AND_OP;
							alusel_o <= `EXE_RES_LOGIC;
							imm <= inst_i[41:10];
							wd_o <= inst_i[51:47];
							instvalid <= `InstValid;
						end							 
						default:begin
						end
					endcase
				end
				`MEM_DREG:begin
					reg1_read_o <= 1'b1;
					reg2_read_o <= 1'b1;
					case(op)
						`EXE_OR:begin
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_OR_OP;
							alusel_o <= `EXE_RES_LOGIC;
							instvalid <= `InstInvalid;
						end
						`EXE_AND:begin
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_AND_OP;
							alusel_o <= `EXE_RES_LOGIC;
							instvalid <= `InstInvalid;
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
	

	always @ (*) begin
		if(rst == `RstEnable)
			reg1_o <= `ZeroWord;
		else if ((reg1_addr_o == 1'b1) && (ex_wreg_i == 1'b1)
					&& (ex_wd_i == reg1_addr_o))
			reg1_o <= ex_wdata_i;
		else if ((reg1_addr_o) == 1'b1 && (mem_wreg_i == 1'b1)
					&& (mem_wdata_i == reg1_addr_o))
			reg1_o <= mem_wdata_i;
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
		else if ((reg2_addr_o == 1'b1) && (ex_wreg_i == 1'b1)
					&& (ex_wdata_i == reg2_addr_o))
			reg2_o <= ex_wdata_i;
		else if ((reg2_addr_o == 1'b1) && (mem_wreg_i == 1'b1)
					&& (mem_wdata_i == reg2_addr_o))
			reg2_o <= mem_wdata_i;
		else if(reg2_read_o == 1'b1)
			reg2_o <= reg2_data_i;
		else if(reg2_read_o == 1'b0)
			reg2_o <= imm;
		else
			reg2_o <= `ZeroWord;
		end

endmodule