#syscall异常测试
_start:
    jmp _main
    nop

    .org 0x20
    add $2,$2,1
    mfc $11,$1
    add $1,$1,100
    mtc $11,$1
    eret
    nop

.org 0x100
_main:
    mov $2,0
    mov $1,100
    mtc $11,$1
    mov $1,0x10000401
    mtc $12,$1

_loop:
    jmp _loop
    nop