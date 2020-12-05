`include "defines.v"

module regfile(

	input	wire									clk,
	input wire										rst,
	
	//写端口
	input wire										we,
	input wire[`RegAddrBus]							waddr,
	input wire[`RegBus]								wdata,
	
	//读端口1
	input wire										re1,
	input wire[`RegAddrBus]			  				raddr1,
	output reg[`RegBus]           					rdata1,
	
	//读端口2
	input wire										re2,
	input wire[`RegAddrBus]			  				raddr2,
	output reg[`RegBus]           					rdata2,

	//读端口3
	/*input wire										re3,
	input wire[`RegAddrBus]			  				raddr3,
	output reg[`RegBus]           					rdata3,
*/
	input wire[`RegBus]								hi,
	input wire[`RegBus]								lo,
	input wire										mul_we,
	input wire[`RegBus]								flags_i
);	

	reg[`RegBus]	regs[0:`RegNum-1];
	reg[`RegBus]	flags;
	integer i;
	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
			end

			if (mul_we) begin
				regs[31] <= hi;
				regs[30] <= lo;
			end
			flags <= flags_i;
		end else begin
			for(i = 0;i < 32;i = i + 1)
				regs[i] = 0;
			flags <= `ZeroWord;
		end
	end

	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata1 <= `ZeroWord;
	  end else if(raddr1 == `RegNumLog2'h0) begin
	  		rdata1 <= `ZeroWord;
	  end else if((raddr1 == waddr) && (we == `WriteEnable) 
	  	            && (re1 == `ReadEnable)) begin
	  	  rdata1 <= wdata;
	  end else if(re1 == `ReadEnable) begin
	      rdata1 <= regs[raddr1];
	  end else begin
	      rdata1 <= `ZeroWord;
	  end
	end

	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 <= `ZeroWord;
	  end else if(raddr2 == `RegNumLog2'h0) begin
	  		rdata2 <= `ZeroWord;
	  end else if((raddr2 == waddr) && (we == `WriteEnable) 
	  	            && (re2 == `ReadEnable)) begin
	  	  rdata2 <= wdata;
	  end else if(re2 == `ReadEnable) begin
	      rdata2 <= regs[raddr2];
	  end else begin
	      rdata2 <= `ZeroWord;
	  end
	end

	/*always @(*) begin
		if(rst == `RstEnable) begin
			  rdata3 <= `ZeroWord;
	  end else if(raddr3 == `RegNumLog2'h0) begin
	  		rdata3 <= `ZeroWord;
	  end else if((raddr3 == waddr) && (we == `WriteEnable) 
	  	            && (re3 == `ReadEnable)) begin
	  	  rdata3 <= wdata;
	  end else if(re2 == `ReadEnable) begin
	      rdata3 <= regs[raddr3];
	  end else begin
	      rdata3 <= `ZeroWord;
	  end
	end*/
endmodule