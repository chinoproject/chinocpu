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
	output reg[`RegBus]				wdata_o,

	output reg[`RegBus]				hi_o,
	output reg[`RegBus]				lo_o,
	output reg						we_o,
	output reg[`RegBus]				flags
);

	reg[`RegBus] 			logicout;
	reg[`RegBus] 			shiftout;
	reg[`RegBus] 			movout;
	reg[`DoubleRegBus]		mulout;	//保存乘法的运算结果
	wire[`AriRegBus]		reg2_i_mux;
	wire[`AriRegBus]		result_arithmetic;

	//减法运算则计算补码
	assign reg2_i_mux = (aluop_i == `EXE_SUB_OP) ? (~{1'b0,reg2_i}) + 1:{1'b0,reg2_i};
	assign result_arithmetic = {1'b0,reg1_i} + reg2_i_mux;
	
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

	always @(*) begin
		if (rst == `RstEnable)
			flags <= `ZeroWord;
		else
			if (aluop_i == `EXE_SUB_OP || aluop_i == `EXE_ADD_OP) begin
				flags[0] <= ((!reg2_i_mux[31] && !reg1_i[31]) && result_arithmetic[31])
							|| ((reg2_i_mux[31] && reg1_i[31]) && !result_arithmetic[31]);	//溢出标志位
				flags[1] <= result_arithmetic[32];//无符号整数进位标志位
			end else
				flags <= flags;
	end

 always @ (*) begin
	 wd_o <= wd_i;	 	 	
	 wreg_o <= wreg_i;
	 case (alusel_i) 
	 	`EXE_RES_LOGIC:wdata_o <= logicout;
		`EXE_RES_SHIFT:wdata_o <= shiftout;
		`EXE_RES_MOV:wdata_o <= movout;
		`EXE_RES_ARITHMETIC:wdata_o <= result_arithmetic[31:0];
	 	default:wdata_o <= `ZeroWord;
	 endcase
 end	
endmodule