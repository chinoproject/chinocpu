#syscall异常测试
_start:
    jmp _main
    nop

    .org 0x40
    mov $1,0x800
    mov $1,0x900
    mfc $14,$1
    add $1,$1,0x8
    mtc $14,$1
    eret
    nop

.org 0x100
_main:
    mov $1,0x100
    storew $1,$0,0
    syscall
    loadw $2,$0,0

_loop:
    jmp _loop
    nop