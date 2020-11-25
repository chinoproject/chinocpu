`include "defines.v"

module ex(

	input wire						rst,
	
	//送到执行阶段的信息
	input wire[`AluOpBus]         	aluop_i,
	input wire[`AluSelBus]        	alusel_i,
	input wire[`RegBus]           	reg1_i,
	input wire[`RegBus]           	reg2_i,
	input wire[`RegAddrBus]       	wd_i,
	input wire                    	wreg_i,

	
	output reg[`RegAddrBus]       	wd_o,
	output reg                    	wreg_o,
	output reg[`RegBus]				wdata_o
	
);

	reg[`RegBus] logicout;
	reg[`RegBus] shiftout;
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

 always @ (*) begin
	 wd_o <= wd_i;	 	 	
	 wreg_o <= wreg_i;
	 case (alusel_i) 
	 	`EXE_RES_LOGIC:wdata_o <= logicout;
		`EXE_RES_SHIFT:wdata_o <= shiftout;
	 	default:wdata_o <= `ZeroWord;
	 endcase
 end	

endmodule