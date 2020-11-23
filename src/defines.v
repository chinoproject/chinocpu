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
`define ZeroDoubleWord 64'h0

//访问类型
`define MEM_SREG    4'b0010 //读一个寄存器
`define MEM_DREG    4'b0001 //读两个寄存器

//指令
`define EXE_NOP 8'b00000000
`define EXE_OR  8'b00000001
`define EXE_AND 8'b00000010
`define EXE_XOR 8'b00000011
`define EXE_NOT 8'b00000100
`define EXE_SHL 8'b00000101
`define EXE_SHR 8'b00000110

//AluOp
`define EXE_NOP_OP      8'b0000_0000
`define EXE_OR_OP       8'b0000_0001
`define EXE_AND_OP      8'b0000_0010
`define EXE_XOR_OP      8'b0000_0011
`define EXE_NOT_OP      8'b0000_0100
`define EXE_SHL_OP      8'b0000_0101
`define EXE_SHR_OP      8'b0000_0110

//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_SHIFT 3'b010
`define EXE_RES_NOP 3'b000


//指令存储器inst_rom
`define InstAddrBus 31:0
`define InstBus 63:0
`define InstMemNum 64
`define InstMemNumLog2  6


//通用寄存器regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000
