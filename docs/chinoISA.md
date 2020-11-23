| ChinoCPU 指令集         |    |      |              |              |    |   |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
|----------------------|----|------|--------------|--------------|----|---|---|---------|---|-------------------------|---|--------------------|---|---|---|---|---|---|---|---|---|---|---|---|---|
|                      |    |      |              |              |    |   |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
|                      |    |      |              |              |    |   |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 位运算指令                |    |      |              |              |    |   |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| or指令族                |    |      |              |              |    |   |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 42           | 37           | 36 | 0 |   |         |   | 指令行为                    |   | 备注                 |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12'b0001\_0000\_0001 |    | reg1 | reg2         | reg3         | 保留 |   |   | orrr指令  |   | reg1 = reg2 \| reg3     |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 42           | 10           | 9  | 0 |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12b'0010\_0000\_0001 |    | reg1 | reg2         | imm\(32bit\) | 保留 |   |   | orri指令  |   | reg1 = reg2 \| imm      |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 43           | 10           | 9  | 0 |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12b'0011\_0000\_0001 |    | reg1 | reg2         | addr         | 保留 |   |   | orrm指令  |   | reg1 = reg2 \| \[addr\] |   | \[addr\]指addr指向的内存 |   |   |   |   |   |   |   |   |   |   |   |   |   |
| and指令族               |    |      |              |              |    |   |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 42           | 37           | 36 | 0 |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12'b0001\_0000\_0010 |    | reg1 | reg2         | reg3         | 保留 |   |   | andrr指令 |   | reg1 = reg2 & reg3      |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 42           | 10           | 9  | 0 |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12'b0010\_0000\_0010 |    | reg1 | reg2         | imm\(32bit\) | 保留 |   |   | andri指令 |   | reg1 = reg2 & imm       |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 56 | 47   | 43           | 10           | 9  | 0 |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12'b0011\_0000\_0010 |    | reg1 | reg2         | addr         | 保留 |   |   | andrm指令 |   | reg1 = reg2 & \[addr\]  |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| xor指令族               |    |      |              |              |    |   |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 42           | 37           | 36 | 0 |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12'b0001\_0000\_0011 |    | reg1 | reg2         | reg3         | 保留 |   |   | xorrr指令 |   | reg1 = reg2  ^ reg3     |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 42           | 10           | 9  | 0 |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12'b0010\_0000\_0011 |    | reg1 | reg2         | imm\(32bit\) | 保留 |   |   | xorri指令 |   | reg1 = reg2 ^ imm       |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 42           | 10           | 9  | 0 |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12'b0011\_0000\_0011 |    | reg1 | reg2         | addr         | 保留 |   |   | xorrm指令 |   | reg1 =reg2 ^ \[addr\]   |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| not指令族               |    |      |              |              |    |   |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 42           | 0            |    |   |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12‘b0001\_0000\_0100 |    | reg1 | reg2         | 保留           |    |   |   | notrr指令 |   | reg1 = ~reg1            |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 16           | 15           |    | 0 |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12'b0010\_0001\_0100 |    | reg1 | imm\(32bit\) | 保留           |    |   |   | notri指令 |   | reg1 = ~imm             |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 63                   | 52 | 47   | 16           | 15           |    | 0 |   |         |   |                         |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |
| 12'b0011\_0010\_0100 |    | reg1 | addr         | 保留           |    |   |   | notrm指令 |   | reg1 = ~\[addr\]        |   |                    |   |   |   |   |   |   |   |   |   |   |   |   |   |