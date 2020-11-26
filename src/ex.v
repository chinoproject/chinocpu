`include "defines.v"

module ex(

	input wire						rst,
	
	//从ID阶段传来的消息
	input wire[`AluOpBus]         	aluop_i,
	input wire[`AluSelBus]        	alusel_i,
	input wire[`RegBus]           	reg1_i,
	input wire[`RegBus]           	reg2_i,
	input wire[`RegAddrBus]       	wd_i,
	input wire                    	wreg_i,

	//输出到MEM阶段的信息
	output reg[`RegAddrBus]       	wd_o,
	output reg                    	wreg_o,
	output reg[`RegBus]				wdata_o
	
);

	reg[`RegBus] logicout;
	reg[`RegBus] shiftout;
	reg[`RegBus] movout;
	reg			 we;
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_OR_OP:logicout <= reg1_i | reg2_i;
				`EXE_AND_OP:logicout <= reg1_i & reg2_i;
				`EXE_XOR_OP:logicout <= reg1_i ^ reg2_i;
				`EXE_NOT_OP:logicout <= ~reg1_i;
				default:logicout <= `ZeroWord;
			endcase
		end    //if
	end      //always

	always @(*) begin
		if (rst == `RstEnable) begin
			shiftout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SHL_OP:shiftout <= reg1_i << reg2_i[4:0];
				`EXE_SHR_OP:shiftout <= reg1_i >> reg2_i[4:0];
				//算术右移
				`EXE_SAR_OP:begin
					shiftout <= ({32{reg1_i[31]}} << (6'd32-{1'b0, reg2_i[4:0]})) 
								| reg1_i >> reg2_i[4:0];
				end
				default:shiftout <= `ZeroWord;
			endcase
		end
	end

	always @(*) begin
		if (rst == `RstEnable)
			movout <= `ZeroWord;
		else begin
			case(aluop_i)
				`EXE_MOV_OP:movout <= reg1_i;
				`EXE_MOVZ_OP:movout <= reg2_i;
				`EXE_MOVN_OP:movout <= reg2_i;
				default:begin
				end
			endcase
		end
	end

 always @ (*) begin
	 wd_o <= wd_i;	 	 	
	 wreg_o <= wreg_i;
	 case (alusel_i) 
	 	`EXE_RES_LOGIC:wdata_o <= logicout;
		`EXE_RES_SHIFT:wdata_o <= shiftout;
		`EXE_RES_MOV:wdata_o <= movout;
	 	default:wdata_o <= `ZeroWord;
	 endcase
 end	
endmodule