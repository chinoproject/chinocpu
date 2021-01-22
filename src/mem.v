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

	output reg[`RegBus]								mem_data_o,
	output reg										mem_we_o,
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
	output reg[`RegBus]								flags_o
);

	always @ (*) begin
		if(rst == `RstEnable) begin
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
		  	wdata_o <= `ZeroWord;
			hi_o <= `ZeroWord;
			lo_o <= `ZeroWord;
			flags_o <= `ZeroWord;
			we_o <= `WriteDisable;
		end else begin
		  	wd_o <= wd_i;
			wreg_o <= wreg_i;
			wdata_o <= wdata_i;
			hi_o <= hi_i;
			lo_o <= lo_i;
			we_o <= we_i;
			flags_o <= flags_i;

			case(aluop_i)
				`EXE_LOADB_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we_o <= `WriteDisable;
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
					mem_we_o <= `WriteDisable;
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
					mem_we_o <= `WriteDisable;
					mem_ce_o <= `ChipEnable;
					wdata_o <= mem_data_i;
					mem_sel_o <= 4'b1111;
				end
				`EXE_LOADBU_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we_o <= `WriteDisable;
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
					mem_we_o <= `WriteDisable;
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
					mem_we_o <= `WriteDisable;
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
					mem_we_o <= `WriteDisable;
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
					mem_we_o <= `WriteEnable;
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
					mem_we_o <= `WriteEnable;
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
					mem_we_o <= `WriteEnable;
					mem_ce_o <= `ChipEnable;
					mem_data_o <= reg2_i;
					mem_sel_o <= 4'b1111;
				end
				`EXE_STOREWL_OP: begin
					mem_addr_o <= {mem_addr_i[31:2],2'b00};
					mem_we_o <= `WriteEnable;
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
					mem_we_o <= `WriteEnable;
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
				default:begin
					mem_ce_o <= `ChipDisable;
				end
			endcase
		end    //if
	end      //always

endmodule