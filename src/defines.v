//全局
`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'h00000000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define AluOpBus 7:0
`define AluSelBus 2:0
`define InstValid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define NoStop 1'b0
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define Branch 1'b1
`define NotBranch 1'b0
`define InterruptAssert 1'b1
`define InterruptNotAssert 1'b0
`define TrapAssert 1'b1
`define TrapNotAssert 1'b0
`define True_v 1'b1
`define False_v 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0
`define ZeroDoubleWord 64'h0000000000000000
`define Stop 1'b1
`define NoStop 1'b0
`define DivResNotReady 1'b0
`define DivResReady 1'b1
`define DivStop 1'b0
`define DivStart 1'b1

//访问类型
`define MEM_SREG    4'b0010 //读一个寄存器
`define MEM_DREG    4'b0001 //读两个寄存器

//指令
`define EXE_NOP     8'b00000000
`define EXE_OR      8'b00000001
`define EXE_AND     8'b00000010
`define EXE_XOR     8'b00000011
`define EXE_NOT     8'b00000100
`define EXE_SHL     8'b00000101
`define EXE_SHR     8'b00000110
`define EXE_SAR     8'b00000111
`define EXE_MOV     8'b00001000
`define EXE_MOVZ    8'b00001001
`define EXE_MOVN    8'b00001010
`define EXE_ADD     8'b00001011
`define EXE_SUB     8'b00001100
`define EXE_MULT    8'b00001101
`define EXE_DIV     8'b00001110
`define EXE_MULTU   8'b00001111
`define EXE_DIVU    8'b00010000

//AluOp
`define EXE_NOP_OP      8'b0000_0000
`define EXE_OR_OP       8'b0000_0001
`define EXE_AND_OP      8'b0000_0010
`define EXE_XOR_OP      8'b0000_0011
`define EXE_NOT_OP      8'b0000_0100
`define EXE_SHL_OP      8'b0000_0101
`define EXE_SHR_OP      8'b0000_0110
`define EXE_SAR_OP      8'b0000_0111
`define EXE_MOV_OP      8'b0000_1000
`define EXE_MOVZ_OP     8'b0000_1001
`define EXE_MOVN_OP     8'b0000_1010
`define EXE_ADD_OP      8'b0000_1011
`define EXE_SUB_OP      8'b0000_1100
`define EXE_MULT_OP     8'b0000_1101
`define EXE_DIV_OP      8'b0000_1110
`define EXE_MULTU_OP    8'b0000_1111
`define EXE_DIVU_OP     8'b0001_0000

//AluSel
`define EXE_RES_NOP         3'b000
`define EXE_RES_LOGIC       3'b001
`define EXE_RES_SHIFT       3'b010
`define EXE_RES_MOV         3'b011
`define EXE_RES_ARITHMETIC  3'b100
`define EXE_RES_MUL         3'b101
`define EXE_RES_DIV         3'b110

//指令存储器inst_rom
`define InstAddrBus 31:0
`define InstBus 63:0
`define InstMemNum 64
`define InstMemNumLog2  6


//通用寄存器regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define AriRegBus 32:0  //除乘法之外的运算
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000
