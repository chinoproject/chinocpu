#mtc/mfc指令测试
mov $1,0xf
mtc $11,$1

or $1,$1,65536
or $1,$1,0x401
mtc $12,$1
mfc $12,$2
_loop:
jmp _loop