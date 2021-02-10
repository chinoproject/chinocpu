`include "defines.v"

module mem(

	input wire										rst,
	
	//来自执行阶段的信息	
	input wire[`RegAddrBus]       					wd_i,
	input wire                    					wreg_i,
	input wire[`RegBus]					  			wdata_i,

	//乘法结果
	input wire[`RegBus]								hi_i,
	input wire[`RegBus]								lo_i,
	input wire										we_i,

	//flags寄存器
	input wire[`RegBus]								flags_i,

	input wire[`RegBus]								mem_addr_i,
	input wire[`AluOpBus]							aluop_i,
	input wire[`RegBus]								mem_data_i,
	input wire[`RegBus]								reg2_i,

	input wire 										llbit_i,
	input wire  									wb_llbit_we_i,
	input wire  									wb_llbit_value_i,

	input wire  									cp0_reg_we_i,
	input wire[`RegAddrBus]							cp0_reg_waddr_i,
	input wire[`RegBus]								cp0_reg_data_i,

	input wire[`RegBus]								excepttype_i,
	input wire  									is_in_delayslot_i,
	input wire[`RegBus]								current_inst_address_i,

	input wire[`RegBus]								cp0_status_i,
	input wire[`RegBus]								cp0_cause_i,
	input wire[`RegBus]								cp0_epc_i,
	input wire  									wb_cp0_reg_we,
	input wire[`RegAddrBus]							wb_cp0_reg_waddr,
	input wire[`RegBus]								wb_cp0_reg_data,

	output reg  									llbit_we_o,
	output reg  									llbit_value_o,

	output reg[`RegBus]								mem_data_o,
	output wire										mem_we_o,
	output reg[3:0]									mem_sel_o,
	output reg[`RegBus]								mem_addr_o,
	output reg										mem_ce_o,
	
	//送到回写阶段的信息
	output reg[`RegAddrBus]      					wd_o,
	output reg                   					wreg_o,
	output reg[`RegBus]					 			wdata_o,

	output reg[`RegBus]								hi_o,
	output reg[`RegBus]								lo_o,
	output reg										we_o,
	output reg[`RegBus]								flags_o,

	output reg  									cp0_reg_we_o,
	output reg[`RegAddrBus]							cp0_reg_waddr_o,
	output reg[`RegBus]								cp0_reg_data_o,

	output reg[`RegBus]								excepttype_o,
	output wire[`RegBus]							cp0_epc_o,
	output wire  									is_in_delayslot_o,
	output wire[`RegBus]							current_inst_address_o
);
	reg llbit;
	reg[`RegBus]	cp0_status;
	reg[`RegBus]	cp0_cause;
	reg[`RegBus]	cp0_epc;
	reg  			mem_we;
	assign is_in_delayslot_o = is_in_delayslot_i;
	assign current_inst_address_o = current_inst_address_i;
	always @(*) begin
		if (rst == `RstEnable)
			cp0_epc <= `ZeroWord;
		else if ((wb_cp0_reg_we == `WriteEnable) && (wb_cp0_reg_waddr == `CP0_REG_EPC))
			cp0_epc <= wb_cp0_reg_data;
		else
			cp0_epc <= cp0_epc_i;
	end
	assign cp0_epc_o = cp0_epc;

	always @(*) begin
		if (rst == `RstEnable) begin
			cp0_cause <= `ZeroWord;
		end else if ((wb_cp0_reg_we == `WriteEnable) && (wb_cp0_reg_waddr == `CP0_REG_CAUSE)) begin
			cp0_cause[9:8] <= wb_cp0_reg_data[9:8];	//IP[1:0]字段
			cp0_cause[22] <= wb_cp0_reg_data[22];	//WP字段
			cp0_cause[23] <= wb_cp0_reg_data[23];	//IV字段
		end else begin
			cp0_cause <= cp0_cause_i;
		end
	end
	always @(*) begin
		if (rst == `RstEnable)
			cp0_status <= `ZeroWord;
		else if ((wb_cp0_reg_we == `WriteEnable) && (wb_cp0_reg_waddr == `CP0_REG_STATUS))
			cp0_status <= wb_cp0_reg_data;
		else
			cp0_status <= cp0_status_i;
	end

	always @(*) begin
		if (rst == `RstEnable) begin
			excepttype_o <= `ZeroWord;
		end else begin
			if (current_inst_address_i != `ZeroWord) begin
				if (((cp0_cause[15:8] & (cp0_status[15:8])) != 8'h00) &&
					(cp0_status[1] != 1'b0) && (cp0_status[0] == 1'b1))
					excepttype_o <= 32'h00000001;	//interrept
				else if (excepttype_i[8] == 1'b1)
					excepttype_o <= 32'h00000008;	//syscall
				else if (excepttype_i[9] == 1'b1)
					excepttype_o <= 32'h0000000a;	//inst invalid
				else if (excepttype_i[10] == 1'b1)
					excepttype_o <= 32'h0000000d;	//trap
				else if (excepttype_i[12] == 1'b1)
					excepttype_o <= 32'h0000000e;	//eret
				else
					excepttype_o <= `ZeroWord;
			end else
				excepttype_o <= `ZeroWord;
		end
	end
	//如果发生异常则取消对存储器的操作
	assign mem_we_o = mem_we & (~(|excepttype_o));

	always @ (*) begin
		if (rst == `RstEnable) begin
			llbit <= 1'b0;
		end else begin
			if (wb_llbit_we_i == 1'b1)
				llbit <= wb_llbit_value_i;
			else
				llbit <= llbit_i;
		end
	end

	always @ (*) begin
		if(rst == `RstEnable) begin
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
		  	wdata_o <= `ZeroWord;
			hi_o <= `ZeroWord;
			lo_o <= `ZeroWord;
			flags_o <= `ZeroWord;
			we_o <= `WriteDisable;
			llbit_we_o <= 1'b0;
			llbit_value_o <= 1'b0;
			cp0_reg_waddr_o <=5'b00000;
			cp0_reg_we_o <= `WriteDisable;
			cp0_reg_data_o <= `ZeroWord;
		end else begin
		  	wd_o <= wd_i;
			wreg_o <= wreg_i;
			wdata_o <= wdata_i;
			hi_o <= hi_i;
			lo_o <= lo_i;
			we_o <= we_i;
			flags_o <= flags_i;
			llbit_we_o <= 1'b0;
			llbit_value_o <= 1'b0;
			cp0_reg_we_o <= cp0_reg_we_i;
			cp0_reg_waddr_o <= cp0_reg_waddr_i;
			cp0_reg_data_o <= cp0_reg_data_i;

			case(aluop_i)
				`EXE_LOADB_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							wdata_o <= {{24{mem_data_i[31]}},mem_data_i[31:24]};
							mem_sel_o <= 4'b1000;
						end
						2'b01: begin
							wdata_o <= {{24{mem_data_i[23]}},mem_data_i[23:16]};
							mem_sel_o <= 4'b0100;
						end
						2'b10: begin
							wdata_o <= {{24{mem_data_i[15]}},mem_data_i[15:8]};
							mem_sel_o <= 4'b0010;
						end
						2'b11: begin
							wdata_o <= {{24{mem_data_i[7]}},mem_data_i[7:0]};
							mem_sel_o <= 4'b0001;
						end
						default: wdata_o <= `ZeroWord;
					endcase
				end
				`EXE_LOADH_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							wdata_o <= {{24{mem_data_i[31]}},mem_data_i[31:16]};
							mem_sel_o <= 4'b1100;
						end
						2'b10: begin
							wdata_o <= {{24{mem_data_i[15]}},mem_data_i[15:0]};
							mem_sel_o <= 4'b0011;
						end
						default: wdata_o <= `ZeroWord;
					endcase
				end
				`EXE_LOADW_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					mem_ce_o <= `ChipEnable;
					wdata_o <= mem_data_i;
					mem_sel_o <= 4'b1111;
				end
				`EXE_LOADBU_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							wdata_o <= {{24{1'b0}},mem_data_i[31:24]};
							mem_sel_o <= 4'b1000;
						end
						2'b01: begin
							wdata_o <= {{24{1'b0}},mem_data_i[23:16]};
							mem_sel_o <= 4'b0100;
						end
						2'b10: begin
							wdata_o <= {{24{1'b0}},mem_data_i[15:8]};
							mem_sel_o <= 4'b0010;
						end
						2'b11: begin
							wdata_o <= {{24{1'b0}},mem_data_i[7:0]};
							mem_sel_o <= 4'b0001;
						end
						default: wdata_o <= `ZeroWord;
					endcase
				end
				`EXE_LOADHU_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteDisable;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							wdata_o <= {{16{1'b0}},mem_data_i[31:16]};
							mem_sel_o <= 4'b1100;
						end
						2'b10: begin
							wdata_o <= {{16{1'b0}},mem_data_i[15:0]};
							mem_sel_o <= 4'b0011;
						end
						default: wdata_o <= `ZeroWord;
					endcase
				end
				`EXE_LOADWL_OP: begin
					mem_addr_o <= {mem_addr_i[31:2],2'b00};
					mem_we <= `WriteDisable;
					mem_sel_o <= 4'b1111;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: wdata_o <= mem_data_i;
						2'b01: wdata_o <= {mem_data_i[23:0],reg2_i[7:0]};
						2'b10: wdata_o <= {mem_data_i[15:0],reg2_i[15:0]};
						2'b11: wdata_o <= {mem_data_i[7:0],reg2_i[23:0]};
						default: wdata_o <= `ZeroWord;
					endcase
				end
				`EXE_LOADWR_OP: begin
					mem_addr_o <= {mem_addr_i[31:2],2'b00};
					mem_we <= `WriteDisable;
					mem_sel_o <= 4'b1111;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: wdata_o <= {reg2_i[31:8],mem_data_i[31:24]};
						2'b01: wdata_o <= {reg2_i[31:16],mem_data_i[31:16]};
						2'b10: wdata_o <= {reg2_i[31:24],mem_data_i[31:8]};
						2'b11: wdata_o <= mem_data_i;
						default: wdata_o <= `ZeroWord;
					endcase
				end
				`EXE_STOREB_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteEnable;
					mem_data_o <= {reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: mem_sel_o <= 4'b1000;
						2'b01: mem_sel_o <= 4'b0100;
						2'b10: mem_sel_o <= 4'b0010;
						2'b11: mem_sel_o <= 4'b0001;
						default: mem_sel_o <= 4'b0000;
					endcase
				end
				`EXE_STOREH_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteEnable;
					mem_ce_o <= `ChipEnable;
					mem_data_o <= {reg2_i[15:0],reg2_i[15:0]};
					case(mem_addr_i[1:0])
						2'b00: mem_sel_o <= 4'b1100;
						2'b10: mem_sel_o <= 4'b0011;
						default: mem_sel_o <= 4'b0000;
					endcase
				end
				`EXE_STOREW_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteEnable;
					mem_ce_o <= `ChipEnable;
					mem_data_o <= reg2_i;
					mem_sel_o <= 4'b1111;
				end
				`EXE_STOREWL_OP: begin
					mem_addr_o <= {mem_addr_i[31:2],2'b00};
					mem_we <= `WriteEnable;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							mem_sel_o <= 4'b1111;
							mem_data_o <= reg2_i;
						end
						2'b01: begin
							mem_sel_o <= 4'b0111;
							mem_data_o <= {{8{1'b0}},reg2_i[31:8]};
						end
						2'b10: begin
							mem_sel_o <= 4'b0011;
							mem_data_o <= {{16{1'b0}},reg2_i[31:16]};
						end
						2'b11: begin
							mem_sel_o <= 4'b0001;
							mem_data_o <= {{24{1'b0}},reg2_i[31:24]};
						end
						default: mem_sel_o <= 4'b0000;
					endcase
				end
				`EXE_STOREWR_OP: begin
					mem_addr_o <= {mem_addr_i[31:2],2'b00};
					mem_we <= `WriteEnable;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							mem_sel_o <= 4'b1000;
							mem_data_o <= {reg2_i[7:0],{{24{1'b0}}}};
						end
						2'b01: begin
							mem_sel_o <= 4'b1100;
							mem_data_o <= {reg2_i[15:0],{{16{1'b0}}}};
						end
						2'b10: begin
							mem_sel_o <= 4'b1110;
							mem_data_o <= {reg2_i[23:0],{{8{1'b0}}}};
						end
						2'b11: begin
							mem_sel_o <= 4'b1111;
							mem_data_o <= reg2_i;
						end
						default: mem_sel_o <= 4'b0000;
					endcase
				end
				`EXE_LLOAD_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `WriteEnable;
					wdata_o <= mem_data_i;
					llbit_we_o <= 1'b1;
					llbit_value_o <= 1'b1;
					mem_sel_o <= 4'b1111;
					mem_ce_o <= `ChipEnable;
				end
				`EXE_STOREC_OP: begin
					if (llbit == 1'b1) begin
						llbit_we_o <= 1'b1;
						llbit_value_o <= 1'b0;
						mem_addr_o <= mem_addr_i;
						mem_we <= `WriteEnable;
						mem_data_o <= reg2_i;
						wdata_o <= 32'h1;
						mem_sel_o <= 4'b1111;
						mem_ce_o <= `ChipEnable;
					end
				end
				default:begin
					mem_ce_o <= `ChipDisable;
				end
			endcase
		end    //if
	end      //always

endmodule