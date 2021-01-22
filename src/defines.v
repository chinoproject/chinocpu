//全局
`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'h00000000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define AluOpBus 7:0
`define AluSelBus 3:0
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
`define MEM_ZREG     4'B0100 //不读取寄存器

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
`define EXE_JMP     8'b00010001
`define EXE_JNG     8'b00010010
`define EXE_JG      8'b00010011
`define EXE_JNL     8'b00010100
`define EXE_JL      8'b00010101
`define EXE_JE      8'b00010110
`define EXE_JNE     8'b00010111
`define EXE_CALL    8'b00011000
`define EXE_RET     8'b00011001
`define EXE_LOOP    8'b00011010
`define EXE_LOADB   8'b00011011
`define EXE_LOADH   8'b00011100
`define EXE_LOADW   8'b00011101
`define EXE_LOADBU  8'b00011110
`define EXE_LOADHU  8'b00011111
`define EXE_STOREB  8'b00100000
`define EXE_STOREH  8'b00100001
`define EXE_STOREW  8'b00100010
`define EXE_LOADWL  8'b00100011
`define EXE_LOADWR  8'b00100100
`define EXE_STOREWL 8'b00100101
`define EXE_STOREWR 8'b00100110

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
`define EXE_JMP_OP      8'b0001_0001
`define EXE_JNG_OP      8'b0001_0010
`define EXE_JG_OP       8'b0001_0011
`define EXE_JNL_OP      8'b0001_0100
`define EXE_JL_OP       8'b0001_0101
`define EXE_JE_OP       8'b0001_0110
`define EXE_JNE_OP      8'b0001_0111
`define EXE_CALL_OP     8'b0001_1000
`define EXE_RET_OP      8'b0001_1001
`define EXE_LOOP_OP     8'b0001_1010
`define EXE_LOADB_OP    8'b0001_1011
`define EXE_LOADH_OP    8'b0001_1100
`define EXE_LOADW_OP    8'b0001_1101
`define EXE_LOADBU_OP   8'b0001_1110
`define EXE_LOADHU_OP   8'b0001_1111
`define EXE_STOREB_OP   8'b0010_0000
`define EXE_STOREH_OP   8'b0010_0001
`define EXE_STOREW_OP   8'b0010_0010
`define EXE_LOADWL_OP   8'b0010_0011
`define EXE_LOADWR_OP   8'b0010_0100
`define EXE_STOREWL_OP  8'b0010_0101
`define EXE_STOREWR_OP  8'b0010_0110

//AluSel
`define EXE_RES_NOP                     4'b0000
`define EXE_RES_LOGIC                   4'b0001
`define EXE_RES_SHIFT                   4'b0010
`define EXE_RES_MOV                     4'b0011
`define EXE_RES_ARITHMETIC              4'b0100
`define EXE_RES_MUL                     4'b0101
`define EXE_RES_DIV                     4'b0110
`define EXE_RES_JUMP                    4'b0111
`define EXE_RES_CALL                    4'b1000
`define EXE_RES_RET                     4'B1001
`define EXE_RES_LOOP                    4'b1010
`define EXE_RES_LOAD_STORE              4'b1011

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

//ram
`define DataMemNum 131071
`define ByteWidth 7:0
`define DataMemNumLog2 17
`define DataAddrBus 31:0
`define DataBus 31:0